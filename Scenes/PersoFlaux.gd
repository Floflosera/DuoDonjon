extends "res://Scenes/Perso.gd"

func _ready():
	allie = get_node("../Harry")
	pvmax = 177
	pv = 177
	defense = 1
	vitesse = 4

#Surcharge pour les compétences prioritaires
func _on_Skill1_pressed():
	choixSkill = 0
	abled()
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill1.disabled = true
	priorite = true
	emit_signal("butPressed")

#Surcharge des castSkill
func castSkill1():
	allie.degatsPris(10)
	priorite = false
	yield(allie,"degatsTermine")
	emit_signal("skillCast")

func castSkill2():
	allie.degatsPris(20)
	yield(allie,"degatsTermine")
	emit_signal("skillCast")

func castSkill3():
	allie.degatsPris(30)
	yield(allie,"degatsTermine")
	emit_signal("skillCast")

func castSkill4():
	allie.degatsPris(40)
	yield(allie,"degatsTermine")
	emit_signal("skillCast")

func castSkill5():
	allie.degatsPris(50)
	yield(allie,"degatsTermine")
	emit_signal("skillCast")
