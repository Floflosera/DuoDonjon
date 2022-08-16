extends Control

onready var main = get_node("../..")

onready var sousMenu = $SousMenu

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

onready var touches = $SousMenu/Touches

onready var settingsM = $SousMenu/SettingsMenu
onready var settingsMulti = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/Multi
onready var settingsMultiYes = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/MultiChoix/YesMulti
onready var settingsMultiNo = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/MultiChoix/NoMulti
onready var settingsLang = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/Language
onready var settingsLangfr = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/Lang/French
onready var settingsLangen = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/Lang/English
onready var settingsControl = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/Control
onready var settingsQuitSet = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/QuitSet
onready var settingsVolumeBGM = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/VolumeBGMB/VolumeBGM
onready var settingsVolumeBGMbarre = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/VolumeBGMB/VolumeBGMbarre
onready var settingsVolumeSE = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/VolumeSEB/VolumeSE
onready var settingsVolumeSEbarre = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/VolumeSEB/VolumeSEbarre
onready var settingsFullScreen = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/HBoxContainer/FullScreen
onready var settingsKeybinds = $SousMenu/SettingsMenu/MarginContainer/VBoxContainer/HBoxContainer/Keybinds

onready var settingsCancelKey = $SousMenu/Touches/MarginContainer/VBoxContainer/CancelKey
onready var settingsInfoKey = $SousMenu/Touches/MarginContainer/VBoxContainer/InfoKey
onready var settingsDefault = $SousMenu/Touches/MarginContainer/VBoxContainer/Default
onready var settingsQuitKey = $SousMenu/Touches/MarginContainer/VBoxContainer/QuitKey

func _ready():
	if(not(main.pres)):
		yield(main,"pres")
	main.langageMenu()

func _process(_delta):
	
	if(Input.is_action_just_pressed("ui_cancel")):
		if(not(touches.visible)):
			if(main.intro):
				main.seCancel.play()
				get_tree().call_group("SousMenuB", "release_focus")
				get_tree().call_group("SousMenu", "hide")
				sousMenu.hide()
				startB.grab_focus()
	
	if(Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_up") || \
	Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_right")):
		if(not(touches.visible)):
			main.seCursor.play()
	
	if(settingsVolumeBGM.has_focus()):
		if(Input.is_action_just_pressed("ui_left") && settingsVolumeBGMbarre.value > 0):
			settingsVolumeBGMbarre.value -= 10
			main.bgmVolume(-5)
		if(Input.is_action_just_pressed("ui_right") && settingsVolumeBGMbarre.value < 100):
			settingsVolumeBGMbarre.value += 10
			main.bgmVolume(+5)
	
	if(settingsVolumeSE.has_focus()):
		if(Input.is_action_just_pressed("ui_left") && settingsVolumeSEbarre.value > 0):
			settingsVolumeSEbarre.value -= 10
			main.seVolume(-5)
		if(Input.is_action_just_pressed("ui_right") && settingsVolumeSEbarre.value < 100):
			settingsVolumeSEbarre.value += 10
			main.seVolume(+5)

func _on_ChapSelectButton_pressed():
	main.seValider.play()
	chapSelectB.release_focus()
	sousMenu.show()
	chapSelectM.show()
	battle1B.grab_focus()

func _on_Battle1_pressed():
	main.seValider.play()
	get_tree().call_group("SousMenuB", "release_focus")
	sel = 1
	main.selectBattle()

func _on_Battle2_pressed():
	main.seValider.play()
	get_tree().call_group("SousMenuB", "release_focus")
	sel = 2
	main.selectBattle()

func _on_Battle3_pressed():
	main.seValider.play()
	get_tree().call_group("SousMenuB", "release_focus")
	sel = 3
	main.selectBattle()

func _on_Battle4_pressed():
	main.seValider.play()
	get_tree().call_group("SousMenuB", "release_focus")
	sel = 4
	main.selectBattle()

func _on_Battle5_pressed():
	main.seValider.play()
	get_tree().call_group("SousMenuB", "release_focus")
	sel = 5
	main.selectBattle()

func _on_StartButton_pressed():
	main.seValider.play()
	get_tree().call_group("MenuB", "release_focus")
	main.startStory()

func _on_SettingsButton_pressed():
	main.seValider.play()
	settingsB.release_focus()
	sousMenu.show()
	settingsM.show()
	settingsMultiYes.grab_focus()

func _on_YesMulti_pressed():
	main.seValider.play()
	main.multi = true
	main.ligne_menu(5)
	settingsMulti.set_text(main.menu_text)
	main.ligne_menu(6)
	settingsMulti.set_text(settingsMulti.get_text() + " (" + main.menu_text + ")")

func _on_NoMulti_pressed():
	main.seValider.play()
	main.multi = false
	main.ligne_menu(5)
	settingsMulti.set_text(main.menu_text)
	main.ligne_menu(7)
	settingsMulti.set_text(settingsMulti.get_text() + " (" + main.menu_text + ")")

func _on_French_pressed():
	main.seValider.play()
	main.fr = true
	main.en = false
	
	main.load_menuText()

func _on_English_pressed():
	main.seValider.play()
	main.en = true
	main.fr = false
	
	main.load_menuText()

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_QuitSet_pressed():
	main.seValider.play()
	get_tree().call_group("SousMenuB", "release_focus")
	get_tree().call_group("SousMenu", "hide")
	sousMenu.hide()
	startB.grab_focus()

func _on_FullScreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_Keybinds_pressed():
	main.seValider.play()
	touches.show()

func _on_QuitKey_pressed():
	Global.keybinds = touches.keybinds.duplicate()
	Global.set_game_binds()
	Global.write_config()
	main.seValider.play()
	touches.hide()
	settingsKeybinds.grab_focus()

func _on_Default_pressed():
	Global.filepath = "res://keybindsDef.ini"
	Global.lecture_ini()
	Global.filepath = "user://keybinds.ini"
	touches.key_canceled()

func _on_CancelKey_pressed():
	touches.key_canceled()
	main.seCancel.play()
	touches.hide()
	settingsKeybinds.grab_focus()
