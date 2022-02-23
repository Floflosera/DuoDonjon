extends "res://Scenes/Perso.gd"

func _ready():
	allie = get_node("../Flaux")
	pvmax = 230
	pv = 230
	defense = 2
	vitesse = 2

#Surcharge pour les compétences prioritaires et qui ciblent
func _on_Skill1_pressed():
	choixSkill = 0
	abled()
	#on bloque une action pendant un tour lorsqu'elle est utilisée
	skill1.disabled = true
	ciblage = true
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
	priorite = true
	emit_signal("butPressed")

func _on_Skill5_pressed():
	choixSkill = 4
	abled()
	skill5.disabled = true
	priorite = true
	emit_signal("butPressed")

#Surcharge des castSkill
func castSkill1():
	cible.degatsPris(10)
	ciblage = false
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill2():
	cible.degatsPris(20)
	ciblage = false
	yield(cible,"degatsTermine")
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
	allie.degatsPris(40 + randi()%10)
	priorite = false
	yield(allie,"degatsTermine")
	emit_signal("skillCast")
