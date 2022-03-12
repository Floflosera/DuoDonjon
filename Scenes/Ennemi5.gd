extends "res://Scenes/Ennemi.gd"

onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aFlaux = get_node("../../GeneralInterface/HBoxContainer/Flaux")

onready var allies = [aHarry,aFlaux]

onready var armeB = get_node("../Ennemi5B")
onready var armeF = get_node("../Ennemi5F")
onready var armes = [armeB,armeF]

func _ready():

	pvmax = 1000
	pv = 1000
	defense = 25
	vitesse = 3
	
	for i in range(21,29):
		ligne_skills(i)
		skillTextAppend(skills_text)
	text2_skills()
	

func text2_skills():
	skillTextAppend(skills_keys[21].textSkill2)
	skillTextAppend(skills_keys[23].textSkill2)
	skillTextAppend(skills_keys[28].textSkill2)
	skillTextAppend(skills_keys[29].textSkill2)

func aTextSkill2():
	if(choixSkill == 0):
		return textSkill[9]
	elif(choixSkill == 2):
		return textSkill[10]
	elif(choixSkill == 7):
		return textSkill[11]
	elif(choixSkill == 8):
		return textSkill[12]

func changerSprite():
	spriteAnim.play("Neutre")

func degatsPrisDef(degats):
	if(lacere):
		degatsPris(int((degats-defense)*1.5))
		return str(int((degats-defense)*1.5))
	else:
		degatsPris(degats-defense)
		return str(degats-defense)

func choixSkill():
	pass

func castSkill1():
	pass

func castSkill2():
	pass

func castSkill3():
	pass

func castSkill4():
	pass

func castSkill5():
	pass

func castSkill6():
	pass

func castSkill7():
	pass

func castSkill8():
	pass

func castSkill9():
	pass

#surcharge car plus de skills
func castSkill():
	
	match choixSkill:
		0:
			castSkill1()
			yield(self,"skillCast")
		1:
			castSkill2()
			yield(self,"skillCast")
		2:
			castSkill3()
			yield(self,"skillCast")
		3:
			castSkill4()
			yield(self,"skillCast")
		4:
			castSkill5()
			yield(self,"skillCast")
		5:
			castSkill6()
			yield(self,"skillCast")
		6:
			castSkill7()
			yield(self,"skillCast")
		7:
			castSkill8()
			yield(self,"skillCast")
		8:
			castSkill9()
			yield(self,"skillCast")
		
	tourEffectue = true
	emit_signal("skillFinished")

func clearThings():
	lacere = false
