extends "res://Scenes/Ennemi.gd"

#L'ennemi stocke les alliés du combats dans des variables
onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aFlaux = get_node("../../GeneralInterface/HBoxContainer/Flaux")

#ceux-ci sont rangés dans un tableau pour pouvoir y accéder de différentes façons
onready var allies = [aHarry,aFlaux]

onready var auSol = 0

func _ready():
	#Statistiques de l'ennemi
	pvmax = 700
	pv = 700
	defense = 30
	vitesse = 5
	
	#charge le texte des compétences de l'ennemis stockés au ligne voulu
	ligne_skills(7)
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)
	tirInc_skills()
	ligne_skills(10)
	skillTextAppend(skills_text)
	ligne_skills(11)
	skillTextAppend(skills_text)

#cas particulier avec la compétence de charge qui a deux textes
func tirInc_skills():
	skillTextAppend(skills_keys[9].textSkill)
	skillTextAppend(skills_keys[9].textSkill2)

func aTextSkill():
	if(choixSkill == 2):
		return textSkill[choixSkill] + cible.nom + " !"
	else:
		return textSkill[choixSkill]

#le 2e texte de ce skill est stocké comme l'affichage de texte de compétence 2
func aTextSkill2():
	if(auSol > 0):
		return textSkill[5]
	elif(choixSkill == 2):
		return cible.nom + textSkill[3]

#Surcharge pour prendre en compte les différents cas
func degatsPrisDef(degats):
	if(lacere && auSol > 0):
		degatsPris(int(degats*2.25))
		return str(int(degats*2.25))
	elif(auSol > 0):
		degatsPris(int(degats*2))
		return str(int(degats*2))
	elif(lacere):
		degatsPris(int((degats-defense)*1.25))
		return str(int((degats-defense)*1.25))
	else:
		degatsPris(degats-defense)
		return str(degats-defense)

func choixSkill():
	
	if(auSol > 0):
		choixSkill = 4
	elif(combat.nTour == 1):
		choixSkill = 0
	elif(combat.nTour == 2):
		choixSkill = 1
	elif(combat.nTour == 3):
		choixSkill = 2
	else:
		choixSkill = randi()%3
	
	#cas particulier pour afficher le nom de la bonne cible lors de Tir incapacitant
	if(choixSkill == 2):
		if(aHarry.pv > 0 && aFlaux.pv > 0):
			if(aFlaux.choixSkill == 0):	#comme Flaux n'a pas encore fait son action, on regarde son choix
				cibler(aHarry)
			elif(randi()%2 == 0):
				cibler(allies[randi()%2])
			else:
				if(aHarry.pv > aFlaux.pv):
					cibler(aHarry)
				else:
					cibler(aFlaux)
		elif(aHarry.pv > 0):
			cibler(aHarry)
		else:
			cibler(aFlaux)
	
	tourEffectue = false

#Tir magique (une cible)
func castSkill1():
	
	secondText = false
	
	if(aHarry.pv > 0 && aFlaux.pv > 0):
		if(aFlaux.hide):
			cibler(aHarry)
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
		cible.degatsPrisDef(cible.defense + 75 + randi()%8)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Barrage (touche tout le monde)
func castSkill2():
	
	secondText = false
	
	if(aHarry.pv>0):
		cibler(aHarry)
		cible.degatsPrisDef(60 + randi()%7)
	if(aFlaux.pv>0 && not(aFlaux.hide)):
		cibler(aFlaux)
		cible.degatsPrisDef(60 + randi()%7)
	if(aHarry.pv == 0 && aFlaux.hide):
		yield(spriteAnim,"animation_finished")
	else:
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Tir incapacitant (une cible)
func castSkill3():
	
	secondText = true
	
	#ciblage déjà effectué dans le choix du tour
	
	if(cible == aFlaux && aFlaux.hide):
		secondText = false
		yield(spriteAnim,"animation_finished")
	else:
		cible.tourEffectue = true
		cible.degatsPrisDef(70 + randi()%8)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Tir affaibli (toujours au hasard)
func castSkill5():
	
	secondText = false
	
	if(aHarry.pv > 0 && aFlaux.pv > 0):
		if(not(aFlaux.hide)):
			cibler(allies[randi()%2])
		else:
			cibler(aHarry)
	elif(aHarry.pv > 0):
		cibler(aHarry)
	else:
		cibler(aFlaux)
	
	if(cible == aFlaux && aFlaux.hide):
		yield(spriteAnim,"animation_finished")
	else:
		cible.degatsPrisDef(cible.defense + randi()%51)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

func seclateAuSol():
	auSol = 2

#Surcharge, met à jour les états
func clearThings():
	lacere = false
	if(auSol > 0):
		auSol -= 1
