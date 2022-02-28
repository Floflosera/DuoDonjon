extends "res://Scenes/Combat.gd"

onready var combattantEnnemi2 = $EnnemiGroup/Ennemi2

onready var hintFlag = 0

func _ready():
	randomize() #à mettre dans le main
	
	#Pour le combat 2 on cache les compétences qui ne sont pas encore disponible
	combattantHarry.skill5.hide()
	combattantFlaux.skill4.hide()
	combattantFlaux.skill5.hide()
	
	#au début du combat on stocke tous les combattants dans un tableau
	combattants = [combattantHarry, combattantFlaux, combattantEnnemi2]
	
	ordreTour() #définie l'ordre des tours au début du combat
	
	litDialogue($DialogueInterface.dialogueIntro()) #lancement du premier dialogue
	yield($DialogueInterface, "dialogueFini")
	
	#Exemple de boucle d'un combat
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && combattantEnnemi2.pv > 0):
		nTour += 1 #chaque tour le numéro du tour augmente de 1
		
		if(nTour == 7):
			litDialogue($DialogueInterface.dialogueMid())
			yield($DialogueInterface, "dialogueFini")
		
		if(((combattantEnnemi2.choixSkill == 2) && not(combattantEnnemi2.assomme)) && hintFlag == 0):
			litDialogue($DialogueInterface.dialogueHint1())
			yield($DialogueInterface, "dialogueFini")
			hintFlag += 1
		elif(((combattantEnnemi2.choixSkill == 2) && not(combattantEnnemi2.assomme)) && hintFlag == 1):
			litDialogue($DialogueInterface.dialogueHint2())
			yield($DialogueInterface, "dialogueFini")
		
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
		
		deroulementTour() #lance les actions choisies et celle(s) de ou des ennemi(s)
		yield(self, "derouleTourFini")
	
	litDialogue($DialogueInterface.dialogueEnd())
	yield($DialogueInterface, "dialogueFini")
	

func pvEnnemi(): #pour tester
	nar.set_text(str(combattantEnnemi2.pv))
