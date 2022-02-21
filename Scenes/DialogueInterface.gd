extends MarginContainer

#Signal qui permet d'alerter de la fin d'un dialogue
signal dialogueFini

#Variable qui indique la langue du jeu (qui sera choisi par le joueur)
onready var fr = true
onready var en = false

#Texte temporaire pour l'affichage progressif des textes
var tempTextH
var tempTextF

#Stockage du bouton de confirmation dans une variable
onready var confirmation = get_node("HBoxContainer/FlauxDia/FlauxMenu/Background/Menu/VBoxContainer/Confirm")

#Tout ce dont on a besoin pour la lecture de fichier
export(String, FILE, "*.json") var dialogue_file	#variable qui contiendra le chemin du fichier
var dialogue_keys = []			#tableau des éléments du fichier, avec [i] le numéro de la ligne
var dialogue_textHarry = ""		#variable qui va récupérer les "textHarry" du fichier
var dialogue_spHarry = 0		#variable qui va récupérer les "spHarry" du fichier
var dialogue_textFlaux = ""		#variable qui va récupérer les "textFlaux" du fichier
var dialogue_spFlaux = 0		#variable qui va récupérer les "spFlaux" du fichier
var current = 0					#numéro de la ligne lu

#Fonction qui débute un dialogue
func start_dialogue():
	current = 0												#Numéro de la première ligne
	index_dialogue()										#Lance la fonction qui charge les paramètres
	dialogue_textHarry = dialogue_keys[current].textHarry	#Stocke le string associer à "textHarry" dans le fichier
	dialogue_spHarry = int(dialogue_keys[current].spHarry)	#à la ligne "current", pareil pour "textFlaux"
	dialogue_textFlaux = dialogue_keys[current].textFlaux	#pour le numéro des sprites on tranforme le string
	dialogue_spFlaux = int(dialogue_keys[current].spFlaux)	#en entier avec int()

#Fonction qui permet de passer à la ligne suivante, lit de la même façon sans indexer le fichier
func next_dialogue():
	current += 1	#On passe à la ligne suivante pour prendre les nouvelles informations
	dialogue_textHarry = dialogue_keys[current].textHarry
	dialogue_spHarry = int(dialogue_keys[current].spHarry)
	dialogue_textFlaux = dialogue_keys[current].textFlaux
	dialogue_spFlaux = int(dialogue_keys[current].spFlaux)

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

#Les constantes ici sont le chemin vers les fichiers contenant les dialogues
#En français
const dialogueTest = "res://text/FR/DialogueTest.json"

#En anglais
const dialogueTesten = "res://text/EN/DialogueTest.json"


#Fonction pour créer une boite de texte pour Harry, Flaux, mettre leur émotion
func boiteDeDia(textHarry,spHarry,textFlaux,spFlaux):
	$HBoxContainer/HarryDia.modifDia(textHarry)
	$HBoxContainer/HarryDia.changerSprite(spHarry)
	$HBoxContainer/FlauxDia.modifDia(textFlaux)
	$HBoxContainer/FlauxDia.changerSprite(spFlaux)
	confirmation.grab_focus()

#Fonction similaire mais qui permet un affichage progressif des textes
func boiteDeDiaAnim(textHarry,spHarry,textFlaux,spFlaux):
	#On commence par empêcher le joueur d'appuyer sur le bouton tout de suite
	confirmation.release_focus()
	#On change les sprites
	$HBoxContainer/HarryDia.changerSprite(spHarry)
	$HBoxContainer/FlauxDia.changerSprite(spFlaux)
	#Vide les variables temporaires
	tempTextH = ""
	tempTextF = ""
	#Vide les boites de dialogues actuelles
	$HBoxContainer/HarryDia.modifDia("")
	$HBoxContainer/FlauxDia.modifDia("")
	
	#Pour chaque caractère de la variable "textHarry", c prend la valeur du caractère
	for c in textHarry:
		tempTextH += c								#le texte temporaire concatène ce caractère avec lui même
		$HBoxContainer/HarryDia.modifDia(tempTextH)	#On affiche ce texte temporaire
		$TimerDia.start()							#On attend un peu, puis on recommence jusqu'à la fin du string
		yield($TimerDia,"timeout")
		if Input.is_action_pressed("ui_select"):		#Si le joueur appuie sur une touche de validation
			$HBoxContainer/HarryDia.modifDia(textHarry)	#Alors on affiche tout le texte directement
			break										#Puis on termine la boucle
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
	boiteDeDiaAnim(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux)	#avec
	yield(confirmation, "pressed") #appuyer sur le bouton pour continuer
	
	while(current < dialogue_keys.size()-1): #tant qu'on n'est pas à la fin du fichier
		next_dialogue() #on passe on dialogue suivant
		#boiteDeDia(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux)	#sans anim
		boiteDeDiaAnim(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux)	#avec
		yield(confirmation, "pressed") #appuyer sur le bouton pour continuer
	emit_signal("dialogueFini") #quand cette fonction se termine, émet le signal "dialogueFini"

#Dialogue pour tester
func dialogueTest():
	#En fonction du booléen de la langue on charge un chemin différent
	if(fr):
		dialogue_file = dialogueTest #déclaré au dessus: const dialogueTest = "res://text/FR/DialogueTest.json"
	elif(en):
		dialogue_file = dialogueTesten
	dialogueRead() #puis on lance la lecture du dialogue
