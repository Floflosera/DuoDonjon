extends "res://Scenes/Ennemi4.gd"

var prisonnie
onready var priso2t = false
onready var dejaPriso = false

onready var attaqueUp = false
onready var defenseUp = false

func _ready():
	#Statistiques de l'ennemi
	pvmax = 900
	pv = 900
	defense = 5
	vitesse = 1
	
	pote = get_node("../Ennemi4_1")
	
	#charge le texte des compétences de l'ennemis stockés au ligne voulu
	ligne_skills(16)
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)
	
	feuFollet_skills() 	#suite du texte du skill 3
	relance_skills()	#suite du texte du skill 5

#cas particulier de feu follet qui a plusieurs textes
func feuFollet_skills():
	skillTextAppend(skills_keys[18].textSkill2)
	skillTextAppend(skills_keys[18].textSkill3)

#en fonction du prisonnier et de la cible
func relance_skills():
	skillTextAppend(skills_keys[20].textSkill2)
	skillTextAppend(skills_keys[20].textSkill3)
	skillTextAppend(skills_keys[20].textSkill4)
	skillTextAppend(skills_keys[20].textSkill5)

func aTextSkill():
	if(choixSkill == 2):
		return textSkill[2] + cible.nom + textSkill[5]
	elif(choixSkill == 3):
		return textSkill[choixSkill] + cible.nom + " !"
	elif(choixSkill == 4):
		return textSkill[choixSkill] + prisonnie.nom + " !"
	else:
		return textSkill[choixSkill]

#le 2e texte de ce skill est stocké comme l'affichage de texte de compétence 2
func aTextSkill2():
	if(choixSkill == 2):
		return cible.nom + textSkill[6]
	elif(choixSkill == 4):
		if(prisonnie == aHarry):
			if(aFlaux.pv > 0 && (not(aFlaux.hide))):
				return textSkill[7]
			else:
				return textSkill[9]
		else:
			if(aHarry.pv > 0):
				return textSkill[8]
			else:
				return textSkill[10]

#Surcharge pour prendre en compte les différents cas
func degatsPrisDef(degats):
	if(lacere && defenseUp):
		degatsPris(int(degats*0.75))
		return str(int(degats*0.75))
	elif(defenseUp):
		degatsPris(int(degats*0.5))
		return str(int(degats*0.5))
	elif(lacere):
		degatsPris(int((degats-defense)*1.25))
		return str(int((degats-defense)*1.25))
	else:
		degatsPris(degats-defense)
		return str(degats-defense)

#choix 3 et 4, ciblage à faire avant parce qu'il y en a besoin pour afficher les textes
func choixSkill():
	
	if(pote.pv > 0):
		if(pote.choixSkill == 3):
			if(randi() % 3 <= 1 || pote.pv <= pvmax/2):
				choixSkill = 2
			else:
				choixSkill = randi() % 3
		elif(pote.choixSkill == 2):
			if(randi()%2 == 0 || pote.pv <= pvmax/2):
				choixSkill = 1
			else:
				choixSkill = 0
		else:
			choixSkill = randi() % 3
	else:
		if(choixSkill == 4):
			prisonnie = null
		if(prisonnie == aHarry || prisonnie == aFlaux):
			if(priso2t == false):
				if(randi() % 2 == 0):
					choixSkill = 4
				else:
					choixSkill = 0
					priso2t = true
			else:
				choixSkill = 4
				priso2t = false
		elif(aHarry.pv > 0 && aFlaux.pv > 0):
			if(not(dejaPriso)):
				choixSkill = 3
				dejaPriso = true
			else:
				if(randi() % 3 == 0):
					choixSkill = 3
				elif(randi() % 3 <= 1):
					choixSkill = 1
				else:
					choixSkill = 0
		else:
			if(randi() % 2 == 0):
				choixSkill = 0
			else:
				choixSkill = 2
	
	
	if(choixSkill == 2): #Feu follet
		
		priorite = true
		
		if(aHarry.pv > 0 && aFlaux.pv > 0):
			if(aFlaux.choixSkill == 0):	#comme Flaux n'a pas encore fait son action, on regarde son choix
				cibler(aHarry)
			elif(randi()%3 <= 1):		#il a plus de chance de viser Flaux, à nerf pour la version plus facile
				cibler(aFlaux)
			else:
				cibler(aHarry)
		elif(aHarry.pv > 0):
			cibler(aHarry)
		else:
			cibler(aFlaux)
	
	if(choixSkill == 3): #Attrape
		
		priorite = true
		
		if(aFlaux.choixSkill == 0):	#comme Flaux n'a pas encore fait son action, on regarde son choix
			cibler(aHarry)
		elif(randi()%2 == 0):
			cibler(aFlaux)
		else:
			cibler(aHarry)
	
	tourEffectue = false

func mageNoirDegats(degats):
	if(attaqueUp):
		cible.degatsPrisDef(int(degats * 1.33))
	else:
		cible.degatsPrisDef(degats)

#Tonnerre, une cible
func castSkill1():
	
	secondText = false
	
	if(aHarry.pv > 0 && aFlaux.pv > 0):
		if(aFlaux.hide):
			cibler(aHarry)
		elif(randi()%3 <= 1):
			cibler(allies[randi()%2])
		else:
			if(aHarry.pv >= aFlaux.pv):
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
		mageNoirDegats(80 + randi()%8)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Grêle, vise tous les alliés
func castSkill2():
	
	secondText = false
	
	if(aHarry.pv>0):
		cibler(aHarry)
		mageNoirDegats(65 + randi()%7)
	if(aFlaux.pv>0 && not(aFlaux.hide)):
		cibler(aFlaux)
		mageNoirDegats(65 + randi()%7)
	if(aHarry.pv == 0 && aFlaux.hide):
		yield(spriteAnim,"animation_finished")
	else:
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Feu follet, provoque un allié, cible dans choix
func castSkill3():
	
	secondText = true
	priorite = false
	
	if(cible == aFlaux && aFlaux.hide):
		yield(spriteAnim,"animation_finished")
	else:
		cible.cible = self
		if(cible == aHarry && (cible.choixSkill >= 2)):
			cible.choixSkill = 1
		elif(cible == aFlaux && (cible.choixSkill == 0 && cible.choixSkill == 4)):
			cible.choixSkill = 1 #pourrait se faire en un if mais ça serait moins lisible
		mageNoirDegats(40 + randi()%5)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Attrape, prend un allié en tant que prisonnié, cible dans choix
func castSkill4():
	
	secondText = false
	priorite = false
	
	prisonnie = cible
	prisonnie.horsCombat = true
	prisonnie.tourEffectue = true
	prisonnie.changerSprite()
	#faire apparaître un sprite à côté de lui du prisonnier
	
	yield(spriteAnim,"animation_finished")
	
	emit_signal("skillCast")

#Relance, lance le prisonnié sur l'allié restant
func castSkill5():
	
	secondText = true
	
	if(prisonnie == aHarry):
		cibler(aFlaux)
	else:
		cibler(aHarry)
	
	prisonnie.horsCombat = false
	
	if((cible == aFlaux && aFlaux.hide) || cible.pv == 0):
		prisonnie.degatsPrisDef(40 + randi()%5)
		yield(prisonnie,"degatsTermine")
	else:
		if(cible == aFlaux):
			prisonnie.degatsPrisDef(30 + randi()%4)
			cible.degatsPris(cible.pv - 1)
		else:
			prisonnie.degatsPrisDef(20 + randi()%3)
			mageNoirDegats(20 + randi()%3)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Surcharge, met à jour les états
func clearThings():
	lacere = false
	attaqueUp = false
	defenseUp = false
