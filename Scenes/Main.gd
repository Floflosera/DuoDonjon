extends "res://Scenes/ParentMain.gd"

var scene
var instance

onready var win = false

func _ready():

	menuC.startB.grab_focus()

func startStory():
	menuC.queue_free()
	
	while(not(win)):
		win = false
		
		scene = load("res://Scenes/Combat1.tscn")
		instance = scene.instance()
		add_child(instance)
	
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
		
		instance.queue_free()
	
	win = false
	
	while(not(win)):
		win = false
		
		scene = load("res://Scenes/Combat2.tscn")
		instance = scene.instance()
		add_child(instance)
	
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
		
		instance.queue_free()
	
	win = false
	
	while(not(win)):
		win = false
		
		scene = load("res://Scenes/Combat3.tscn")
		instance = scene.instance()
		add_child(instance)
	
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
		
		instance.queue_free()
	
	win = false
	
	while(not(win)):
		win = false
		
		scene = load("res://Scenes/Combat4.tscn")
		instance = scene.instance()
		add_child(instance)
	
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
		
		instance.queue_free()
	
	win = false
	
	while(not(win)):
		win = false
		
		scene = load("res://Scenes/Combat5.tscn")
		instance = scene.instance()
		add_child(instance)
	
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
		
		instance.queue_free()
	
	scene = load("res://Scenes/Menu.tscn")
	instance = scene.instance()
	add_child(instance)
	
	menuC = instance
	menuC.startB.grab_focus()

func selectBattle():
	
	menuC.queue_free()
	
	match menuC.sel:
		1:
			scene = load("res://Scenes/Combat1.tscn")
		2:
			scene = load("res://Scenes/Combat2.tscn")
		3:
			scene = load("res://Scenes/Combat3.tscn")
		4:
			scene = load("res://Scenes/Combat4.tscn")
		5:
			scene = load("res://Scenes/Combat5.tscn")
	
	instance = scene.instance()
	add_child(instance)
	
	yield(instance,"finCombat")
	
	instance.queue_free()
	
	scene = load("res://Scenes/Menu.tscn")
	instance = scene.instance()
	add_child(instance)
	
	menuC = instance
	menuC.startB.grab_focus()

func langageMenu():
	load_menuText()
