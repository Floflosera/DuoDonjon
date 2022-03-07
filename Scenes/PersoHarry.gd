extends "res://Scenes/Perso.gd"

#booléen des effets exclusif à Harry
onready var bouclier = false
onready var guard = false
onready var launch = false

#quand il apparaît, il prend en allié Flaux et récupère ses statistiques (qui ne changent pas)
func _ready():
	allie = get_node("../Flaux")
	pvmax = 230
	pv = 230
	defense = 20
	vitesse = 2
	nom = "Harry"

#Surcharge pour les différents états d'Harry lorsqu'il prend des dégâts
func degatsPrisDef(degats):
	if(emotion == 3):
		degats += 20
	elif(emotion == 2):
		degats -= 20
	elif(emotion == 1):
		degats -= 10
	
	if(bouclier):
		degatsPris(int((degats-defense)*0.7))
	elif(guard):
		degatsPris(int((degats-defense)*0.4))
	else:
		degatsPris(degats-defense)

#Surcharge pour les compétences prioritaires et qui ciblent
func _on_Skill1_pressed():
	choixSkill = 0
	
	priorite = false
	ciblage = true
	emit_signal("butPressed")

func _on_Skill2_pressed():
	choixSkill = 1
	
	priorite = false
	ciblage = true
	emit_signal("butPressed")

func _on_Skill4_pressed():
	choixSkill = 3
	
	priorite = true
	ciblage = false
	emit_signal("butPressed")

func _on_Skill5_pressed():
	choixSkill = 4
	
	priorite = true
	ciblage = false
	emit_signal("butPressed")

#fonction qui permet à Harry d'infliger des dégâts et de montrer les dégâts qu'il fait
func harryDegats(degats):
	
	if(emotion == 3):
		degats += 20
	elif(emotion == 2):
		degats -= 20
	elif(emotion == 1):
		degats += 10

	deg = cible.degatsPrisDef(degats) #il n'augmente pas sa puissance autrement
	
	#on attend un petit instant (un changement de frame) pour afficher les dégâts quand l'ennemi clignote
	yield(cible.spriteAnim,"frame_changed")
	#on change la couleur du texte de l'affichage des dégâts (parce que c'est cool)
	cible.showDegats.add_color_override("default_color", Color(23.0/255.0,0,110.0/255.0,1))
	#on concatène les dégâts effectués avec le richText actuel (pour garder les effets de textes)
	cible.showDegats.set_bbcode(cible.showDegats.get_bbcode() + deg)

#Surcharge des castSkill avec l'effet des compétences
func castSkill1():
	
	if(cible.pv == 0):
		for ci in ennemis:
			if(ci.pv > 0):
				cibler(ci)
	
	bouclier = true
	
	harryDegats(40+randi()%5)
	ciblage = false
	
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill2():
	
	if(cible.pv == 0):
		for ci in ennemis:
			if(ci.pv > 0):
				cibler(ci)
	
	harryDegats(60+randi()%7)
	ciblage = false
	
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill3():
	
	soinPV(100)
	if(allie.pv > 0 && not(allie.horsCombat)):
		allie.soinPV(100)
	
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

#met à jour les effets temporaires
func clearThings():
	bouclier = false
	guard = false
	launch = false
