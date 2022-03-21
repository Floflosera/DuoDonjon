extends "Combat.gd"

onready var combattantEnnemi = $EnnemiGroup/Ennemi1_1

onready var flagBras1 = false
onready var flagBras2 = false

func _ready():
	randomize()
	
	#Pour le combat 2 on cache les compétences qui ne sont pas encore disponible
	combattantHarry.skill4.hide()
	combattantHarry.skill5.hide()
	get_tree().call_group("FlauxButtons", "hide")
	combattantFlaux.labelVie.hide()
	$GeneralInterface/HBoxContainer/Flaux/CadreMenu/Background/Menu/VBoxContainer/Separation.hide()
	combattantFlaux.horsCombat = true
	
	#au début du combat on stocke tous les combattants dans un tableau
	combattants = [combattantHarry, combattantFlaux, combattantEnnemi]
	#on les stocke aussi dans un autre tableau pour utiliser cette ordre lors de la priorité
	combattantsBase = [combattantHarry, combattantFlaux, combattantEnnemi]
	
	ordreTour() #définie l'ordre des tours au début du combat
	
	litDialogue($DialogueInterface.dialogueIntro()) #lancement du premier dialogue
	yield($DialogueInterface, "dialogueFini")
	
	#Exemple de boucle d'un combat
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && combattantEnnemi.pv > 0):
		nTour += 1 #chaque tour le numéro du tour augmente de 1
		
		if((nTour == 4) && (combattantEnnemi.aBD.pv > 0 && combattantEnnemi.aBG.pv > 0)):
			litDialogue($DialogueInterface.dialogueHint1())
			yield($DialogueInterface, "dialogueFini")
			hintFlag = true
		elif((nTour > 4 && nTour % 4 == 0) && (combattantEnnemi.aBD.pv > 0 && combattantEnnemi.aBG.pv > 0) && hintFlag):
			litDialogue($DialogueInterface.dialogueHint2())
			yield($DialogueInterface, "dialogueFini")
			pass
		
		if((combattantEnnemi.aBD.pv == 0 || combattantEnnemi.aBG.pv == 0) && not(flagBras1)):
			litDialogue($DialogueInterface.dialogueBroken1())
			yield($DialogueInterface, "dialogueFini")
			flagBras1 = true
		elif((combattantEnnemi.aBD.pv == 0 && combattantEnnemi.aBG.pv == 0) && not(flagBras2)):
			litDialogue($DialogueInterface.dialogueBroken2())
			yield($DialogueInterface, "dialogueFini")
			flagBras2 = true
		
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
		
		deroulementTour() #lance les actions choisies et celle(s) de ou des ennemi(s)
		yield(self, "derouleTourFini")
		
		nar.set_text("")
	
	if(combattantEnnemi.pv == 0):
		$EnnemiGroup.hide()
		litDialogue($DialogueInterface.dialogueEnd())
		yield($DialogueInterface, "dialogueFini")
	elif(combattantHarry.pv == 0 && combattantFlaux.pv == 0):
		gameover = true
		nar.narraText("Game Over")
		yield(nar,"narraTextFini")
		$TimerActions.start()
		yield($TimerActions, "timeout")
	
	emit_signal("finCombat")
