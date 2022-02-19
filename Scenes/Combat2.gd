extends Node

signal derouleTourFini

onready var combattantHarry = $GeneralInterface/HBoxContainer/Harry
onready var combattantFlaux = $GeneralInterface/HBoxContainer/Flaux

onready var combattants = [combattantHarry, combattantFlaux]#, $Ennemi2]
onready var nc = [0, 1]#, 2]

var temp

func _ready():
	ordreTour()
	
	#$DialogueInterface.visible = true
	#$DialogueInterface.dialogueTest() #Permet de lancer un dialogue, ici le Test, celui pour tester (incroyable)
	#yield($DialogueInterface, "dialogueFini")
	#$DialogueInterface.visible = false
	
	
	while(true):
		$GeneralInterface.choixTour() #lance le choix du tour, simple test pour l'instant, il sera au début de chaque tour
		yield($GeneralInterface, "choixTourFini")
	
		deroulementTour()
		yield(self, "derouleTourFini")

func ordreTour():
	for i in range(nc.size()-1):
		for j in range(i+1, nc.size()):
			if(combattants[i].vitesse < combattants[j].vitesse):
				temp = nc[i]
				nc[i] = nc[i+1]
				nc[i+1] = temp

func deroulementTour():
	$TimerActions.start()
	yield($TimerActions, "timeout")
	if(combattantFlaux.priorite):
		combattantFlaux.castSkill()
		yield(combattantFlaux, "skillCasted")
		$TimerActions.start()
		yield($TimerActions, "timeout")
	if(combattantHarry.priorite):
		combattantHarry.castSkill()
		yield(combattantHarry, "skillCasted")
		$TimerActions.start()
		yield($TimerActions, "timeout")
	
	for i in nc:
		if(combattants[i].tourEffectue == false):
			combattants[i].castSkill()
			yield(combattants[i], "skillCasted")
			$TimerActions.start()
			yield($TimerActions, "timeout")
	
	emit_signal("derouleTourFini")
	
	


func _on_TimerActions_timeout():
	$TimerActions.stop()
