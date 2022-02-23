extends "res://Scenes/Perso.gd"

func _ready():
	allie = get_node("../Harry")
	pvmax = 177
	pv = 177
	defense = 1
	vitesse = 4

#Surcharge pour les compétences prioritaires et qui ciblent
func _on_Skill1_pressed():
	choixSkill = 0
	abled()
	skill1.disabled = true
	priorite = true
	emit_signal("butPressed")

func _on_Skill2_pressed():
	choixSkill = 1
	abled()
	skill2.disabled = true
	ciblage = true
	emit_signal("butPressed")

func _on_Skill4_pressed():
	choixSkill = 3
	abled()
	skill4.disabled = true
	ciblage = true
	emit_signal("butPressed")

#Surcharge des castSkill
func castSkill1():
	allie.degatsPris(10)
	priorite = false
	yield(allie,"degatsTermine")
	emit_signal("skillCast")

func castSkill2():
	cible.degatsPris(20)
	ciblage = false
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill3():
	allie.degatsPris(30)
	yield(allie,"degatsTermine")
	emit_signal("skillCast")

func castSkill4():
	cible.degatsPris(40)
	ciblage = false
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill5():
	allie.degatsPris(50)
	yield(allie,"degatsTermine")
	emit_signal("skillCast")
