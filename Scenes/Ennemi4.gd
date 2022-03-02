extends "res://Scenes/Ennemi.gd"

#L'ennemi stocke les alliés du combats dans des variables
onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aFlaux = get_node("../../GeneralInterface/HBoxContainer/Flaux")

#ceux-ci sont rangés dans un tableau pour pouvoir y accéder de différentes façons
onready var allies = [aHarry,aFlaux]

var pote

#surcharge pour le KO
func changerSprite():
	if(pv == 0):
		spriteAnim.play("KO")
	else:
		spriteAnim.play("Neutre")
