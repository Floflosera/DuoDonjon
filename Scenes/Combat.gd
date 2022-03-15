extends Node

#Signal qui permet de savoir lorsque le déroulement d'un tour se termine de "deroulementTour()"
signal derouleTourFini
#Signal annonçant la fin de la fonction "actionCombattant(combattant)"
signal actionFinie
#Signal annonçant la fin de l'affichage du texte en haut de l'écran
signal narraTextFini

#Les variables de langues devront être mises sur le script principal et transférer dans les scènes suivantes
#qui en ont besoin, pour l'instant la transmission n'est pas instantanné donc ça n'est pas directement possible
onready var fr = true
onready var en = false

#On stocke chaque combattant dans des variables pour accéder plus facilement à leur informations et méthode
onready var combattantHarry = $GeneralInterface/HBoxContainer/Harry
onready var combattantFlaux = $GeneralInterface/HBoxContainer/Flaux

#On stocke chaque combattant dans un tableau pour pouvoir gérer leur tour
onready var combattants
#On stocke l'ordre initial des combattants
onready var combattantsBase
#On définie une variable pour le label de narration
onready var nar = $CadreNarrateur/DescriptionAction

#Variable utilisée pour faire des permutations
var temp
#Variable utilisée pour l'affichage progressif des textes
var textTemp = ""

#texte affiché lorsqu'un personnage revient au combat
var textPV0revive = ""

#utilisé par le boss final pour savoir qui tappe et pour contre-attaquer
var iActuel

#Numéro du tour
onready var nTour = 0
#Nombre de tour depuis qu'un des deux alliés est tombé KO
onready var nTourPV0 = 0

onready var hintFlag = false

func _ready():
	nar.set_text("")
	charger_others() #charger les textes "autres"

#ordre des tours en tri par Extractions, combattants classés par vitesse du plus rapide au plus lent
func ordreTour():
	var k
	for i in range(combattants.size()-1,0,-1):
		k = i
		for j in range(i-1):
			if(combattants[j].vitesse < combattants[k].vitesse):
				k = j
		if(i-1 == 0):	#étrangement godot ne fait pas les boucle de 0 à 0, donc j'en ai fait un cas particulier
			if(combattants[0].vitesse < combattants[k].vitesse):
				k = 0
		if(k != i):
			temp = combattants[i]
			combattants[i] = combattants[k]
			combattants[k] = temp

#Lance l'action choisie du combattant
func actionCombattant(combattant):
	combattant.castSkill()
	yield(combattant, "skillFinished")
	$TimerActions.start()
	yield($TimerActions, "timeout")
	emit_signal("actionFinie")

#Déroulement des actions d'un tour en fonction des priorités et vitesses
func deroulementTour():
	
	#Lance les choix de compétence de chaque ennemis du groupe ennemi
	for i in range(combattants.size()):
		if(combattants[i].ennemi && combattants[i].pv > 0):
			combattants[i].choixSkill()
	
	$TimerActions.start()					#Les timers permettent de voir les actions de manière plus clair
	yield($TimerActions, "timeout")
	#Boucle pour lancer le tour des personnages qui utilisent une action prioritaire
	for i in range(combattantsBase.size()):
		if(combattantsBase[i].priorite && combattantsBase[i].tourEffectue == false):
			iActuel = i
			narraText(combattantsBase[i].aTextSkill()) #les narraText() permettent d'afficher l'action effectuée
			yield(self,"narraTextFini")
			actionCombattant(combattantsBase[i]) #lance l'action choisie
			yield(self,"actionFinie")
			if(combattantsBase[i].secondText): #si l'action a un texte après son utilisation, alors...
				narraText(combattantsBase[i].aTextSkill2()) #on affiche son 2e affichage de texte
				yield(self,"narraTextFini")
				combattantsBase[i].secondText = false
	
	ordreTour()
	
	for i in range(combattants.size()):		#On parcourt le tableau des combattants
		if(combattants[i].tourEffectue == false):#Si le tour du combattant n'a pas encore eu lieu (via attaque prio)
			iActuel = i
			narraText(combattants[i].aTextSkill())
			yield(self,"narraTextFini")
			actionCombattant(combattants[i])
			yield(self,"actionFinie")
			if(combattants[i].secondText):
				narraText(combattants[i].aTextSkill2())
				yield(self,"narraTextFini")
				combattants[i].secondText = false
	
	get_tree().call_group("EnnemiGroupe", "clearCible") #on fait oublié aux ennemis par qui ils ont été ciblés
	get_tree().call_group("CombattantGroupe", "clearThings") #on actualise les effets qui affaiblissent ou boost
	
	if(nTourPV0 == 0 && (combattantHarry.pv==0 || combattantFlaux.pv==0)):
		nTourPV0 += 1
	elif(nTourPV0 > 0 && nTourPV0 < 2):
		nTourPV0 +=1
	elif(nTourPV0 == 2):
		if(combattantHarry.pv == 0 && combattantFlaux.pv > 0):
			combattantHarry.soinPV(combattantHarry.pvmax*0.4)
			narraText(combattantHarry.nom+textPV0revive)
			yield(self,"narraTextFini")
		elif(combattantFlaux.pv == 0 && combattantHarry.pv > 0):
			combattantFlaux.soinPV(combattantFlaux.pvmax*0.4)
			narraText(combattantFlaux.nom+textPV0revive)
			yield(self,"narraTextFini")
		$TimerActions.start()					#Les timers permettent de voir les actions de manière plus clair
		yield($TimerActions, "timeout")
		nTourPV0 = 0
	
	emit_signal("derouleTourFini")					#Informe de la fin du déroulement des actions

#Lit le dialogue entrée en paramètre (qui est une méthode de la scène DialogueInterface)
func litDialogue(dialog):
	$DialogueInterface.show()
	#le dialogue entré en paramètre va se lancer directement
	yield($DialogueInterface, "dialogueFini") #on attend qu'il soit fini
	combattantHarry.changerSprite()
	combattantFlaux.changerSprite()
	$DialogueInterface.hide()

#fonction qui affiche le texte entré en paramètre avec une petite animation
func narraText(text):
	textTemp = "" #on vide la variable temporaire
	
	for c in text:
		textTemp += c								#le texte temporaire concatène ce caractère avec lui même
		nar.set_text(textTemp)						#On affiche ce texte temporaire
		$TimerText.start()							#On attend un peu, puis on recommence jusqu'à la fin du string
		yield($TimerText,"timeout")
		if(c == "!" || c == "?" || c == "."):		#Si on arrive à la fin d'une phrase
			$TimerText.set_wait_time(1.0)			#On attend un peu plus avant de continuer
			$TimerText.start()						#Cela permet de mettre une pause avant l'action
			yield($TimerText,"timeout")				#Mais aussi avant la prochaine phrase s'il y en a une
			$TimerText.set_wait_time(0.02)
	
	emit_signal("narraTextFini")

#Tout ce dont on a besoin pour la lecture de fichier
export(String, FILE, "*.json") var other_file	#variable qui contiendra le chemin du fichier
var other_keys = []			#tableau des éléments du fichier, avec [i] le numéro de la ligne
var other_text = ""			#text à transmettre
var current = 0					#numéro de la ligne lu

#Fonction qui dit quel fichier charger à load_dialogue et initialise dialogue_keys
func index_others():
	var other = load_others(other_file)		#Prend le fichier charger par load_dialogue
	other_keys.clear()							#Efface le précédent tableau s'il existe
	for key in other:							#Met chaque valeur du fichier dialogue
		other_keys.append(other[key])			#dans le tableau dialogue_keys

#Permet de charger le fichier dont le chemin est entré en paramètre
func load_others(file_path):
	var file = File.new()								#Créer une nouvelle variable de type fichier
	if file.file_exists(file_path):						#Si le chemin entré en paramète existe
		file.open(file_path, file.READ)					#Ouvre le fichier en lecture
		var other = parse_json(file.get_as_text())	#Le stocke dans la variable dialogue
		return other									#et le retourne

func textHere(nl):
	current == nl	#On passe à la ligne suivante pour prendre les nouvelles informations
	other_text = other_keys[current].text

const othersFR = "res://text/FR/Others.json"
const othersEN = "res://text/EN/Others.json"

func charger_others():
	if(fr):
		other_file = othersFR
	elif(en):
		other_file = othersEN
	load_others(other_file)
	index_others()
	
	textHere(0)
	textPV0revive = other_text
