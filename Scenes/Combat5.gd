extends "res://Scenes/Combat.gd"

onready var combattantEnnemi = $EnnemiGroup/Ennemi5

onready var attaqueEfficace = false
onready var desarme = false

onready var nTourDebutPhase2 = -1
onready var flagLucyDepasseF = false

func _ready():
	randomize() #en mettre un seul dans le main
	
	combattants = [combattantHarry, combattantFlaux, combattantEnnemi]
	combattantsBase = [combattantEnnemi, combattantHarry, combattantFlaux]
	
	ordreTour()
	
	litIntroDialogue($DialogueInterface.dialogueIntro()) #lancement du premier dialogue
	yield($DialogueInterface, "dialogueIntroFini")
	combattantEnnemi.changerSprite()
	
	$BattleSong.play()
	
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && combattantEnnemi.pv > 0):
		nTour += 1
		
		if(nTour == 3 && (combattantEnnemi.armeF.pv > 707 && combattantEnnemi.armeB.pv > 666)):
			litDialogue($DialogueInterface.dialogueHint1())
			yield($DialogueInterface, "dialogueFini")
			combattantEnnemi.changerSprite()
		
		if(not(attaqueEfficace) && (combattantEnnemi.armeF.pv <= 707 || combattantEnnemi.armeB.pv <= 666)):
			litDialogue($DialogueInterface.dialogueEffective())
			yield($DialogueInterface, "dialogueFini")
			attaqueEfficace = true
			combattantEnnemi.changerSprite()
		
		if(not(desarme) && (combattantEnnemi.armeF.pv == 0 || combattantEnnemi.armeB.pv == 0)):
			litDialogue($DialogueInterface.dialogueOneWeapon())
			yield($DialogueInterface, "dialogueFini")
			desarme = true
			combattantEnnemi.changerSprite()
		
		if(combattantEnnemi.phase1 && ((combattantEnnemi.armeB.pv == 0 && combattantEnnemi.armeF.pv == 0)\
		|| (combattantEnnemi.pv <= combattantEnnemi.pvmax/2))):
			combattantEnnemi.armeB.hide() #potentiellement déjà caché
			combattantEnnemi.armeF.hide()
			combattantEnnemi.phase1 = false
			combattantEnnemi.pv = combattantEnnemi.pvmax
			combattantEnnemi.defense = 15
			combattantEnnemi.vitesse = 5
			
			litDialogue($DialogueInterface.dialoguePhase2())
			yield($DialogueInterface, "dialogueFini")
			
			combattantEnnemi.changerSprite()
			nTourDebutPhase2 = nTour
		
		if(nTourDebutPhase2 != -1 && nTourDebutPhase2 < nTour && combattantFlaux.choixSkill == 0\
		&& combattantFlaux.pv > 0 && not(flagLucyDepasseF)):
			litDialogue($DialogueInterface.dialogueOutspeed())
			yield($DialogueInterface, "dialogueFini")
			flagLucyDepasseF = true
			combattantEnnemi.changerSprite()
		
		if(nTourDebutPhase2 != -1 && nTour - nTourDebutPhase2 == 3):
			litDialogue($DialogueInterface.dialogueHint2())
			yield($DialogueInterface, "dialogueFini")
			combattantEnnemi.changerSprite()
		
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
		
		if(nTour == 1):
			litDialogue($DialogueInterface.dialogueWeapons()) #lancement du premier dialogue
			yield($DialogueInterface, "dialogueFini")
			combattantEnnemi.changerSprite()
		
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
	

