extends Node

onready var main = get_node("../../..")

onready var combat = get_node("..")

#Signal qui permet d'alerter de la fin d'un dialogue
signal dialogueIntroFini
signal dialogueFini
signal dialogueSuivant

signal confirmHpro
signal confirmFpro

#Variable qui indique la langue du jeu (qui sera choisi par le joueur)
onready var fr = main.fr
onready var en = main.en

onready var multi = main.multi

onready var HarryDia = get_node("../GeneralInterface/HBoxContainer/Harry")
onready var FlauxDia = get_node("../GeneralInterface/HBoxContainer/Flaux")

#Texte temporaire pour l'affichage progressif des textes
var tempTextH = ""
var tempTextF = ""
var tempNar = ""

#Stockage du bouton de confirmation dans une variable
onready var confirmation = get_node("HBoxContainer/HarryDia/Background/Menu/VBoxContainer/HBoxContainer/Confirm")

onready var confirmH = get_node("HBoxContainer/HarryDia/Background/Menu/VBoxContainer/HBoxContainer/ConfirmH")
onready var confirmF = get_node("HBoxContainer/FlauxDia/Background/Menu/VBoxContainer/HBoxContainer/ConfirmF")

onready var cadreN = get_node("../CadreNarrateur/DescriptionAction")

#Tout ce dont on a besoin pour la lecture de fichier
export(String, FILE, "*.json") var dialogue_file	#variable qui contiendra le chemin du fichier
var dialogue_keys = []			#tableau des éléments du fichier, avec [i] le numéro de la ligne
var dialogue_textHarry = ""		#variable qui va récupérer les "textHarry" du fichier
var dialogue_spHarry = 0		#variable qui va récupérer les "spHarry" du fichier
var dialogue_textFlaux = ""		#variable qui va récupérer les "textFlaux" du fichier
var dialogue_spFlaux = 0		#variable qui va récupérer les "spFlaux" du fichier
var dialogue_cadreN = ""		#variable qui va récupérer les "cadreN" du fichier
var dialogue_spLucy = 0			#variable qui va récupérer les "spLucy" du fichier (pour combat5)
var dialogue_supOther = false	#variable qui va récupérer l'info "supOther" du fichier
var dialogue_devent = 0			#variable qui va récupérer l'info "devent" du fichier
var current = 0					#numéro de la ligne lu

#Fonction qui débute un dialogue
func start_dialogue():
	current = 0												#Numéro de la première ligne
	index_dialogue()										#Lance la fonction qui charge les paramètres
	dialogue_textHarry = dialogue_keys[current].textHarry	#Stocke le string associer à "textHarry" dans le fichier
	dialogue_spHarry = int(dialogue_keys[current].spHarry)	#à la ligne "current", pareil pour "textFlaux"
	dialogue_textFlaux = dialogue_keys[current].textFlaux	#pour le numéro des sprites on tranforme le string
	dialogue_spFlaux = int(dialogue_keys[current].spFlaux)	#en entier avec int()
	dialogue_cadreN = dialogue_keys[current].cadreN
	dialogue_supOther = bool(dialogue_keys[current].supOther)
	dialogue_devent = int(dialogue_keys[current].devent)

func start_dialogueL():
	current = 0												#Numéro de la première ligne
	index_dialogue()										#Lance la fonction qui charge les paramètres
	dialogue_textHarry = dialogue_keys[current].textHarry	#Stocke le string associer à "textHarry" dans le fichier
	dialogue_spHarry = int(dialogue_keys[current].spHarry)	#à la ligne "current", pareil pour "textFlaux"
	dialogue_textFlaux = dialogue_keys[current].textFlaux	#pour le numéro des sprites on tranforme le string
	dialogue_spFlaux = int(dialogue_keys[current].spFlaux)	#en entier avec int()
	dialogue_cadreN = dialogue_keys[current].cadreN
	dialogue_spLucy = int(dialogue_keys[current].spLucy)
	dialogue_supOther = bool(dialogue_keys[current].supOther)
	dialogue_devent = int(dialogue_keys[current].devent)
	

#Fonction qui permet de passer à la ligne suivante, lit de la même façon sans indexer le fichier
func next_dialogue():
	current += 1	#On passe à la ligne suivante pour prendre les nouvelles informations
	dialogue_textHarry = dialogue_keys[current].textHarry
	dialogue_spHarry = int(dialogue_keys[current].spHarry)
	dialogue_textFlaux = dialogue_keys[current].textFlaux
	dialogue_spFlaux = int(dialogue_keys[current].spFlaux)
	dialogue_cadreN = dialogue_keys[current].cadreN
	dialogue_supOther = bool(dialogue_keys[current].supOther)
	dialogue_devent = int(dialogue_keys[current].devent)

func next_dialogueL():
	current += 1	#On passe à la ligne suivante pour prendre les nouvelles informations
	dialogue_textHarry = dialogue_keys[current].textHarry
	dialogue_spHarry = int(dialogue_keys[current].spHarry)
	dialogue_textFlaux = dialogue_keys[current].textFlaux
	dialogue_spFlaux = int(dialogue_keys[current].spFlaux)
	dialogue_cadreN = dialogue_keys[current].cadreN
	dialogue_spLucy = int(dialogue_keys[current].spLucy)
	dialogue_supOther = bool(dialogue_keys[current].supOther)
	dialogue_devent = int(dialogue_keys[current].devent)

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
	
	cadreN.set_text("")
	
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
				if(multi):
					yield(HarryDia.spriteAnim,"frame_changed")
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
			if ((not(multi) && Input.is_action_pressed("ui_select")) || (multi && Input.is_action_pressed("ui_multi_select"))):
				$HBoxContainer/FlauxDia.modifDia(textFlaux)
				if(multi):
					yield(HarryDia.spriteAnim,"frame_changed")
				break
	
	if(textHarry != ""):
		if(not(multi)):
			confirmH.show()
			confirmH.grab_focus()
			yield(confirmH, "pressed")
		else:
			confirmH.show()
			yield(self, "confirmHpro")
	elif(textFlaux != ""):
		if(not(multi)):
			confirmF.show()
			confirmF.grab_focus()
			yield(confirmF, "pressed")
		else:
			confirmF.show()
			yield(self, "confirmFpro")
	
	confirmH.release_focus()
	confirmH.hide()
	confirmF.release_focus()
	confirmF.hide()
	
	emit_signal("dialogueSuivant")

func _process(_delta):
	
	if(multi):
		
		if Input.is_action_just_pressed("ui_select") && confirmH.visible:
			confirmH.toggle_mode = true
			confirmH.pressed = true
		
		if Input.is_action_just_pressed("ui_multi_select") && confirmF.visible:
			confirmF.toggle_mode = true
			confirmF.pressed = true
		
		if(confirmH.toggle_mode):
			if not(Input.is_action_pressed("ui_select")):
				confirmH.pressed = false
				confirmH.toggle_mode = false
				emit_signal("confirmHpro")
		
		if(confirmF.toggle_mode):
			if not(Input.is_action_pressed("ui_multi_select")):
				confirmH.pressed = false
				confirmF.toggle_mode = false
				emit_signal("confirmFpro")

#Vide les boites initiales
func _ready():
	$HBoxContainer/HarryDia.modifDia("")
	$HBoxContainer/FlauxDia.modifDia("")

#Lit le fichier du chemin "dialogue_file"
func dialogueRead():
	start_dialogue()
	
	if(dialogue_devent != 0):
		if(dialogue_devent == 1):
			get_node("../EnnemiGroup").show()
		elif(dialogue_devent == 2):
			if(get_node("../Barreaux") != null):
				if(get_node("../Barreaux").visible):
					get_node("../Barreaux").hide()
				else:
					get_node("../Barreaux").show()
	if(dialogue_cadreN == ""):
		boiteDeDiaAnim(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux,dialogue_supOther)
	else:
		narraRead(dialogue_spHarry, dialogue_spFlaux, dialogue_cadreN)
	yield(self, "dialogueSuivant")
	
	while(current < dialogue_keys.size()-1): #tant qu'on n'est pas à la fin du fichier
		next_dialogue() #on passe on dialogue suivant
		
		if(dialogue_devent != 0):
			if(dialogue_devent == 1):
				get_node("../EnnemiGroup").show()
			elif(dialogue_devent == 2):
				if(get_node("../Barreaux") != null):
					if(get_node("../Barreaux").visible):
						get_node("../Barreaux").hide()
					else:
						get_node("../Barreaux").show()
		if(dialogue_textHarry != "" || dialogue_textFlaux != ""):
			boiteDeDiaAnim(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux,dialogue_supOther)
			yield(self, "dialogueSuivant")
		elif(dialogue_cadreN != ""):
			narraRead(dialogue_spHarry, dialogue_spFlaux, dialogue_cadreN)
			yield(self, "dialogueSuivant")
	
	emit_signal("dialogueFini") #quand cette fonction se termine, émet le signal "dialogueFini"

func narraRead(spHarry, spFlaux, textNar):
	
	$HBoxContainer/HarryDia.modifDia("")
	$HBoxContainer/FlauxDia.modifDia("")
	HarryDia.changerSpriteDia(spHarry)
	FlauxDia.changerSpriteDia(spFlaux)
	
	tempNar = ""
	
	cadreN.set_text("")
	
	for c in textNar:
		tempNar += c
		cadreN.set_text(tempNar)
		$TimerDia.start()
		yield($TimerDia,"timeout")
		if Input.is_action_pressed("ui_select"):
			cadreN.set_text(textNar)
			break
	
	confirmation.show()
	confirmation.grab_focus()
	yield(confirmation,"pressed")
	confirmation.release_focus()
	confirmation.hide()
	
	emit_signal("dialogueSuivant")

#Ces fonctions ne servent qu'à empêcher les erreurs de leur inexistance
#Mais elles ne servent à rien
func _on_ConfirmH_pressed():
	pass

func _on_Confirm_pressed():
	pass

func _on_ConfirmF_pressed():
	pass

func dialogueIntro():
	emit_signal("dialogueIntroFini")

#En français
const dialogueLaunchSharpenFR = "res://text/FR/DialogueLaunchSharpen.json"
const dialogueLaunchHideFR = "res://text/FR/DialogueLaunchHide.json"

#En anglais
const dialogueLaunchSharpenEN = "res://text/EN/DialogueLaunchSharpen.json"
const dialogueLaunchHideEN = "res://text/EN/DialogueLaunchHide.json"

func dialogueLaunchSharpen():
	if(fr):
		dialogue_file = dialogueLaunchSharpenFR
	elif(en):
		dialogue_file = dialogueLaunchSharpenEN
	dialogueRead()

func dialogueLaunchHide():
	if(fr):
		dialogue_file = dialogueLaunchHideFR
	elif(en):
		dialogue_file = dialogueLaunchHideEN
	dialogueRead()
