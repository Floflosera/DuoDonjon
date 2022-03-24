extends Node

onready var calqueS = $CalqueScene

onready var transitionS = $CalqueTransition/Transition

onready var menuC = $CalqueScene/Menu

onready var fr = true
onready var en = false
onready var multi = false

export(String, FILE, "*.json") var menu_file
var menu_keys = []
var menu_text = ""
var current = 0

#Le chemin pour la lecture du fichier des compétences en français et en anglais
const menu_fileFR = "res://text/FR/Menu.json"
const menu_fileEN = "res://text/EN/Menu.json"

func ligne_menu(ligne):
	current = ligne
	menu_text = menu_keys[current].text

#Indexe le fichier
func index_menu():
	var menu = load_fileMenu(menu_file)
	menu_keys.clear()
	for key in menu:
		menu_keys.append(menu[key])

#Charge le fichier à l'emplacement voulu
func load_fileMenu(file_path):
	var file = File.new()
	if file.file_exists(file_path):
		file.open(file_path, file.READ)
		var menu = parse_json(file.get_as_text())
		return menu

func load_menuText():
	#En fonction de la langue, prend un chemin différent
	if(fr):
		menu_file = menu_fileFR
	elif(en):
		menu_file = menu_fileEN
	#Charge le fichier
	load_fileMenu(menu_file)
	index_menu()
	
	ligne_menu(0)
	menuC.startB.set_text(menu_text)
	ligne_menu(1)
	menuC.chapSelectB.set_text(menu_text)
	ligne_menu(2)
	menuC.settingsB.set_text(menu_text)
	ligne_menu(3)
	menuC.exitB.set_text(menu_text)
	
	ligne_menu(4)
	menuC.battle1B.set_text(menu_text + str(1))
	menuC.battle2B.set_text(menu_text + str(2))
	menuC.battle3B.set_text(menu_text + str(3))
	menuC.battle4B.set_text(menu_text + str(4))
	menuC.battle5B.set_text(menu_text + str(5))
	
	ligne_menu(5)
	menuC.settingsMulti.set_text(menu_text)
	if(multi):
		ligne_menu(6)
		menuC.settingsMulti.set_text(menuC.settingsMulti.get_text() + " (" + menu_text + ")")
	else:
		ligne_menu(7)
		menuC.settingsMulti.set_text(menuC.settingsMulti.get_text() + " (" + menu_text + ")")
	ligne_menu(6)
	menuC.settingsMultiYes.set_text(menu_text)
	ligne_menu(7)
	menuC.settingsMultiNo.set_text(menu_text)
	
	ligne_menu(8)
	menuC.settingsLang.set_text(menu_text)
	ligne_menu(9)
	menuC.settingsLangfr.set_text(menu_text)
	ligne_menu(10)
	menuC.settingsLangen.set_text(menu_text)
	ligne_menu(11)
	menuC.settingsControl.set_text(menu_text)
	ligne_menu(12)
	menuC.settingsQuitSet.set_text(menu_text)
