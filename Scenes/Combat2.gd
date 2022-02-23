extends "res://Scenes/Combat.gd"

#On stocke chaque combattant dans des variables pour accéder plus facilement à leur informations et méthode
onready var combattantHarry = $GeneralInterface/HBoxContainer/Harry
onready var combattantFlaux = $GeneralInterface/HBoxContainer/Flaux

onready var combattantEnnemi2 = $EnnemiGroup/Ennemi2

func _ready():
	randomize() #à mettre dans le main
	
	combattants = [combattantHarry, combattantFlaux, combattantEnnemi2]
	
	ordreTour() #définie l'ordre des tours au début du combat
	
	pvEnnemi()						#Temporaire
	
	#litDialogue($DialogueInterface.dialogueTest()) #Lancement du dialogue Test
	#yield($DialogueInterface, "dialogueFini")
	
	#Exemple de boucle d'un combat
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && combattantEnnemi2.pv > 0):
		pvEnnemi()						#Temporaire
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
	
		deroulementTour() #lance les actions choisies et celle(s) de ou des ennemi(s)
		yield(self, "derouleTourFini")

func pvEnnemi():
	nar.set_text(str(combattantEnnemi2.pv))
