extends "res://Scenes/Ennemi.gd"

#L'ennemi stocke les alliés du combats dans des variables
onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aFlaux = get_node("../../GeneralInterface/HBoxContainer/Flaux")

#ceux-ci sont rangés dans un tableau pour pouvoir y accéder de différentes façons
onready var allies = [aHarry,aFlaux]

#ceci sont les états temporaires spécifique à l'ennemi 2
onready var prepare = false
onready var assomme = 0

#pour les dialogues
onready var flagAssome = false

func _ready():
	#Statistiques de l'ennemi
	pvmax = 800
	pv = 800
	defense = 15
	vitesse = 3
	
	#charge le texte des compétences de l'ennemis stockés au ligne voulu
	ligne_skills(3)
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)
	charge_skills()
	ligne_skills(6)
	skillTextAppend(skills_text)

#cas particulier avec la compétence de charge qui a deux textes
func charge_skills():
	skillTextAppend(skills_keys[5].textSkill)
	skillTextAppend(skills_keys[5].textSkill2)

#le 2e texte de ce skill est stocké comme l'affichage de texte de compétence 2
func aTextSkill2():
	return textSkill[3]

#Surcharge pour prendre en compte les différents cas
func degatsPrisDef(degats):
	if(lacere && assomme > 0):
		degatsPris(int((degats-defense)*2.5))
		return str(int((degats-defense)*2.5))
	elif(assomme > 0):
		degatsPris(int((degats-defense)*2))
		return str(int((degats-defense)*2))
	elif(lacere):
		degatsPris(int((degats-defense)*1.5))
		return str(int((degats-defense)*1.5))
	else:
		degatsPris(degats-defense)
		return str(degats-defense)

#fonction qui permet de choisir la compétence lancer par l'ennemi
func choixSkill():
	#L'ennemi assommé de fait rien
	#Pendant les 3 premiers tour il fait sa première compétence
	#Au 4e tour il prépare sa grosse attaque
	#s'il a préparé sa grosse attaque au tour précédent, alors il la lancera et finit sa préparation
	#sinon il choisi une compétence aléatoire entre sa première compétence et sa préparation
	if(assomme > 0):
		choixSkill = 4
	elif(combat.nTour <= 2):
		choixSkill = 0
	elif(combat.nTour == 3):
		choixSkill = 1
	elif(prepare == true):
		choixSkill = 2
		prepare = false
	else:
		choixSkill = randi()%2
	
	tourEffectue = false

#les différentes compétences qui cible aléatoirement ou non en fonction de la situtation
func castSkill1():
	
	if(aHarry.pv > 0 && aFlaux.pv > 0):
		if(aFlaux.hide):
			cibler(aHarry)
		elif(combat.nTour <= 2):
			cibler(allies[randi()%2])
		elif(randi()%2 == 0):
			cibler(allies[randi()%2])
		else:
			if(aHarry.pv < aFlaux.pv):
				cibler(aHarry)
			else:
				cibler(aFlaux)
	elif(aHarry.pv > 0):
		cibler(aHarry)
	else:
		cibler(aFlaux)
	
	if(cible == aFlaux && aFlaux.hide):
		yield(spriteAnim,"animation_finished")
	else:
		cible.degatsPrisDef(80 + randi()%9)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

func castSkill2():
	
	prepare = true
	
	yield(self,"animation_finished")
	
	emit_signal("skillCast")

func castSkill3():
	
	if(aHarry.pv > 0 && aFlaux.pv > 0):
		if(aHarry.guard && aFlaux.hide):
			cibler(aHarry)
		elif(aFlaux.hide):
			cibler(aHarry)
		else:
			if(randi()%4 < 3):
				if(aHarry.pv > aFlaux.pv):
					cibler(aHarry)
				else:
					cibler(aFlaux)
			else:
				cibler(allies[randi()%2])
	elif(aHarry.pv > 0):
		cibler(aHarry)
	else:
		cibler(aFlaux)
	
	if(cible == aHarry && aHarry.guard):
		assomme = 2
		secondText = true
		cible.degatsPrisDef(150 + randi()%16)
		
		if(not(flagAssome)):																#DIALOGUE
			#combat.litDialogue(dialogueI.dialogueStun())
			#yield(dialogueI, "dialogueFini")
			flagAssome = true
		
		yield(cible,"degatsTermine")
	elif(cible == aFlaux && aFlaux.hide):
		yield(spriteAnim,"animation_finished")
	else:
		cible.degatsPrisDef(150 + randi()%16)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#la compétence 5 est la compétence qui ne fait rien lorsque l'ennemi est assommé
func castSkill5():
	
	yield(self,"animation_finished")
	
	emit_signal("skillCast")

#Surcharge, met à jour les états
func clearThings():
	lacere = false
	if(assomme > 0):
		assomme -= 1
