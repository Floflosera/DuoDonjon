extends "res://Scenes/Combat.gd"

onready var combattantEnnemi1 = get_node("EnnemiGroup/Ennemi4-1")
onready var combattantEnnemi2 = get_node("EnnemiGroup/Ennemi4-2")

#faut revoir
func _ready():
	randomize() #en mettre un seul dans le main
	
	combattants = [combattantHarry, combattantFlaux, combattantEnnemi1, combattantEnnemi2]
	
	ordreTour()
	
	#litDialogue($DialogueInterface.dialogueIntro()) #lancement du premier dialogue
	#yield($DialogueInterface, "dialogueFini")
	
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && (combattantEnnemi1.pv > 0 || combattantEnnemi2.pv > 0)):
		nTour += 1
		
		#if(nTour == 6):
			#litDialogue($DialogueInterface.dialogueMid())
			#yield($DialogueInterface, "dialogueFini")
		
		#if(((nTour == 5) && combattantEnnemi1.pv > 0) && hintFlag == 0):
			#litDialogue($DialogueInterface.dialogueHint1())
			#yield($DialogueInterface, "dialogueFini")
			#hintFlag += 1
		#elif(((nTour == 8) && combattantEnnemi1.pv > 0) && hintFlag == 1):
			#litDialogue($DialogueInterface.dialogueHint2())
			#yield($DialogueInterface, "dialogueFini")
		
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
		
		deroulementTour() #lance les actions choisies et celle(s) de ou des ennemi(s)
		yield(self, "derouleTourFini")
		
		nar.set_text("")
	
	if(combattantEnnemi1.pv == 0 && combattantEnnemi2.pv == 0):
		$EnnemiGroup.hide()
		#litDialogue($DialogueInterface.dialogueEnd())
		#yield($DialogueInterface, "dialogueFini")
	elif(combattantHarry.pv > 0 && combattantFlaux.pv > 0):
		nar.narraText("Game Over")
	
	
	
