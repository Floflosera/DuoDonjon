extends "res://Scenes/Ennemi.gd"

onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aFlaux = get_node("../../GeneralInterface/HBoxContainer/Flaux")

func _ready():
	#Statistiques de l'ennemi
	pvmax = 500
	pv = 500
	defense = 2
	vitesse = 3

func _on_Selection_pressed():
	emit_signal("butPressed")

func choixSkill():
	choixSkill = 0
	cibler(aHarry)
	tourEffectue = false

func castSkill1():
	cible.degatsPris(10)
	yield(cible,"degatsTermine")
	emit_signal("skillCast")
