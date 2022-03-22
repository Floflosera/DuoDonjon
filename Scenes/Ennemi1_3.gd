extends "Ennemi.gd"

onready var aRobotGardien = get_node("../Ennemi1_1")

func _ready():
	#Statistiques de l'ennemi
	pvmax = 70
	pv = 70
	defense = 0
	vitesse = 0

#Surcharge pour envoyer des infos au boss
func degatsPris(degats):
	spriteAnim.play("Blesse")		#Lance l'animation des dégâts pris
	if(degats <= 1):
		degats = 1
	if(pv - degats <= 0):			#La condition fait en sorte de ne pas avoir des pv négatifs
		pv = 0						#Si les pv sont inférieurs aux dégâts réçus, alors on tombe à 0pv
		tourEffectue = true			#Si un allié n'a plus de pv, alors son tour sera compté comme déjà passé
	else:
		pv -= degats				#Sinon les dégâts sont soustraits aux pv du personnage
	barreVie.value = pv
	yield(spriteAnim,"animation_finished")	#Attend la fin de l'animation de blessure
	changerSprite()							#Change le sprite des 2 persos
	
	#informations de base pour l'animation du richText qui montre les dégâts
	#à concaténer avec le nombre des dégâts quand on inflige les dégâts avec un personnage
	showDegats.set_bbcode("[center][wave freq=25]")
	
	if(pv == 0 && aRobotGardien.aBD.pv == 0):
		aRobotGardien.choixSkill = 2
		spriteAnim.hide()
	elif(pv == 0):
		aRobotGardien.choixSkill = 0
		spriteAnim.hide()
	
	emit_signal("degatsTermine")
