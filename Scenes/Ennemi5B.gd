extends "res://Scenes/Ennemi.gd"

onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aFlaux = get_node("../../GeneralInterface/HBoxContainer/Flaux")

onready var allies = [aHarry,aFlaux]

onready var aLucy = get_node("../Ennemi5")

onready var flagDeSurete = false

func _ready():

	pvmax = 999
	pv = 999
	defense = 999
	vitesse = 0

func degatsPrisDef(_degats):
	if(combat.combattants[combat.iActuel] == aFlaux):
		degatsPris(333)
		return str(333)
	else:
		degatsPris(1)
		return str(1)

#surcharge pour envoyer des infos à Lucy
func degatsPris(degats):
	
	flagDeSurete = true
	
	if(combat.combattants[combat.iActuel] == aFlaux && aFlaux.choixSkill == 2):
		pass #Lucy gère
	else:
		if(aLucy.armeF.pv > 0):
			aLucy.spriteAnim.play("ArmesBlesseeBouclier")
		else:
			aLucy.spriteAnim.play("BouclierBlesseeBouclier")
	if(degats <= 1):
		degats = 1
	if(pv - degats <= 0):			#La condition fait en sorte de ne pas avoir des pv négatifs
		pv = 0						#Si les pv sont inférieurs aux dégâts réçus, alors on tombe à 0pv
		tourEffectue = true			#Si un allié n'a plus de pv, alors son tour sera compté comme déjà passé
	else:
		pv -= degats				#Sinon les dégâts sont soustraits aux pv du personnage
	barreVie.value = pv
	yield(aLucy.spriteAnim,"animation_finished")	#Attend la fin de l'animation de blessure
	aLucy.changerSprite()							#Change le sprite des 2 persos
	
	#informations de base pour l'animation du richText qui montre les dégâts
	#à concaténer avec le nombre des dégâts quand on inflige les dégâts avec un personnage
	showDegats.set_bbcode("[center][wave freq=25]")
	
	if(pv == 0 && aLucy.armeF.pv == 0):
		aLucy.guard = false
		aLucy.bouclier = false
		aLucy.tourEffectue = true
	elif(pv == 0):
		aLucy.guard = false
		aLucy.bouclier = false
		aLucy.choixSkill = randi() % 2
		combat.litDialogue(dialogueI.dialogueOneWeapon())
		yield(dialogueI, "dialogueFini")
		aLucy.changerSprite()
		combat.nar.set_text("")
	
	flagDeSurete = false
	
	emit_signal("degatsTermine")
