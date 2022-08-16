extends Node

onready var buttoncontainer = get_node("MarginContainer/VBoxContainer/GridContainer")
onready var buttonscript = load("res://Scenes/KeyButton.gd")

var keybinds
var buttons = {}

export(String, FILE, "*.json") var key_file
var key_keys = []
var key_text = ""
var current = 0

#Le chemin pour la lecture du fichier des compétences en français et en anglais
const key_fileFR = "res://text/FR/Keybinds.json"
const key_fileEN = "res://text/EN/Keybinds.json"

func ligne_key(ligne):
	current = ligne
	key_text = key_keys[current].text

#Indexe le fichier
func index_key():
	var k = load_fileKey(key_file)
	key_keys.clear()
	for key in k:
		key_keys.append(k[key])

#Charge le fichier à l'emplacement voulu
func load_fileKey(file_path):
	var file = File.new()
	if file.file_exists(file_path):
		file.open(file_path, file.READ)
		var menu = parse_json(file.get_as_text())
		return menu

func load_keyText(fr):
	#En fonction de la langue, prend un chemin différent
	if(fr):
		key_file = key_fileFR
	else:
		key_file = key_fileEN

	index_key()
	
	if(not(Global.kfini)):
		yield(Global,"kfinito")
	
	keybinds = Global.keybinds.duplicate()
	
	for k in range(0,12):
		ligne_key(k)
		buttons[keybinds.keys()[k]].label.text = key_text
	

func _ready():
	keybinds = Global.keybinds.duplicate()
	for key in keybinds.keys():
		var hbox = HBoxContainer.new()
		var label = Label.new()
		var button = Button.new()
		
		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
		label.text = key
		
		var button_value = keybinds[key]
		
		if button_value != null:
			button.text = OS.get_scancode_string(button_value)
		else:
			button.text = "Unassigned"
		
		button.set_script(buttonscript)
		button.key = key
		button.value = button_value
		button.menu = self
		button.toggle_mode = true
		button.focus_mode = Control.FOCUS_NONE
		
		button.label = label
		
		hbox.add_child(label)
		hbox.add_child(button)
		buttoncontainer.add_child(hbox)
		
		buttons[key] = button

func key_canceled():
	keybinds = Global.keybinds.duplicate()
	
	for k in keybinds.keys():
		buttons[k].value = keybinds[k]
		if buttons[k].value != null:
			buttons[k].text = OS.get_scancode_string(buttons[k].value)
		else:
			ligne_key(13)
			buttons[k].text = key_text

func change_bind(key, value):
	keybinds[key] = value
	
	for k in keybinds.keys():
		if k != key and value != null and keybinds[k] == value:
			keybinds[k] = null
			buttons[k].value = null
			ligne_key(13)
			buttons[k].text = key_text
