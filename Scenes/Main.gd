extends "res://Scenes/ParentMain.gd"

signal finiTransition

var scene
var instance

onready var win = false

func _ready():

	menuC.startB.grab_focus()

func startStory():
	transition()
	yield(self,"finiTransition")
	menuC.queue_free()
	
	while(not(win)):
		win = false
		
		scene = load("res://Scenes/Combat1.tscn")
		instance = scene.instance()
		calqueS.add_child(instance)
		
		transition()
		yield(self,"finiTransition")
		
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
		
		transition()
		yield(self,"finiTransition")
		
		instance.queue_free()
	
	win = false
	
	while(not(win)):
		win = false
		
		scene = load("res://Scenes/Combat2.tscn")
		instance = scene.instance()
		calqueS.add_child(instance)
		
		transition()
		yield(self,"finiTransition")
		
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
		
		transition()
		yield(self,"finiTransition")
		
		instance.queue_free()
	
	win = false
	
	while(not(win)):
		win = false
		
		scene = load("res://Scenes/Combat3.tscn")
		instance = scene.instance()
		calqueS.add_child(instance)
		
		transition()
		yield(self,"finiTransition")
		
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
		
		transition()
		yield(self,"finiTransition")
		
		instance.queue_free()
	
	win = false
	
	while(not(win)):
		win = false
		
		scene = load("res://Scenes/Combat4.tscn")
		instance = scene.instance()
		calqueS.add_child(instance)
		
		transition()
		yield(self,"finiTransition")
		
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
		
		instance.queue_free()
	
	win = false
	
	while(not(win)):
		win = false
		
		scene = load("res://Scenes/Combat5.tscn")
		instance = scene.instance()
		calqueS.add_child(instance)
		
		transition()
		yield(self,"finiTransition")
		
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
		
		transition()
		yield(self,"finiTransition")
		
		instance.queue_free()
	
	scene = load("res://Scenes/Menu.tscn")
	instance = scene.instance()
	calqueS.add_child(instance)
	menuC = instance
	
	transition()
	yield(self,"finiTransition")
	
	menuC.startB.grab_focus()

func selectBattle():
	
	transition()
	yield(self,"finiTransition")
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
	calqueS.add_child(instance)
	
	transition()
	yield(self,"finiTransition")
	
	yield(instance,"finCombat")
	
	transition()
	yield(self,"finiTransition")
	
	instance.queue_free()
	
	scene = load("res://Scenes/Menu.tscn")
	instance = scene.instance()
	
	menuC = instance
	calqueS.add_child(instance)
	
	transition()
	yield(self,"finiTransition")
	
	menuC.startB.grab_focus()

func langageMenu():
	load_menuText()

func transition():
	
	if(transitionS.offset.x == 0):
		while(transitionS.offset.x > -1280):
			transitionS.offset.x -= 20
			$TimerTransi.start()
			yield($TimerTransi, "timeout")
	else:
		while(transitionS.offset.x < 0):
			transitionS.offset.x += 20
			$TimerTransi.start()
			yield($TimerTransi, "timeout")
	
	emit_signal("finiTransition")
