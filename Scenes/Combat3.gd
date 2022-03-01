extends "res://Scenes/Combat.gd"

onready var combattantEnnemi = $EnnemiGroup/Ennemi3

func _ready():
	randomize()
	
	#on cache le skill que Flaux n'a pas encore
	combattantFlaux.skill5.hide()
	
	combattants = [combattantHarry, combattantFlaux, combattantEnnemi]
	
	ordreTour()
	
	#litDialogue($DialogueInterface.dialogueIntro()) #lancement du premier dialogue
	#yield($DialogueInterface, "dialogueFini")
	
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && combattantEnnemi.pv > 0):
		nTour += 1
		
		#if(nTour == 6):
			#litDialogue($DialogueInterface.dialogueMid())
			#yield($DialogueInterface, "dialogueFini")
		
		#if((((nTour-1) % 4 == 3) && not(combattantEnnemi.auSol)) && hintFlag == 0):
			#litDialogue($DialogueInterface.dialogueHint1())
			#yield($DialogueInterface, "dialogueFini")
			#hintFlag += 1
		#elif((((nTour-1) % 4 == 3) && not(combattantEnnemi.assomme)) && hintFlag == 1):
			#litDialogue($DialogueInterface.dialogueHint2())
			#yield($DialogueInterface, "dialogueFini")
		
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
		
		if(combattantHarry.choixSkill == 4 && combattantFlaux.choixSkill == 1):
			narraText(combattantHarry.aTextSkill())
			yield(self,"narraTextFini")
			actionCombattant(combattantHarry)
			yield(self,"actionFinie")
			narraText(combattantFlaux.aTextSkill())
			yield(self,"narraTextFini")
			actionCombattant(combattantFlaux)
			yield(self,"actionFinie")
			combattantEnnemi.seclateAuSol()
			narraText(combattantEnnemi.aTextSkill2())
			yield(self,"narraTextFini")
		
		deroulementTour() #lance les actions choisies et celle(s) de ou des ennemi(s)
		yield(self, "derouleTourFini")
		
		nar.set_text("")
	
	if(combattantEnnemi.pv == 0):
		$EnnemiGroup.hide()
		#litDialogue($DialogueInterface.dialogueEnd())
		#yield($DialogueInterface, "dialogueFini")
	elif(combattantHarry.pv > 0 && combattantFlaux.pv > 0):
		nar.narraText("Game Over")
	
	
	
