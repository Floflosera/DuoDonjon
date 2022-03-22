extends "res://Scenes/ParentMain.gd"

signal finiTransition

var scene
var instance

onready var win = false

func _ready():
	
	#OUBLIE PAS CES DEUX PARAMETRES SI TU CHANGES, MÊME SI TU CHANGES PAS EN FAIT, OUAIS
	#oof quelle idée d'écrire en maj, après je vais voir que ça, wait...
	transitionS.offset.x = -1280
	transitionS.modulate.a8 = 0

	menuC.startB.grab_focus()

func startStory():
	transition()
	yield(self,"finiTransition")
	menuC.queue_free()
	
	while(not(win)):
		win = false
		
		scene = preload("res://Scenes/Combat1.tscn")
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
		
		scene = preload("res://Scenes/Combat2.tscn")
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
		
		scene = preload("res://Scenes/Combat3.tscn")
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
		
		scene = preload("res://Scenes/Combat4.tscn")
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
		
		scene = preload("res://Scenes/Combat5.tscn")
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
	
	scene = preload("res://Scenes/Menu.tscn")
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
			scene = preload("res://Scenes/Combat1.tscn")
		2:
			scene = preload("res://Scenes/Combat2.tscn")
		3:
			scene = preload("res://Scenes/Combat3.tscn")
		4:
			scene = preload("res://Scenes/Combat4.tscn")
		5:
			scene = preload("res://Scenes/Combat5.tscn")
	
	instance = scene.instance()
	calqueS.add_child(instance)
	
	transition()
	yield(self,"finiTransition")
	
	yield(instance,"finCombat")
	
	transition()
	yield(self,"finiTransition")
	
	instance.queue_free()
	
	scene = preload("res://Scenes/Menu.tscn")
	instance = scene.instance()
	
	menuC = instance
	calqueS.add_child(instance)
	
	transition()
	yield(self,"finiTransition")
	
	menuC.startB.grab_focus()

func langageMenu():
	load_menuText()

func transitionS():
	
	if(transitionS.offset.x == 0):
		transitionS.playing = true
		while(transitionS.offset.x > -1280):
			transitionS.offset.x -= 40
			$TimerTransi.start()
			yield($TimerTransi, "timeout")
		$TimerTransi.set_wait_time(1.0)
		$TimerTransi.start()
		yield($TimerTransi, "timeout")
		$TimerTransi.set_wait_time(0.01)
	else:
		while(transitionS.offset.x > -2560):
			transitionS.offset.x -= 40
			$TimerTransi.start()
			yield($TimerTransi, "timeout")
		transitionS.offset.x = 0
		transitionS.playing = false
	
	emit_signal("finiTransition")

func transition():
	
	if(transitionS.modulate.a8 == 0):
		transitionS.playing = true
		while(transitionS.modulate.a8 < 255):
			transitionS.modulate.a8 += 5
			$TimerTransi.start()
			yield($TimerTransi, "timeout")
		$TimerTransi.set_wait_time(1.0)
		$TimerTransi.start()
		yield($TimerTransi, "timeout")
		$TimerTransi.set_wait_time(0.01)
	else:
		while(transitionS.modulate.a8 > 0):
			transitionS.modulate.a8 -= 5
			$TimerTransi.start()
			yield($TimerTransi, "timeout")
		transitionS.playing = false
	
	emit_signal("finiTransition")
