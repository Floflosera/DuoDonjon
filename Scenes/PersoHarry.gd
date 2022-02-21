extends "res://Scenes/Perso.gd"

func _ready():
	allie = get_node("../Flaux")
	pvmax = 230
	pv = 230
	defense = 2
	vitesse = 2

#Surcharge pour les compétences prioritaires
func _on_Skill4_pressed():
	choixSkill = 3
	abled()
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill4.disabled = true
	priorite = true
	emit_signal("butPressed")

func _on_Skill5_pressed():
	choixSkill = 4
	abled()
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill5.disabled = true
	priorite = true
	emit_signal("butPressed")

#Surcharge des castSkill
func castSkill1():
	allie.degatsPris(10)
	yield(allie,"degatsTermine")
	emit_signal("skillCast")

func castSkill2():
	allie.degatsPris(20)
	yield(allie,"degatsTermine")
	emit_signal("skillCast")

func castSkill3():
	soinPV(50)
	allie.soinPV(50)
	yield(spriteAnim,"animation_finished")
	#faire une petite animation de soin et attendre la fin
	emit_signal("skillCast")

func castSkill4():
	allie.degatsPris(40)
	priorite = false
	yield(allie,"degatsTermine")
	emit_signal("skillCast")

func castSkill5():
	allie.degatsPris(50)
	priorite = false
	yield(allie,"degatsTermine")
	emit_signal("skillCast")
