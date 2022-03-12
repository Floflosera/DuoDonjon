extends "res://Scenes/Ennemi.gd"

onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aFlaux = get_node("../../GeneralInterface/HBoxContainer/Flaux")

onready var allies = [aHarry,aFlaux]

func _ready():

	pvmax = 999
	pv = 999
	defense = 999
	vitesse = 0

func degatsPrisDef(degats):
	if(aHarry.choixSkill == 1 && aHarry.cible == self):
		degatsPris(333)
		return str(333)
	else:
		degatsPris(1)
		return str(1)

