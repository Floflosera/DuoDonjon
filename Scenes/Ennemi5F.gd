extends "res://Scenes/Ennemi.gd"

onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aFlaux = get_node("../../GeneralInterface/HBoxContainer/Flaux")

onready var allies = [aHarry,aFlaux]

onready var aLucy = get_node("../Ennemi5")

func _ready():

	pvmax = 140
	pv = 140
	barreVie.max_value = pvmax
	barreVie.value = pv
	defense = 0
	vitesse = 0

func degatsPrisDef(degats):
	if(combat.prio && combat.combattantsBase[combat.iActuel] == aHarry):
		degatsPris(degats-defense)
		return str(degats-defense)
	if(combat.combattants[combat.iActuel] == aHarry):
		degatsPris(degats-defense)
		return str(degats-defense)
	else:
		degatsPris(1)
		return str(1)

#surcharge pour envoyer des infos à Lucy
func degatsPris(degats):
	if(combat.combattants[combat.iActuel] == aFlaux && aFlaux.choixSkill == 2):
		pass #Lucy gère
	else:
		if(aLucy.armeB.pv > 0):
			aLucy.spriteAnim.play("ArmesBlesseeFaux")
		else:
			aLucy.spriteAnim.play("FauxBlesseeFaux")
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
	
	if(pv == 0 && aLucy.armeB.pv == 0):
		aLucy.tourEffectue = true
		aLucy.affutage = false
	elif(pv == 0):
		aLucy.affutage = false
		if(choixSkill != 3):
			aLucy.choixSkill = 2
		combat.litDialogue(dialogueI.dialogueOneWeapon())
		yield(dialogueI, "dialogueFini")
		aLucy.changerSprite()
		combat.nar.set_text("")
	
	if(aLucy.armeB.flagDeSurete):
		yield(aLucy.armeB,"degatsTermine")
	
	emit_signal("degatsTermine")
