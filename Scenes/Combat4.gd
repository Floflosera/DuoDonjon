extends "res://Scenes/Combat.gd"

onready var combattantEnnemi1 = $EnnemiGroup/Ennemi4_1
onready var combattantEnnemi2 = $EnnemiGroup/Ennemi4_2

onready var flagComptSoin = 0
onready var flagMageBlancD = false
onready var flagMageNoirD = false

#faut revoir
func _ready():
	randomize() #en mettre un seul dans le main
	
	combattants = [combattantHarry, combattantFlaux, combattantEnnemi1, combattantEnnemi2]
	#on met d'abord les ennemis car on veut que les ennemis agissent prioriairement
	combattantsBase = [combattantEnnemi1, combattantEnnemi2, combattantHarry, combattantFlaux]
	
	ordreTour()
	
	#litDialogue($DialogueInterface.dialogueIntro()) #lancement du premier dialogue
	#yield($DialogueInterface, "dialogueFini")
	
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && (combattantEnnemi1.pv > 0 || combattantEnnemi2.pv > 0)):
		nTour += 1
		
		if(((nTour == 5) && combattantEnnemi1.pv > 0) && not(hintFlag)):
			#litDialogue($DialogueInterface.dialogueHint1())
			#yield($DialogueInterface, "dialogueFini")
			hintFlag = true
		
		if(combattantEnnemi1.choixSkill == 0 && flagComptSoin < 2):
			flagComptSoin += 1
			if(flagComptSoin == 2):
				#litDialogue($DialogueInterface.dialogueName())
				#yield($DialogueInterface, "dialogueFini")
				pass
		
		if(combattantEnnemi1.pv == 0 && combattantEnnemi2.pv > 0) && not(flagMageBlancD):
			#litDialogue($DialogueInterface.dialogueName())
			#yield($DialogueInterface, "dialogueFini")
			flagMageBlancD = true
		
		if(combattantEnnemi2.pv == 0 && combattantEnnemi1.pv > 0) && not(flagMageNoirD): #secret
			#litDialogue($DialogueInterface.dialogueName())
			#yield($DialogueInterface, "dialogueFini")
			flagMageNoirD = true
		
		
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
		
		deroulementTour() #lance les actions choisies et celle(s) de ou des ennemi(s)
		yield(self, "derouleTourFini")
		
		nar.set_text("")
	
	if(combattantEnnemi1.pv == 0 && combattantEnnemi2.pv == 0):
		$EnnemiGroup.hide()
		#litDialogue($DialogueInterface.dialogueEnd())
		#yield($DialogueInterface, "dialogueFini")
	elif(combattantHarry.pv == 0 && combattantFlaux.pv == 0):
		gameover = true
		nar.narraText("Game Over")
		yield(nar,"narraTextFini")
	
	emit_signal("finCombat")
	
