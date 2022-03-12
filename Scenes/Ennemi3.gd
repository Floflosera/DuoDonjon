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

#cas particulier avec la compétence de tir incapacitant
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
		degatsPris(int(degats*2.5))
		return str(int(degats*2.5))
	elif(auSol > 0):
		degatsPris(int(degats*2))
		return str(int(degats*2))
	elif(lacere):
		degatsPris(int((degats-defense)*1.5))
		return str(int((degats-defense)*1.5))
	elif(aHarry.choixSkill == 4 && aFlaux.choixSkill == 1):
		vaSeclateAuSol()
		degatsPris(degats-defense)
		return str(degats-defense)
	else:
		degatsPris(degats-defense)
		return str(degats-defense)

func vaSeclateAuSol():
		seclateAuSol()
		choixSkill = 4
		secondText = false
		get_node("../..").narraText(aTextSkill2())
		yield(get_node("../.."),"narraTextFini")

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
		cible.degatsPrisDef(cible.defense + 70 + randi()%8)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Barrage (touche tout le monde)
func castSkill2():
	
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
		cible.abled()
		cible.degatsPrisDef(70 + randi()%8)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Tir affaibli (toujours au hasard)
func castSkill5():
	
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
		cible.degatsPrisDef(cible.defense + randi()%31)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

func seclateAuSol():
	auSol = 2
	vitesse = 1

#Surcharge pour quand il est au sol
func changerSprite():
	if(auSol > 0):
		spriteAnim.play("AuSol")
	else:
		spriteAnim.play("Neutre")

#Surcharge pour quand il est au sol
func degatsPris(degats):
	if(auSol > 0):
		spriteAnim.play("AuSolBlesse")
	else:
		spriteAnim.play("Blesse")
	if(degats <= 1):
		degats = 1
	if(pv - degats <= 0):			#La condition fait en sorte de ne pas avoir des pv négatifs
		pv = 0						#Si les pv sont inférieurs aux dégâts réçus, alors on tombe à 0pv
		tourEffectue = true			#Si un allié n'a plus de pv, alors son tour sera compté comme déjà passé
	else:
		pv -= degats				#Sinon les dégâts sont soustraits aux pv du personnage
	barreVie.value = pv
	yield(spriteAnim,"animation_finished")	#Attend la fin de l'animation de blessure
	changerSprite()							#Change le sprite des 2 persos
	
	#informations de base pour l'animation du richText qui montre les dégâts
	#à concaténer avec le nombre des dégâts quand on inflige les dégâts avec un personnage
	showDegats.set_bbcode("[center][wave freq=25]")
	
	emit_signal("degatsTermine")

#Surcharge, met à jour les états
func clearThings():
	lacere = false
	if(auSol > 0):
		auSol -= 1
	if(auSol == 0):
		changerSprite()
		vitesse = 5
