extends "res://Scenes/Combat.gd"

onready var combattantEnnemi = $EnnemiGroup/Ennemi5

onready var attaqueEfficace = false
onready var pasDesarme = false
onready var desarme = false

onready var nTourDebutPhase2 = 0
onready var flagLucyDepasseF = false

func _ready():
	randomize() #en mettre un seul dans le main
	
	combattants = [combattantHarry, combattantFlaux, combattantEnnemi]
	combattantsBase = [combattantEnnemi, combattantHarry, combattantFlaux]
	
	ordreTour()
	
	#litDialogue($DialogueInterface.dialogueIntro()) #lancement du premier dialogue
	#yield($DialogueInterface, "dialogueFini")
	
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && combattantEnnemi.pv > 0):
		nTour += 1
		
		if(nTour == 4 && (combattantEnnemi.armeF.pv > 707 && combattantEnnemi.armeB.pv > 666)):
			#litDialogue($DialogueInterface.dialogueName())
			#yield($DialogueInterface, "dialogueFini")
			pass
		
		if(not(attaqueEfficace) && (combattantEnnemi.armeF.pv <= 707 || combattantEnnemi.armeB.pv <= 666)):
			#litDialogue($DialogueInterface.dialogueName())
			#yield($DialogueInterface, "dialogueFini")
			attaqueEfficace = true
		
		if(nTour == 8 && not(pasDesarme) && (combattantEnnemi.armeF.pv > 0 && combattantEnnemi.armeB.pv > 0)):
			#litDialogue($DialogueInterface.dialogueName())
			#yield($DialogueInterface, "dialogueFini")
			pasDesarme = true
		
		if(not(desarme) && (combattantEnnemi.armeF.pv == 0 || combattantEnnemi.armeB.pv == 0)):
			#litDialogue($DialogueInterface.dialogueName())
			#yield($DialogueInterface, "dialogueFini")
			desarme = true
		
		if(combattantEnnemi.phase1 && ((combattantEnnemi.armeB.pv == 0 && combattantEnnemi.armeF.pv == 0)\
		|| (combattantEnnemi.pv <= combattantEnnemi.pvmax/2))):
			combattantEnnemi.armeB.hide() #potentiellement déjà caché
			combattantEnnemi.armeF.hide()
			combattantEnnemi.phase1 = false
			combattantEnnemi.changerSprite()
			combattantEnnemi.pv = combattantEnnemi.pvmax
			combattantEnnemi.defense = 15
			combattantEnnemi.vitesse = 5
			
			#litDialogue($DialogueInterface.dialogueName())
			#yield($DialogueInterface, "dialogueFini")
			
			nTourDebutPhase2 = nTour
		
		if(nTourDebutPhase2 != 0 && nTourDebutPhase2 < nTour && combattantFlaux.choixSkill == 0\
		&& combattantFlaux.pv > 0 && not(flagLucyDepasseF)):
			#litDialogue($DialogueInterface.dialogueName())
			#yield($DialogueInterface, "dialogueFini")
			flagLucyDepasseF = true
		
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
		
		if(nTour == 1):
			#litDialogue($DialogueInterface.dialogueName()) #lancement du premier dialogue
			#yield($DialogueInterface, "dialogueFini")
			pass
		
		deroulementTour() #lance les actions choisies et celle(s) de ou des ennemi(s)
		yield(self, "derouleTourFini")
		
		nar.set_text("")
	
	if(combattantEnnemi.pv == 0):
		$EnnemiGroup.hide()
		#litDialogue($DialogueInterface.dialogueEnd())
		#yield($DialogueInterface, "dialogueFini")
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
	

