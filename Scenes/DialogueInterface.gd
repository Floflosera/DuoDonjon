extends MarginContainer

#Signal qui permet d'alerter de la fin d'un dialogue
signal dialogueFini

#Variable qui indique la langue du jeu (qui sera choisi par le joueur)
onready var fr = true
onready var en = false

onready var HarryDia = get_node("../GeneralInterface/HBoxContainer/Harry")
onready var FlauxDia = get_node("../GeneralInterface/HBoxContainer/Flaux")

#Texte temporaire pour l'affichage progressif des textes
var tempTextH
var tempTextF

#Stockage du bouton de confirmation dans une variable
onready var confirmation = get_node("HBoxContainer/FlauxDia/Background/Menu/VBoxContainer/Confirm")

#Tout ce dont on a besoin pour la lecture de fichier
export(String, FILE, "*.json") var dialogue_file	#variable qui contiendra le chemin du fichier
var dialogue_keys = []			#tableau des éléments du fichier, avec [i] le numéro de la ligne
var dialogue_textHarry = ""		#variable qui va récupérer les "textHarry" du fichier
var dialogue_spHarry = 0		#variable qui va récupérer les "spHarry" du fichier
var dialogue_textFlaux = ""		#variable qui va récupérer les "textFlaux" du fichier
var dialogue_spFlaux = 0		#variable qui va récupérer les "spFlaux" du fichier
var dialogue_supOther = false	#variable qui va récupérer l'info "supOther" du fichier
var current = 0					#numéro de la ligne lu

#Fonction qui débute un dialogue
func start_dialogue():
	current = 0												#Numéro de la première ligne
	index_dialogue()										#Lance la fonction qui charge les paramètres
	dialogue_textHarry = dialogue_keys[current].textHarry	#Stocke le string associer à "textHarry" dans le fichier
	dialogue_spHarry = int(dialogue_keys[current].spHarry)	#à la ligne "current", pareil pour "textFlaux"
	dialogue_textFlaux = dialogue_keys[current].textFlaux	#pour le numéro des sprites on tranforme le string
	dialogue_spFlaux = int(dialogue_keys[current].spFlaux)	#en entier avec int()
	dialogue_supOther = bool(dialogue_keys[current].supOther)
	

#Fonction qui permet de passer à la ligne suivante, lit de la même façon sans indexer le fichier
func next_dialogue():
	current += 1	#On passe à la ligne suivante pour prendre les nouvelles informations
	dialogue_textHarry = dialogue_keys[current].textHarry
	dialogue_spHarry = int(dialogue_keys[current].spHarry)
	dialogue_textFlaux = dialogue_keys[current].textFlaux
	dialogue_spFlaux = int(dialogue_keys[current].spFlaux)
	dialogue_supOther = bool(dialogue_keys[current].supOther)

#Fonction qui dit quel fichier charger à load_dialogue et initialise dialogue_keys
func index_dialogue():
	var dialogue = load_dialogue(dialogue_file)		#Prend le fichier charger par load_dialogue
	dialogue_keys.clear()							#Efface le précédent tableau s'il existe
	for key in dialogue:							#Met chaque valeur du fichier dialogue
		dialogue_keys.append(dialogue[key])			#dans le tableau dialogue_keys

#Permet de charger le fichier dont le chemin est entré en paramètre
func load_dialogue(file_path):
	var file = File.new()								#Créer une nouvelle variable de type fichier
	if file.file_exists(file_path):						#Si le chemin entré en paramète existe
		file.open(file_path, file.READ)					#Ouvre le fichier en lecture
		var dialogue = parse_json(file.get_as_text())	#Le stocke dans la variable dialogue
		return dialogue									#et le retourne

#Fonction pour créer une boite de texte pour Harry, Flaux, mettre leur émotion
func boiteDeDia(textHarry,spHarry,textFlaux,spFlaux):
	$HBoxContainer/HarryDia.modifDia(textHarry)
	HarryDia.changerSpriteDia(spHarry)
	$HBoxContainer/FlauxDia.modifDia(textFlaux)
	FlauxDia.changerSpriteDia(spFlaux)
	confirmation.grab_focus()

#Fonction similaire mais qui permet un affichage progressif des textes
func boiteDeDiaAnim(textHarry,spHarry,textFlaux,spFlaux,supOther):
	#On commence par empêcher le joueur d'appuyer sur le bouton tout de suite
	confirmation.release_focus()
	#On change les sprites
	HarryDia.changerSpriteDia(spHarry)
	FlauxDia.changerSpriteDia(spFlaux)
	#Vide les variables temporaires
	tempTextH = ""
	tempTextF = ""
	
	#Efface la boite de texte de Flaux si sa boite est vide et que "supOther" est vrai
	#"supOther" est un booléen qu'on entre dans le fichier text qui permet de savoir
	#s'il faut supprimer la boite de dialogue non utilisé ou non
	if(textFlaux == ""):
		if(supOther):
			$HBoxContainer/FlauxDia.modifDia("")
	
	if(textHarry != ""):
		#Vide la boite de dialogue actuelle
		$HBoxContainer/HarryDia.modifDia("")
		#Pour chaque caractère de la variable "textHarry", c prend la valeur du caractère
		for c in textHarry:
			tempTextH += c								#le texte temporaire concatène ce caractère avec lui même
			$HBoxContainer/HarryDia.modifDia(tempTextH)	#On affiche ce texte temporaire
			$TimerDia.start()							#On attend un peu, puis on recommence jusqu'à la fin du string
			yield($TimerDia,"timeout")
			if Input.is_action_pressed("ui_select"):		#Si le joueur appuie sur une touche de validation
				$HBoxContainer/HarryDia.modifDia(textHarry)	#Alors on affiche tout le texte directement
				break										#Puis on termine la boucle
	else:
		if(supOther): #même supOther mais pour Harry
			$HBoxContainer/HarryDia.modifDia("")
	
	if(textFlaux != ""):
		$HBoxContainer/FlauxDia.modifDia("")
		#On fait la même chose avec le texte de Flaux, si le personnage ne parle pas alors on sort direct du for
		for c in textFlaux:
			tempTextF += c
			$HBoxContainer/FlauxDia.modifDia(tempTextF)
			$TimerDia.start()
			yield($TimerDia,"timeout")
			if Input.is_action_pressed("ui_select"):
				$HBoxContainer/FlauxDia.modifDia(textFlaux)
				break
	
	#À la fin, on redonne le focus du bouton de confirmation au joueur, pour qu'il puisse valider
	confirmation.grab_focus()


#Vide les boites initiales
func _ready():
	$HBoxContainer/HarryDia.modifDia("")
	$HBoxContainer/FlauxDia.modifDia("")

#Lit le fichier du chemin "dialogue_file"
func dialogueRead():
	load_dialogue(dialogue_file)	#On prépare la lecture
	start_dialogue()				#On commence le dialogue
	
	#On affiche la première boite de dialogue (avec ou sans anim, pourrait varier par rapport à un choix (if))
	#boiteDeDia(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux)	#sans anim
	boiteDeDiaAnim(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux,dialogue_supOther)
	yield(confirmation, "pressed") #appuyer sur le bouton pour continuer
	
	while(current < dialogue_keys.size()-1): #tant qu'on n'est pas à la fin du fichier
		next_dialogue() #on passe on dialogue suivant
		#boiteDeDia(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux)	#sans anim
		boiteDeDiaAnim(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux,dialogue_supOther)
		yield(confirmation, "pressed") #appuyer sur le bouton pour continuer
	emit_signal("dialogueFini") #quand cette fonction se termine, émet le signal "dialogueFini"

#Les constantes ici sont le chemin vers les fichiers contenant les dialogues
#En français
const dialogueTest = "res://text/FR/DialogueTest.json"
const dialogueIntroFR = "res://text/FR/Battle1/DialogBattle1Intro.json"
const dialogueHint1FR = "res://text/FR/Battle1/DialogBattle1Hint1.json"
const dialogueHint2FR = "res://text/FR/Battle1/DialogBattle1Hint2.json"
const dialogueMidFR = "res://text/FR/Battle1/DialogBattle1Mid.json"
const dialogueEndFR = "res://text/FR/Battle1/DialogBattle1End.json"

#En anglais
const dialogueTesten = "res://text/EN/Battle1/DialogBattle1Test.json"
const dialogueIntroEN = "res://text/EN/Battle1/DialogBattle1Intro.json"
const dialogueHint1EN = "res://text/EN/Battle1/DialogBattle1Hint1.json"
const dialogueHint2EN = "res://text/EN/Battle1/DialogBattle1Hint2.json"
const dialogueMidEN = "res://text/EN/Battle1/DialogBattle1Mid.json"
const dialogueEndEN = "res://text/EN/Battle1/DialogBattle1End.json"

#Dialogue pour tester
func dialogueTest():
	#En fonction du booléen de la langue on charge un chemin différent
	if(fr):
		dialogue_file = dialogueTest #déclaré au dessus: const dialogueTest = "res://text/FR/DialogueTest.json"
	elif(en):
		dialogue_file = dialogueTesten
	dialogueRead() #puis on lance la lecture du dialogue

func dialogueIntro():
	if(fr):
		dialogue_file = dialogueIntroFR
	elif(en):
		dialogue_file = dialogueIntroEN
	dialogueRead()

func dialogueHint1():
	if(fr):
		dialogue_file = dialogueHint1FR
	elif(en):
		dialogue_file = dialogueHint1EN
	dialogueRead()

func dialogueHint2():
	if(fr):
		dialogue_file = dialogueHint2FR
	elif(en):
		dialogue_file = dialogueHint2EN
	dialogueRead()

func dialogueMid():
	if(fr):
		dialogue_file = dialogueMidFR
	elif(en):
		dialogue_file = dialogueMidEN
	dialogueRead()

func dialogueEnd():
	if(fr):
		dialogue_file = dialogueEndFR
	elif(en):
		dialogue_file = dialogueEndEN
	dialogueRead()
