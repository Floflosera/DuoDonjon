extends Node

#Fait avec le tutoriel de Gonkee : https://www.youtube.com/watch?v=I_Kzb-d-SvM

signal kfinito

var filepath = "user://keybinds.ini"
var configfile

var keybinds = {}

var kfini = false

func lecture_ini():
	configfile = ConfigFile.new()
	
	if (configfile.load(filepath) == OK) && (configfile.has_section("keybinds")):
		for key in configfile.get_section_keys("keybinds"):
			var key_value = configfile.get_value("keybinds", key)
			#print(key, " : ", OS.get_scancode_string(key_value))
			
			if str(key_value) != "":
				keybinds[key] = key_value
			else:
				keybinds[key] = null
	else:
		filepath = "res://keybindsDef.ini"
			
		if configfile.load(filepath) == OK:
			print(configfile.get_section_keys("keybinds"))
			for key in configfile.get_section_keys("keybinds"):
				var key_value = configfile.get_value("keybinds", key)
				#print(key, " : ", OS.get_scancode_string(key_value))
				
				if str(key_value) != "":
					keybinds[key] = key_value
				else:
					keybinds[key] = null
		else:
			print("Vérification de keybindsDef.ini échouée")
			get_tree().quit()
			
		filepath = "user://keybinds.ini"
		write_config()
	
	set_game_binds()
	
	kfini = true
	emit_signal("kfinito")
	

func _ready():
	lecture_ini()

func set_game_binds():
	for key in keybinds.keys():
		var value = keybinds[key]
		
		var actionlist = InputMap.get_action_list(key)
		if !actionlist.empty():
			InputMap.action_erase_event(key, actionlist[0])
		
		if value != null:
			var new_key = InputEventKey.new()
			new_key.set_scancode(value)
			InputMap.action_add_event(key, new_key)

func write_config():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		if key_value != null:
			configfile.set_value("keybinds", key, key_value)
		else:
			configfile.set_value("keybinds", key, "")
	configfile.save(filepath)
