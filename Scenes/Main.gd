extends "res://Scenes/ParentMain.gd"

signal finiTransition
signal pres

signal anyInput

var scene
var scene2
var instance

onready var pres = false

onready var waiting_input = false
onready var battleN = 0

onready var win = false

onready var intro = false

func _ready():
	
	transitionS.show()
	pres = true
	emit_signal("pres")
	menuC.sousMenu.show()
	menuC.settingsM.show()
	
	$TimerTransi.set_wait_time(1.0)
	$TimerTransi.start()
	yield($TimerTransi, "timeout")
	$TimerTransi.set_wait_time(0.01)
	
	ostDiscussion.play()
	transition()
	menuC.settingsMultiYes.grab_focus()
	yield(self, "finiTransition")
	
	yield(menuC.settingsQuitSet, "pressed") #Valider pressé
	
	intro = true
	#menuC.startB.grab_focus()

func startStory():
	ostDiscussion.stop()
	scene = preload("res://Scenes/Combat1.tscn")
	transition()
	yield(self,"finiTransition")
	menuC.queue_free()
	
	while(not(win)):
		win = false
		
		#scene = preload("res://Scenes/Combat1.tscn")
		instance = scene.instance()
		calqueS.add_child(instance)
		
		transition()
		yield(self,"finiTransition")
		
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
			scene = preload("res://Scenes/Combat2.tscn")
		else:
			scene = preload("res://Scenes/Combat1.tscn")
		
		transition()
		yield(self,"finiTransition")
		
		instance.queue_free()
	
	win = false
	
	while(not(win)):
		win = false
		
		#scene = preload("res://Scenes/Combat2.tscn")
		instance = scene.instance()
		calqueS.add_child(instance)
		
		transition()
		yield(self,"finiTransition")
		
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
			scene = preload("res://Scenes/Combat3.tscn")
		else:
			scene = preload("res://Scenes/Combat2.tscn")
		
		transition()
		yield(self,"finiTransition")
		
		instance.queue_free()
	
	win = false
	
	while(not(win)):
		win = false
		
		#scene = preload("res://Scenes/Combat3.tscn")
		instance = scene.instance()
		calqueS.add_child(instance)
		
		transition()
		yield(self,"finiTransition")
		
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
			scene = preload("res://Scenes/Combat4.tscn")
		else:
			scene = preload("res://Scenes/Combat3.tscn")
		
		transition()
		yield(self,"finiTransition")
		
		instance.queue_free()
	
	win = false
	
	while(not(win)):
		win = false
		
		#scene = preload("res://Scenes/Combat4.tscn")
		instance = scene.instance()
		calqueS.add_child(instance)
		
		transition()
		yield(self,"finiTransition")
		
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
			scene = preload("res://Scenes/Combat5.tscn")
		else:
			scene = preload("res://Scenes/Combat4.tscn")
		
		transition()
		yield(self,"finiTransition")
		
		instance.queue_free()
	
	win = false
	
	while(not(win)):
		win = false
		
		#scene = preload("res://Scenes/Combat5.tscn")
		instance = scene.instance()
		calqueS.add_child(instance)
		
		transition()
		yield(self,"finiTransition")
		
		yield(instance,"finCombat")
		
		if(not(instance.gameover)):
			win = true
			scene = preload("res://Scenes/End.tscn")
		else:
			scene = preload("res://Scenes/Combat5.tscn")
		
		transition()
		yield(self,"finiTransition")
		
		instance.queue_free()
	
	instance = scene.instance()
	calqueS.add_child(instance)
	
	transition()
	yield(self,"finiTransition")
	
	waiting_input = true
	yield(self,"anyInput")
	
	transition()
	yield(self,"finiTransition")
	
	scene = preload("res://Scenes/Menu.tscn")
	
	instance.queue_free()
	
	instance = scene.instance()
	calqueS.add_child(instance)
	menuC = instance
	
	ostDiscussion.play()
	
	transition()
	yield(self,"finiTransition")
	
	menuC.startB.grab_focus()

func _input(event):
	if waiting_input:
		if event is InputEventKey:
			emit_signal("anyInput")
			waiting_input = false

func selectBattle():
	
	ostDiscussion.stop()
	
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
	
	battleN = menuC.sel
	
	transition()
	yield(self,"finiTransition")
	menuC.queue_free()
	
	instance = scene.instance()
	calqueS.add_child(instance)
	
	transition()
	yield(self,"finiTransition")
	
	yield(instance,"finCombat")
	
	if(battleN == 5): 
		if(not(instance.gameover)):
			scene = preload("res://Scenes/End.tscn")
			
			transition()
			yield(self,"finiTransition")
			
			instance.queue_free()
			
			instance = scene.instance()
			calqueS.add_child(instance)
			
			transition()
			yield(self,"finiTransition")
			
			waiting_input = true
			yield(self,"anyInput")
	
	scene = preload("res://Scenes/Menu.tscn")
	
	transition()
	yield(self,"finiTransition")
	
	instance.queue_free()
	
	instance = scene.instance()
	
	menuC = instance
	calqueS.add_child(instance)
	
	ostDiscussion.play()
	
	transition()
	yield(self,"finiTransition")
	
	menuC.startB.grab_focus()

func langageMenu():
	load_menuText()

#ceci est la première transition testée qui est en écran noir qui glisse sur l'écran
func transitionS():
	
	#transitionS.offset.x = 1280
	#transitionS.modulate.a8 = 255
	
	if(transitionS.offset.x == 0):
		transitionS.playing = true
		while(transitionS.offset.x > 0):
			transitionS.offset.x -= 40
			$TimerTransi.start()
			yield($TimerTransi, "timeout")
		$TimerTransi.set_wait_time(1.0)
		$TimerTransi.start()
		yield($TimerTransi, "timeout")
		$TimerTransi.set_wait_time(0.01)
	else:
		while(transitionS.offset.x > -1280):
			transitionS.offset.x -= 40
			$TimerTransi.start()
			yield($TimerTransi, "timeout")
		transitionS.offset.x = 0
		transitionS.playing = false
	
	emit_signal("finiTransition")

func transition():
	
	if(transitionS.modulate.a8 == 0):
		#transitionS.playing = true
		while(transitionS.modulate.a8 < 255):
			transitionS.modulate.a8 += 5
			$TimerTransi.start()
			yield($TimerTransi, "timeout")
		#$TimerTransi.set_wait_time(1.0)
		#$TimerTransi.start()
		#yield($TimerTransi, "timeout")
		#$TimerTransi.set_wait_time(0.01)
	else:
		while(transitionS.modulate.a8 > 0):
			transitionS.modulate.a8 -= 5
			$TimerTransi.start()
			yield($TimerTransi, "timeout")
		#transitionS.playing = false
	
	emit_signal("finiTransition")
