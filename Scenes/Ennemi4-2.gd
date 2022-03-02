extends "res://Scenes/Ennemi4.gd"

var prisonnie

onready var attaqueUp = false
onready var defenseUp = false

func _ready():
	#Statistiques de l'ennemi
	pvmax = 900
	pv = 900
	defense = 5
	vitesse = 1
	
	pote = get_node("../Ennemi4-1")
	
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

#cas particulier de feu follet qui a plusieurs textes
func feuFollet_skills():
	skillTextAppend(skills_keys[18].textSkill2)
	skillTextAppend(skills_keys[18].textSkill3)

func aTextSkill():
	if(choixSkill == 2):
		return textSkill[2] + cible.nom + textSkill[5]
	elif(choixSkill == 3):
		return textSkill[choixSkill] + cible.nom
	elif(choixSkill == 4):
		return textSkill[choixSkill] + prisonnie.nom
	else:
		return textSkill[choixSkill]

#le 2e texte de ce skill est stocké comme l'affichage de texte de compétence 2
func aTextSkill2():
	return cible.nom + textSkill[6]

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

func choixSkill():
	pass

func castSkill1():
	pass

func castSkill2():
	pass

func castSkill3():
	pass

func castSkill4():
	pass

func castSkill5():
	pass

#Surcharge, met à jour les états
func clearThings():
	lacere = false
	attaqueUp = false
	defenseUp = false
