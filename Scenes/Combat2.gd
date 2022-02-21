extends Node

#Signal qui permet de savoir lorsque le déroulement d'un tour se termine de "deroulementTour()"
signal derouleTourFini
#Signal annonçant la fin de la fonction "actionCombattant(combattant)"
signal actionFinie

#On stocke chaque combattant dans des variables pour accéder plus facilement à leur informations et méthode
onready var combattantHarry = $GeneralInterface/HBoxContainer/Harry
onready var combattantFlaux = $GeneralInterface/HBoxContainer/Flaux
#$Ennemi2 est facile a utilisé donc pas besoin de le stocker

#On stocke chaque combattant dans un tableau pour pouvoir gérer leur tour
onready var combattants = [combattantHarry, combattantFlaux]#, $Ennemi2] #Ennemi2 pas encore codé, laissé de côté

#Variable utilisé pour faire des permutations
var temp

func _ready():
	ordreTour() #définie l'ordre des tours au début du combat
	
	#litDialogue($DialogueInterface.dialogueTest()) #Lancement du dialogue Test
	#yield($DialogueInterface, "dialogueFini")
	
	#Exemple de boucle d'un combat
	while((combattantHarry.pv > 0 || combattantFlaux.pv > 0) && $Ennemi2.pv > 0):
		$GeneralInterface.choixTour() #lance le choix du tour
		yield($GeneralInterface, "choixTourFini")
	
		deroulementTour() #lance les actions choisies et celle(s) de ou des ennemi(s)
		yield(self, "derouleTourFini")

#Définie l'ordre des tours avec un tri tournoi (le tableau est assez petit pour que ça soit court)
func ordreTour():
	for i in range(combattants.size()-1):						#On parcourt le tableau combattants
		for j in range(i+1, combattants.size()):				#avec i et j
			if(combattants[i].vitesse < combattants[j].vitesse):#Lorsque la vitesse d'un combattant à gauche
				temp = combattants[i]							#est inférieur à celle d'un autre à droite
				combattants[i] = combattants[i+1]				#alors on modifie l'ordre des combattants
				combattants[i+1] = temp							#dans le tableau

#Permet de vérifier si un combattant utilise une attaque prioritaire et auquel cas la lance
func actionCombattant(combattant):
	combattant.castSkill()				#Si oui, la compétence choisie est lancé
	yield(combattant, "skillCasted")
	$TimerActions.start()
	yield($TimerActions, "timeout")
	emit_signal("actionFinie")

#Déroulement des actions d'un tour en fonction des priorités et vitesses
func deroulementTour():
	$TimerActions.start()					#Les timers permettent de voir les actions de manière plus clair
	yield($TimerActions, "timeout")
	for i in range(combattants.size()):
		if(combattants[i].priorite && combattants[i].tourEffectue == false):
			actionCombattant(combattants[i])
			yield(self,"actionFinie")
	
	for i in range(combattants.size()):				#On parcourt le tableau des combattants
		if(combattants[i].tourEffectue == false):	#Si le tour du combattant n'a pas encore eu lieu (via attaque prio)
			actionCombattant(combattants[i])
			yield(self,"actionFinie")
	
	emit_signal("derouleTourFini")					#Informe de la fin du déroulement des actions

#Lit le dialogue entrée en paramètre (qui est une méthode de la scène DialogueInterface)
func litDialogue(dialog):
	$DialogueInterface.visible = true
	dialog #dialog est la méthode du dialogue choisi en entrée
	yield($DialogueInterface, "dialogueFini")
	$DialogueInterface.visible = false
