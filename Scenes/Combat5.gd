extends "res://Scenes/Combat.gd"

onready var combattantEnnemi = $EnnemiGroup/Ennemi5


func _ready():
	randomize() #en mettre un seul dans le main
	
	combattants = [combattantHarry, combattantFlaux, combattantEnnemi]
	combattantsBase = [combattantEnnemi, combattantHarry, combattantFlaux]
	
	ordreTour()
	
	#litDialogue($DialogueInterface.dialogueIntro()) #lancement du premier dialogue
	#yield($DialogueInterface, "dialogueFini")
	
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && combattantEnnemi.pv > 0):
		nTour += 1
		
		#if(nTour == 6):
			#litDialogue($DialogueInterface.dialogueMid())
			#yield($DialogueInterface, "dialogueFini")
		
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
		
		deroulementTour() #lance les actions choisies et celle(s) de ou des ennemi(s)
		yield(self, "derouleTourFini")
		
		nar.set_text("")
	
	if(combattantEnnemi.pv == 0):
		$EnnemiGroup.hide()
		#litDialogue($DialogueInterface.dialogueEnd())
		#yield($DialogueInterface, "dialogueFini")
	elif(combattantHarry.pv == 0 && combattantFlaux.pv == 0):
		nar.narraText("Game Over")
	
	
	

