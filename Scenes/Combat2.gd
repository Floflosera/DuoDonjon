extends Node

func _ready():
	#$DialogueInterface.dialogueTest() #Permet de lancer un dialogue, ici le Test, celui pour tester (incroyable)
	#yield($DialogueInterface, "dialogueFini")
	#$DialogueInterface.visible = false
	$GeneralInterface.choixTour() #lance le choix du tour, simple test pour l'instant, il sera au début de chaque tour
	yield($GeneralInterface, "choixTourFini")
	#$DialogueInterface.visible = true
	#$DialogueInterface.dialogueTest2()
	#yield($DialogueInterface, "dialogueFini")
	#$DialogueInterface.visible = false
