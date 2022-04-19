extends Node

onready var calqueS = $CalqueScene

onready var transitionS = $CalqueTransition/Transition
onready var timerT = $TimerTransi

onready var menuC = $CalqueScene/Menu

onready var seValider = $SE/Valider
onready var seCancel = $SE/Cancel
onready var seCursor = $SE/Cursor

onready var seHarryTappe = $SE/HarryTappe
onready var seFlauxTappe = $SE/FlauxTappe
onready var seFaitTappe = $SE/SeFaitTappe
onready var seHeal = $SE/Heal
onready var seTexte = $SE/TexteSe
onready var seRencontre = $SE/Rencontre

onready var ostDiscussion = $Music/DiscussionSong

onready var fr = true
onready var en = false
onready var multi = false

onready var BGMvolume = 0
onready var SEvolume = 0

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
	ligne_menu(13)
	menuC.settingsVolumeBGM.set_text(menu_text)
	ligne_menu(14)
	menuC.settingsVolumeSE.set_text(menu_text)

func bgmVolume(x):
	BGMvolume += x
	if(BGMvolume > -40):
		ostDiscussion.volume_db = BGMvolume
	else:
		ostDiscussion.volume_db = -80

func seVolume(x):
	SEvolume += x
	if(SEvolume > -40):
		seValider.volume_db = -15 + SEvolume
		seCancel.volume_db = SEvolume
		seCursor.volume_db = -15 + SEvolume
		seHarryTappe.volume_db = -15 + SEvolume
		seFlauxTappe.volume_db = -15 + SEvolume
		seFaitTappe.volume_db = -15 + SEvolume
		seHeal.volume_db = SEvolume
		seRencontre.volume_db = -5 + SEvolume
	else:
		seValider.volume_db = -80
		seCancel.volume_db = -80
		seCursor.volume_db = -80
		seHarryTappe.volume_db = -80
		seFlauxTappe.volume_db = -80
		seFaitTappe.volume_db = -80
		seHeal.volume_db = -80
		seRencontre.volume_db = -80
	
	#seTexte.volume_db += x
