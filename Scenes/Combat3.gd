extends "res://Scenes/Combat.gd"

onready var combattantEnnemi = $EnnemiGroup/Ennemi3

#booléen pour dialogue
onready var flagAgitAvant = false

func _ready():
	randomize()
	
	#on cache le skill que Flaux n'a pas encore
	combattantFlaux.skill5.hide()
	
	combattants = [combattantHarry, combattantFlaux, combattantEnnemi]
	combattantsBase = [combattantHarry, combattantFlaux, combattantEnnemi]
	
	ordreTour()
	
	litIntroDialogue($DialogueInterface.dialogueIntro()) #lancement du premier dialogue
	yield($DialogueInterface, "dialogueIntroFini")
	
	$BattleSong.play()
	
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && combattantEnnemi.pv > 0):
		nTour += 1
		
		if((((nTour-1) % 4 == 3) && not(combattantEnnemi.auSol)) && not(hintFlag)):
			litDialogue($DialogueInterface.dialogueHint1())
			yield($DialogueInterface, "dialogueFini")
			hintFlag = true
		elif((((nTour-1) % 4 == 3) && not(combattantEnnemi.auSol)) && hintFlag):
			litDialogue($DialogueInterface.dialogueHint2())
			yield($DialogueInterface, "dialogueFini")
		
		if(nTour > 1 && combattantFlaux.choixSkill !=0 && not(flagAgitAvant)):
			if(not(combattantEnnemi.auSol)):
				litDialogue($DialogueInterface.dialogueOutspeed())
				yield($DialogueInterface, "dialogueFini")
			flagAgitAvant = true
		
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
		
		deroulementTour() #lance les actions choisies et celle(s) de ou des ennemi(s)
		yield(self, "derouleTourFini")
		
		nar.set_text("")
	
	$BattleSong.stop()
	
	if(combattantEnnemi.pv == 0):
		$EnnemiGroup.hide()
		litDialogue($DialogueInterface.dialogueEnd())
		yield($DialogueInterface, "dialogueFini")
		combattantHarry.changerSpriteDia(0)
		combattantFlaux.changerSpriteDia(0)
		$DialogueInterface.show()
	elif(combattantHarry.pv == 0 && combattantFlaux.pv == 0):
		gameover = true
		narraText("Game Over")
		yield(self,"narraTextFini")
		$TimerActions.start()
		yield($TimerActions, "timeout")
	
	fini()
	
