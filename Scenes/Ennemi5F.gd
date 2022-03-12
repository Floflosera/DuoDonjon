extends "res://Scenes/Ennemi.gd"

onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aFlaux = get_node("../../GeneralInterface/HBoxContainer/Flaux")

onready var allies = [aHarry,aFlaux]

onready var compteurSept = 0

func _ready():

	pvmax = 777
	pv = 777
	defense = 0
	vitesse = 0

func degatsPrisDef(degats):
	if(aFlaux.choixSkill == 1 && aFlaux.cible == self):
		match compteurSept:
			0:
				degatsPris(7)
				compteurSept += 1
				return str(7)
			1:
				degatsPris(77)
				compteurSept += 1
				return str(77)
			2:
				degatsPris(777)
				return str(777)
	else:
		degatsPris(1)
		return str(1)
	
