extends "Ennemi.gd"

#L'ennemi stocke les alliés du combats dans des variables
onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aBD = get_node("../Ennemi1_2")
onready var aBG = get_node("../Ennemi1_3")

onready var blinde = 0

func _ready():
	#Statistiques de l'ennemi
	pvmax = 200
	pv = 200
	defense = 30
	vitesse = 1
	
	#Ne cible que Harry, car il est le seul à participer au combat
	cibler(aHarry)
	
	#charge le texte des compétences de l'ennemis stockés au ligne voulu
	ligne_skills(0)
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)
	commot_skills()
	
	#cas particulier avec la compétence de charge qui a deux textes
func commot_skills():
	skillTextAppend(skills_keys[1].textSkill2)

#le 2e texte de ce skill est stocké comme l'affichage de texte de compétence 2
func aTextSkill2():
	return textSkill[3]
	
func degatsPrisDef(degats):
	if(blinde > 0):
		degatsPris(int((degats-defense)*0.6))
		return str(int((degats-defense)*0.6))
	else:
		degatsPris(degats-defense)
		return str(degats-defense)

func choixSkill():
	if(aBD.pv > 0 && aBG.pv > 0):
		if(combat.nTour == 1):
			choixSkill = 1
		else:
			choixSkill = randi() % 2
	elif(aBD.pv > 0 || aBG.pv > 0):
		choixSkill = 0
	else:
		choixSkill = 2
	
	tourEffectue = false

#Coup de boulet
func castSkill1():
	cible.degatsPrisDef(60 + randi()%7)
	yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Commotion
func castSkill2():
	cible.degatsPrisDef(70 + randi()%8)
	yield(cible,"degatsTermine")
	blinde = 2
	secondText = true
	
	emit_signal("skillCast")

#Coup de boule
func castSkill3():
	cible.degatsPrisDef(40 + randi()%5)
	yield(cible,"degatsTermine")
	
	emit_signal("skillCast")
	
#Surcharge, met à jour les états
func clearThings():
	if(blinde > 0):
		blinde -= 1
	if(aBD.pv == 0 && aBG.pv == 0):
		defense = 0
