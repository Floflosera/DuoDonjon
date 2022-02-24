extends "res://Scenes/Perso.gd"

onready var bouclier = false
onready var guard = false
onready var launch = false

func _ready():
	allie = get_node("../Flaux")
	pvmax = 230
	pv = 230
	defense = 20
	vitesse = 2

#Surcharge pour les différents états d'Harry
func degatsPrisDef(degats):
	if(bouclier):
		degatsPris(int((degats-defense)*0.7))
	elif(guard):
		degatsPris(int((degats-defense)*0.4))
	else:
		degatsPris(degats-defense)

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
	bouclier = true
	
	cible.degatsPrisDef(40+randi()%5)
	ciblage = false
	
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill2():
	cible.degatsPrisDef(60+randi()%7)
	ciblage = false
	
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill3():
	soinPV(50)
	allie.soinPV(50)
	
	yield(spriteAnim,"animation_finished")
	emit_signal("skillCast")

func castSkill4():
	
	guard = true
	priorite = false
	
	yield(spriteAnim,"animation_finished")
	emit_signal("skillCast")

func castSkill5():
	
	launch = true
	priorite = false
	
	yield(spriteAnim,"animation_finished")
	emit_signal("skillCast")

func clearThings():
	bouclier = false
	guard = false
	launch = false
