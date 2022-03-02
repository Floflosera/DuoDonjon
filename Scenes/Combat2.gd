extends "res://Scenes/Combat.gd"

onready var combattantEnnemi = $EnnemiGroup/Ennemi2

func _ready():
	randomize() #à mettre dans le main
	
	#Pour le combat 2 on cache les compétences qui ne sont pas encore disponible
	combattantHarry.skill5.hide()
	combattantFlaux.skill4.hide()
	combattantFlaux.skill5.hide()
	
	#au début du combat on stocke tous les combattants dans un tableau
	combattants = [combattantHarry, combattantFlaux, combattantEnnemi]
	
	ordreTour() #définie l'ordre des tours au début du combat
	
	litDialogue($DialogueInterface.dialogueIntro()) #lancement du premier dialogue
	yield($DialogueInterface, "dialogueFini")
	
	#Exemple de boucle d'un combat
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && combattantEnnemi.pv > 0):
		nTour += 1 #chaque tour le numéro du tour augmente de 1
		
		if(nTour == 6):
			litDialogue($DialogueInterface.dialogueMid())
			yield($DialogueInterface, "dialogueFini")
		
		if(((combattantEnnemi.choixSkill == 2) && not(combattantEnnemi.assomme)) && hintFlag == 0):
			litDialogue($DialogueInterface.dialogueHint1())
			yield($DialogueInterface, "dialogueFini")
			hintFlag += 1
		elif(((combattantEnnemi.choixSkill == 2) && not(combattantEnnemi.assomme)) && hintFlag == 1):
			litDialogue($DialogueInterface.dialogueHint2())
			yield($DialogueInterface, "dialogueFini")
		
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
		
		deroulementTour() #lance les actions choisies et celle(s) de ou des ennemi(s)
		yield(self, "derouleTourFini")
		
		nar.set_text("")
	
	if(combattantEnnemi.pv == 0):
		$EnnemiGroup.hide()
		litDialogue($DialogueInterface.dialogueEnd())
		yield($DialogueInterface, "dialogueFini")
	elif(combattantHarry.pv > 0 && combattantFlaux.pv > 0):
		nar.narraText("Game Over")



