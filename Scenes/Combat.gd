extends Node

#Signal qui permet de savoir lorsque le déroulement d'un tour se termine de "deroulementTour()"
signal derouleTourFini
#Signal annonçant la fin de la fonction "actionCombattant(combattant)"
signal actionFinie

signal narraTextFini

#Les variables de langues devront être mises sur le script principal et transférer dans les scènes suivantes
#qui en ont besoin, pour l'instant la transmission n'est pas instantanné donc ça n'est pas directement possible
onready var fr = true
onready var en = false

#On stocke chaque combattant dans un tableau pour pouvoir gérer leur tour
onready var combattants
onready var nar = $CadreNarrateur/DescriptionAction

#Variable utilisée pour faire des permutations
var temp
#Variable utilisée pour l'affichage progressif des textes
var textTemp = ""

onready var nTour = 0

#Définie l'ordre des tours avec un tri tournoi (le tableau est assez petit pour que ça soit court)
func ordreTour():
	for i in range(combattants.size()-1):						#On parcourt le tableau combattants
		for j in range(i+1, combattants.size()):				#avec i et j
			if(combattants[i].vitesse < combattants[j].vitesse):#Lorsque la vitesse d'un combattant à gauche
				temp = combattants[i]							#est inférieur à celle d'un autre à droite
				combattants[i] = combattants[i+1]				#alors on modifie l'ordre des combattants
				combattants[i+1] = temp							#dans le tableau

#Lance l'action choisie du combattant
func actionCombattant(combattant):
	combattant.castSkill()
	yield(combattant, "skillFinished")
	$TimerActions.start()
	yield($TimerActions, "timeout")
	emit_signal("actionFinie")

#Déroulement des actions d'un tour en fonction des priorités et vitesses
func deroulementTour():
	
	for i in range(combattants.size()):
		if(combattants[i].ennemi):
			combattants[i].choixSkill()
	
	$TimerActions.start()					#Les timers permettent de voir les actions de manière plus clair
	yield($TimerActions, "timeout")
	for i in range(combattants.size()):
		if(combattants[i].priorite && combattants[i].tourEffectue == false):
			narraText(combattants[i].aTextSkill())
			yield(self,"narraTextFini")
			actionCombattant(combattants[i])
			yield(self,"actionFinie")
			if(combattants[i].secondText):
				narraText(combattants[i].aTextSkill2())
				yield(self,"narraTextFini")
	
	for i in range(combattants.size()):		#On parcourt le tableau des combattants
		if(combattants[i].tourEffectue == false):#Si le tour du combattant n'a pas encore eu lieu (via attaque prio)
			narraText(combattants[i].aTextSkill())
			yield(self,"narraTextFini")
			actionCombattant(combattants[i])
			yield(self,"actionFinie")
			if(combattants[i].secondText):
				narraText(combattants[i].aTextSkill2())
				yield(self,"narraTextFini")
	
	get_tree().call_group("EnnemiGroupe", "clearCible")
	get_tree().call_group("CombattantGroupe", "clearThings")
	
	emit_signal("derouleTourFini")					#Informe de la fin du déroulement des actions

#Lit le dialogue entrée en paramètre (qui est une méthode de la scène DialogueInterface)
func litDialogue(dialog):
	$DialogueInterface.show()
	dialog #dialog est la méthode du dialogue choisi en entrée
	yield($DialogueInterface, "dialogueFini")
	$DialogueInterface.hide()

func narraText(text):
	textTemp = ""
	
	for c in text:
		textTemp += c								#le texte temporaire concatène ce caractère avec lui même
		nar.set_text(textTemp)						#On affiche ce texte temporaire
		$TimerText.start()							#On attend un peu, puis on recommence jusqu'à la fin du string
		yield($TimerText,"timeout")
		if(c == "!" || c == "?" || c == "."):
			$TimerText.set_wait_time(1.0)
			$TimerText.start()
			yield($TimerText,"timeout")
			$TimerText.set_wait_time(0.02)
	
	emit_signal("narraTextFini")
