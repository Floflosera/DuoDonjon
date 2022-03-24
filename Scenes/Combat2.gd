extends "res://Scenes/Combat.gd"

onready var combattantEnnemi = $EnnemiGroup/Ennemi2

onready var flagAssomme = false

func _ready():
	randomize() #à mettre dans le main
	
	#Pour le combat 2 on cache les compétences qui ne sont pas encore disponible
	combattantHarry.skill5.hide()
	combattantFlaux.skill4.hide()
	combattantFlaux.skill5.hide()
	
	#au début du combat on stocke tous les combattants dans un tableau
	combattants = [combattantHarry, combattantFlaux, combattantEnnemi]
	#on les stocke aussi dans un autre tableau pour utiliser cette ordre lors de la priorité
	combattantsBase = [combattantHarry, combattantFlaux, combattantEnnemi]
	
	ordreTour() #définie l'ordre des tours au début du combat
	
	#litDialogue($DialogueInterface.dialogueTest())
	#yield($DialogueInterface, "dialogueFini")
	
	litDialogue($DialogueInterface.dialogueIntro()) #lancement du premier dialogue
	yield($DialogueInterface, "dialogueFini")
	
	#Exemple de boucle d'un combat
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && combattantEnnemi.pv > 0):
		nTour += 1 #chaque tour le numéro du tour augmente de 1
		
		if(((combattantEnnemi.choixSkill == 2) && not(combattantEnnemi.assomme)) && not(hintFlag)):
			litDialogue($DialogueInterface.dialogueHint1())
			yield($DialogueInterface, "dialogueFini")
			hintFlag = true
		elif(((combattantEnnemi.choixSkill == 2) && not(combattantEnnemi.assomme)) && hintFlag):
			litDialogue($DialogueInterface.dialogueHint2())
			yield($DialogueInterface, "dialogueFini")
		elif(not(flagAssomme) && combattantEnnemi.assomme):																#DIALOGUE
			litDialogue($DialogueInterface.dialogueStun())
			yield($DialogueInterface, "dialogueFini")
			flagAssomme = true
		
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
		
		deroulementTour() #lance les actions choisies et celle(s) de ou des ennemi(s)
		yield(self, "derouleTourFini")
		
		nar.set_text("")
	
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
	
	emit_signal("finCombat")
