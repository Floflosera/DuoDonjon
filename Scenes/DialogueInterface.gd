extends MarginContainer

#Signal qui permet d'alerter de la fin d'un dialogue
signal dialogueFini

onready var fr = true
onready var en = false

var tempTextH
var tempTextF

#Stockage du bouton de confirmation dans une variable
onready var confirmation = get_node("HBoxContainer/FlauxDia/FlauxMenu/Background/Menu/VBoxContainer/Confirm")

export(String, FILE, "*.json") var dialogue_file
var dialogue_keys = []
var dialogue_textHarry = ""
var dialogue_spHarry = 0
var dialogue_textFlaux = ""
var dialogue_spFlaux = 0
var current = 0

func start_dialogue():
	emit_signal("dialogue_started")
	current = 0
	index_dialogue()
	dialogue_textHarry = dialogue_keys[current].textHarry
	dialogue_spHarry = int(dialogue_keys[current].spHarry)
	dialogue_textFlaux = dialogue_keys[current].textFlaux
	dialogue_spFlaux = int(dialogue_keys[current].spFlaux)


func next_dialogue():
	current += 1
	#if current == dialogue_keys.size():
	#	emit_signal("dialogueFini")
	#	return
	dialogue_textHarry = dialogue_keys[current].textHarry
	dialogue_spHarry = int(dialogue_keys[current].spHarry)
	dialogue_textFlaux = dialogue_keys[current].textFlaux
	dialogue_spFlaux = int(dialogue_keys[current].spFlaux)


func index_dialogue():
	var dialogue = load_dialogue(dialogue_file)
	dialogue_keys.clear()
	for key in dialogue:
		dialogue_keys.append(dialogue[key])


func load_dialogue(file_path):
	var file = File.new()
	if file.file_exists(file_path):
		file.open(file_path, file.READ)
		var dialogue = parse_json(file.get_as_text())
		return dialogue

const dialogueTest = "res://text/FR/DialogueTest.json"
const dialogueTesten = "res://text/EN/DialogueTest.json"


#Fonction pour créer une boite de texte pour Harry, Flaux, mettre leur émotion
func boiteDeDia(textHarry,spHarry,textFlaux,spFlaux):
	$HBoxContainer/HarryDia.modifDia(textHarry)
	$HBoxContainer/HarryDia.changerSprite(spHarry)
	$HBoxContainer/FlauxDia.modifDia(textFlaux)
	$HBoxContainer/FlauxDia.changerSprite(spFlaux)
	confirmation.grab_focus()

func boiteDeDiaAnim(textHarry,spHarry,textFlaux,spFlaux):
	confirmation.release_focus()
	$HBoxContainer/HarryDia.changerSprite(spHarry)
	$HBoxContainer/FlauxDia.changerSprite(spFlaux)
	tempTextH = ""
	tempTextF = ""
	$HBoxContainer/HarryDia.modifDia("")
	$HBoxContainer/FlauxDia.modifDia("")
	for c in textHarry:
		tempTextH += c
		$HBoxContainer/HarryDia.modifDia(tempTextH)
		$TimerDia.start()
		yield($TimerDia,"timeout")
	for c in textFlaux:
		tempTextF += c
		$HBoxContainer/FlauxDia.modifDia(tempTextF)
		$TimerDia.start()
		yield($TimerDia,"timeout")
	confirmation.grab_focus()


#Vide les boites initiales
func _ready():
	$HBoxContainer/HarryDia.modifDia("")
	$HBoxContainer/FlauxDia.modifDia("")

func dialogueRead():
	load_dialogue(dialogue_file)
	start_dialogue()
	#boiteDeDia(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux)
	boiteDeDiaAnim(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux)
	yield(confirmation, "pressed")
	while(current < dialogue_keys.size()-1):
		next_dialogue()
		#boiteDeDia(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux)
		boiteDeDiaAnim(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux)
		yield(confirmation, "pressed")
	emit_signal("dialogueFini")

#Dialogue pour tester
func dialogueTest():
	if(fr):
		dialogue_file = dialogueTest #déclaré au dessus: const dialogueTest = "res://text/FR/DialogueTest.json"
	elif(en):
		dialogue_file = dialogueTesten
	dialogueRead()


func _on_TimerDia_timeout():
	$TimerDia.stop()
