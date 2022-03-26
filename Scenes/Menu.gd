extends Control

onready var main = get_node("../..")

onready var startB = $MarginContainer/VBoxContainer/StartButton
onready var chapSelectB = $MarginContainer/VBoxContainer/ChapSelectButton
onready var settingsB = $MarginContainer/VBoxContainer/SettingsButton
onready var exitB = $MarginContainer/VBoxContainer/ExitButton

onready var battle1B = $SousMenu/ChapSelectMenu/MarginContainer/VBoxContainer/Battle1
onready var battle2B = $SousMenu/ChapSelectMenu/MarginContainer/VBoxContainer/Battle2
onready var battle3B = $SousMenu/ChapSelectMenu/MarginContainer/VBoxContainer/Battle3
onready var battle4B = $SousMenu/ChapSelectMenu/MarginContainer/VBoxContainer/Battle4
onready var battle5B = $SousMenu/ChapSelectMenu/MarginContainer/VBoxContainer/Battle5

onready var chapSelectM = $SousMenu/ChapSelectMenu
onready var sel = 1

onready var settingsM = $SousMenu/SettingsMenu
onready var settingsMulti = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/Multi
onready var settingsMultiYes = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/MultiChoix/YesMulti
onready var settingsMultiNo = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/MultiChoix/NoMulti
onready var settingsLang = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/Language
onready var settingsLangfr = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/Lang/French
onready var settingsLangen = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/Lang/English
onready var settingsControl = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/Control
onready var settingsQuitSet = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/QuitSet

func _process(_delta):
	
	if(main.intro):
		if(Input.is_action_just_pressed("ui_cancel")):
			get_tree().call_group("SousMenuB", "release_focus")
			get_tree().call_group("SousMenu", "hide")
			startB.grab_focus()

func _on_ChapSelectButton_pressed():
	chapSelectB.release_focus()
	chapSelectM.show()
	battle1B.grab_focus()

func _on_Battle1_pressed():
	get_tree().call_group("SousMenuB", "release_focus")
	sel = 1
	main.selectBattle()

func _on_Battle2_pressed():
	get_tree().call_group("SousMenuB", "release_focus")
	sel = 2
	main.selectBattle()

func _on_Battle3_pressed():
	get_tree().call_group("SousMenuB", "release_focus")
	sel = 3
	main.selectBattle()

func _on_Battle4_pressed():
	get_tree().call_group("SousMenuB", "release_focus")
	sel = 4
	main.selectBattle()

func _on_Battle5_pressed():
	get_tree().call_group("SousMenuB", "release_focus")
	sel = 5
	main.selectBattle()

func _on_StartButton_pressed():
	get_tree().call_group("MenuB", "release_focus")
	main.startStory()

func _on_SettingsButton_pressed():
	settingsB.release_focus()
	settingsM.show()
	settingsMultiYes.grab_focus()

func _on_YesMulti_pressed():
	main.multi = true
	main.ligne_menu(5)
	settingsMulti.set_text(main.menu_text)
	main.ligne_menu(6)
	settingsMulti.set_text(settingsMulti.get_text() + " (" + main.menu_text + ")")

func _on_NoMulti_pressed():
	main.multi = false
	main.ligne_menu(5)
	settingsMulti.set_text(main.menu_text)
	main.ligne_menu(7)
	settingsMulti.set_text(settingsMulti.get_text() + " (" + main.menu_text + ")")

func _on_French_pressed():
	main.fr = true
	main.en = false
	
	main.load_menuText()

func _on_English_pressed():
	main.en = true
	main.fr = false
	
	main.load_menuText()


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_QuitSet_pressed():
	get_tree().call_group("SousMenuB", "release_focus")
	get_tree().call_group("SousMenu", "hide")
	startB.grab_focus()
