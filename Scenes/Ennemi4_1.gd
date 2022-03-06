extends "res://Scenes/Ennemi4.gd"

func _ready():
	#Statistiques de l'ennemi
	pvmax = 500
	pv = 500
	defense = 20
	vitesse = 3
	
	pote = get_node("../Ennemi4_2")
	
	#charge le texte des compétences de l'ennemis stockés au ligne voulu
	ligne_skills(12)
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)

func choixSkill():
	if(pote.pv <= (pote.pvmax - 100)):
		choixSkill = 1
	elif(pv <= 100):
		choixSkill = 0
	elif(pv <= (pvmax - 200)):
		if(randi()%4 == 0):
			choixSkill = 0
	elif(pote.pv == pote.pvmax):
		if(randi()%4 <= 2):
			choixSkill = 2
		else:
			choixSkill = 3
	elif(randi()%3 <= 1):
		choixSkill = 3
	else:
		choixSkill = 2
	
	if(choixSkill == 2 || choixSkill == 3):
		priorite = true
	
	tourEffectue = false

#pas de secondText = false parce qu'il n'a jamais de second texte donc sa variable reste en false
func castSkill1():
	
	soinPV(100)
	
	yield(spriteAnim,"animation_finished")
	
	emit_signal("skillCast")

func castSkill2():
	
	pote.soinPV(100)
	
	yield(pote.spriteAnim,"animation_finished")
	
	emit_signal("skillCast")

func castSkill3():
	
	priorite = false
	
	pote.attaqueUp = true
	
	yield(pote.spriteAnim,"animation_finished")
	
	emit_signal("skillCast")

func castSkill4():
	
	priorite = false
	
	pote.defenseUp = true
	
	yield(pote.spriteAnim,"animation_finished")
	
	emit_signal("skillCast")
