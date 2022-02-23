extends Node

#Signal qui permet de savoir lorsque le déroulement d'un tour se termine de "deroulementTour()"
signal derouleTourFini
#Signal annonçant la fin de la fonction "actionCombattant(combattant)"
signal actionFinie

#Les variables de langues devront être mises sur le script principal et transférer dans les scènes suivantes
#qui en ont besoin, pour l'instant la transmission n'est pas instantanné donc ça n'est pas directement possible
onready var fr = true
onready var en = false

#On stocke chaque combattant dans un tableau pour pouvoir gérer leur tour
onready var combattants

#Variable utilisé pour faire des permutations
var temp

#Définie l'ordre des tours avec un tri tournoi (le tableau est assez petit pour que ça soit court)
func ordreTour():
	for i in range(combattants.size()-1):						#On parcourt le tableau combattants
		for j in range(i+1, combattants.size()):				#avec i et j
			if(combattants[i].vitesse < combattants[j].vitesse):#Lorsque la vitesse d'un combattant à gauche
				temp = combattants[i]							#est inférieur à celle d'un autre à droite
				combattants[i] = combattants[i+1]				#alors on modifie l'ordre des combattants
				combattants[i+1] = temp							#dans le tableau

#Lance l'action choisie du combattant
func actionCombattant(combattant):
	combattant.castSkill()
	yield(combattant, "skillFinished")
	$TimerActions.start()
	yield($TimerActions, "timeout")
	emit_signal("actionFinie")

#Déroulement des actions d'un tour en fonction des priorités et vitesses
func deroulementTour():
	for i in range(combattants.size()):
		if(combattants[i].ennemi):
			combattants[i].choixSkill()
	
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
	
	get_tree().call_group("EnnemiGroupe", "clearCible")
	
	emit_signal("derouleTourFini")					#Informe de la fin du déroulement des actions

#Lit le dialogue entrée en paramètre (qui est une méthode de la scène DialogueInterface)
func litDialogue(dialog):
	$DialogueInterface.visible = true
	dialog #dialog est la méthode du dialogue choisi en entrée
	yield($DialogueInterface, "dialogueFini")
	$DialogueInterface.visible = false
