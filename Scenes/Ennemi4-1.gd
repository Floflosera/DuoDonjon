extends "res://Scenes/Ennemi4.gd"

func _ready():
	#Statistiques de l'ennemi
	pvmax = 500
	pv = 500
	defense = 20
	vitesse = 3
	
	pote = get_node("../Ennemi4-2")
	
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

