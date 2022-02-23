extends "res://Scenes/Ennemi.gd"

onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aFlaux = get_node("../../GeneralInterface/HBoxContainer/Flaux")

onready var assome = false

func _ready():
	#Statistiques de l'ennemi
	pvmax = 500
	pv = 500
	defense = 2
	vitesse = 3
	
	ligne_skills(3)
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)
	charge_skills()

func charge_skills():
	skillTextAppend(skills_keys[5].textSkill)
	skillTextAppend(skills_keys[5].textSkill2)

func aTextSkill2():
	return textSkill[3]

func _on_Selection_pressed():
	emit_signal("butPressed")

func choixSkill():
	choixSkill = 2#randi()%3
	
	match choixSkill:
		0:
			pass
		1:
			pass
		2:
			pass
	cibler(aHarry)
	
	tourEffectue = false

func castSkill1():
	secondText = false
	
	cible.degatsPris(10)
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill2():
	secondText = false
	
	cible.degatsPris(10)
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill3():
	if(aHarry.choixSkill == 3 && aFlaux.choixSkill == 0):
		secondText = true
	else:
		secondText = false
	
	cible.degatsPris(10)
	yield(cible,"degatsTermine")
	emit_signal("skillCast")
