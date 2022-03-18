extends "res://Scenes/Ennemi.gd"

onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aFlaux = get_node("../../GeneralInterface/HBoxContainer/Flaux")

onready var allies = [aHarry,aFlaux]

onready var armeB = get_node("../Ennemi5B")
onready var armeF = get_node("../Ennemi5F")
onready var armes = [armeB,armeF]

onready var choixSkillPre = -1

onready var phase1 = true

onready var affutage = false
onready var bouclier = false
onready var guard = false

onready var contre = false

onready var affaibli = false
onready var aTerre = false

#dialogue
onready var flagGetReal = false
onready var flagContre = false

func _ready():

	pvmax = 1000
	pv = 1000
	defense = 25
	vitesse = 3
	
	for i in range(21,30):
		ligne_skills(i)
		skillTextAppend(skills_text)
	text2_skills()
	ligne_skills(30)
	skillTextAppend(skills_text)
	skillTextAppend(skills_keys[30].textSkill2)
	

func text2_skills():
	skillTextAppend(skills_keys[21].textSkill2)
	skillTextAppend(skills_keys[23].textSkill2)
	skillTextAppend(skills_keys[28].textSkill2)
	skillTextAppend(skills_keys[29].textSkill2)

func aTextSkill():
	if(choixSkill == 9):
		return textSkill[13]
	else:
		return textSkill[choixSkill]

func aTextSkill2():
	if(choixSkill == 0):
		return textSkill[9]
	elif(choixSkill == 2):
		return textSkill[10]
	elif(choixSkill == 7):
		return textSkill[11]
	elif(choixSkill == 8):
		return textSkill[12]
	elif(affaibli):
		return textSkill[14]

func changerSprite():
	if(phase1):
		spriteAnim.play("Neutre")
	else:
		spriteAnim.play("Neutre")

#surcharge pour le contre
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
	
	if(contre):
		cibler(combat.combattants[combat.iActuel])
		combat.narraText(aTextSkill2())
		yield(combat,"narraTextFini")
		lucyDegats(1 + randi()%2)
		yield(cible,"degatsTermine")
	
	if(aHarry.launch && aFlaux.affutage && aFlaux.choixSkill == 1 && combat.combattants[combat.iActuel] == aFlaux):
		affaibli = true
		aTerre = true
		tourEffectue = true
		
		combat.narraText(aTextSkill2())
		yield(combat,"narraTextFini")
	
	emit_signal("degatsTermine")

func degatsPrisDef(degats):
	if(affaibli && lacere):
		degatsPris(int((degats-defense)*2.5))
		return str(int((degats-defense)*2.5))
	elif(affaibli):
		degatsPris(int((degats-defense)*2))
		return str(int((degats-defense)*2))
	elif(lacere && guard):
		degatsPris(int((degats-defense)*0.9))
		return str(int((degats-defense)*0.9))
	elif(lacere && bouclier):
		degatsPris(int((degats-defense)*1.2))
		return str(int((degats-defense)*1.2))
	elif(guard):
		degatsPris(int((degats-defense)*0.4))
		return str(int((degats-defense)*0.4))
	elif(bouclier):
		degatsPris(int((degats-defense)*0.7))
		return str(int((degats-defense)*0.7))
	elif(lacere):
		degatsPris(int((degats-defense)*1.5))
		return str(int((degats-defense)*1.5))
	else:
		degatsPris(degats-defense)
		return str(degats-defense)

func lucyDegats(degats):
	if(armeF.pv > 0 && affutage):
		cible.degatsPrisDef(int(degats * 1.5))
	else:
		cible.degatsPrisDef(degats)

func choixSkill():
	
	choixSkillPre = choixSkill
	
	while (choixSkillPre == choixSkill):
		
		if(phase1):
			if(armeB.pv > 0 && armeF.pv > 0):
				choixSkill = randi() % 4
			elif(armeB.pv > 0):
				choixSkill = randi() % 2
			else:
				choixSkill = (randi() % 2) + 2
			
		else:
			if(affaibli && aTerre):
				choixSkill = 9
			elif(affaibli):
				choixSkill = 5
			else:
				choixSkill = (randi() % 5) + 4
				if(choixSkill == 5):
					choixSkill = 4
					
			
	
	if(choixSkill == 3 || choixSkill == 5 || choixSkill == 7 || choixSkill == 8):
		priorite = true
	
	tourEffectue = false

#Lacération/Affutage (une cible, augmente sa puissance)
func castSkill1():
	
	secondText = true
	
	if(aHarry.pv > 0 && aFlaux.pv > 0):
		if(aFlaux.hide):
			cibler(aHarry)
		else:
			cibler(allies[randi()%2])
	elif(aHarry.pv > 0):
		cibler(aHarry)
	else:
		cibler(aFlaux)
	
	if(cible == aFlaux && aFlaux.hide):
		yield(spriteAnim,"animation_finished")
	else:
		lucyDegats(1 + randi()%2)
		yield(cible,"degatsTermine")
	
	affutage = true
	
	emit_signal("skillCast")

#Labourage (multi cible)
func castSkill2():
	
	if(aHarry.pv > 0 && aFlaux.pv > 0):
		if(not(aFlaux.hide)):
			cibler(aFlaux)
			lucyDegats(1 + randi()%2)
		cibler(aHarry)
		lucyDegats(1 + randi()%2)
		yield(cible,"degatsTermine")
	elif(aHarry.pv > 0):
		cibler(aHarry)
		lucyDegats(1 + randi()%2)
		yield(cible,"degatsTermine")
	else:
		if(not(aFlaux.hide)):
			cibler(aFlaux)
			lucyDegats(1 + randi()%2)
			yield(cible,"degatsTermine")
		else:
			yield(spriteAnim,"animation_finished")
	
	affutage = false
	
	emit_signal("skillCast")

#Coup de bouclier (une cible, augmente sa défense)
func castSkill3():

	secondText = true
	
	if(aHarry.pv > 0 && aFlaux.pv > 0):
		if(aFlaux.hide):
			cibler(aHarry)
		else:
			cibler(allies[randi()%2])
	elif(aHarry.pv > 0):
		cibler(aHarry)
	else:
		cibler(aFlaux)
	
	if(cible == aFlaux && aFlaux.hide):
		yield(spriteAnim,"animation_finished")
	else:
		lucyDegats(1 + randi()%2)
		yield(cible,"degatsTermine")
	
	affutage = false
	bouclier = true
	
	emit_signal("skillCast")

#Défense (prioritaire, augmente sa défense)
func castSkill4():
	
	guard = true
	soinPV(100)
	yield(spriteAnim,"animation_finished")
	
	affutage = false
	priorite = false
	
	emit_signal("skillCast")

#Poing de feu (une cible)
func castSkill5():
	
	if(aHarry.pv > 0 && aFlaux.pv > 0):
		if(aFlaux.hide):
			cibler(aHarry)
		else:
			cibler(allies[randi()%2])
	elif(aHarry.pv > 0):
		cibler(aHarry)
	else:
		cibler(aFlaux)
	
	if(cible == aFlaux && aFlaux.hide):
		yield(spriteAnim,"animation_finished")
	else:
		lucyDegats(1 + randi()%2)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Pied Volant (une cible, attaque prioritaire, seulement quand elle se relève)
func castSkill6():
	
	priorite = false
	affaibli = false
	
	if(aHarry.pv > 0 && aFlaux.pv > 0):
		cibler(allies[randi()%2])
	elif(aHarry.pv > 0):
		cibler(aHarry)
	else:
		cibler(aFlaux)
	
	lucyDegats(1 + randi()%2)
	yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Coup de boule (une cible, prend des dégâts de recul)
func castSkill7():
	
	if(aHarry.pv > 0 && aFlaux.pv > 0):
		if(aFlaux.hide):
			cibler(aHarry)
		else:
			cibler(allies[randi()%2])
	elif(aHarry.pv > 0):
		cibler(aHarry)
	else:
		cibler(aFlaux)
	
	if(cible == aFlaux && aFlaux.hide):
		yield(spriteAnim,"animation_finished")
	else:
		showDegats.add_color_override("default_color", Color(144.0/255.0,28.0/255.0,218.0/255.0,1))
		showDegats.set_bbcode(showDegats.get_bbcode() + degatsPrisDef(25))
		lucyDegats(1 + randi()%2)
		yield(cible,"degatsTermine")
	
	if(not(flagGetReal)):														#DIALOGUE
		#combat.litDialogue(dialogueI.dialogueName())
		#yield(dialogueI, "dialogueFini")
		flagGetReal = true
	
	emit_signal("skillCast")

#Baleyette (multi cible, attaque prioritaire, fait perdre un tour aux alliés)
func castSkill8():
	
	secondText = true
	priorite = false
	
	if(aHarry.pv > 0):
		cibler(aHarry)
		lucyDegats(1 + randi()%2)
		cible.abled()
		cible.tourEffectue = true
	if(aFlaux.pv > 0):
		cibler(aFlaux)
		lucyDegats(1 + randi()%2)
		cible.abled()
		cible.tourEffectue = true
	yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

#Contre (prioritaire, active un booléen qui fait qu'elle attaque à chaque coup reçu)
func castSkill9():
	
	priorite = false
	
	contre = true
	
	yield(spriteAnim,"animation_finished")
	
	if(not(flagContre)):														#DIALOGUE
		#combat.litDialogue(dialogueI.dialogueName())
		#yield(dialogueI, "dialogueFini")
		flagContre = true
	
	emit_signal("skillCast")

#Rien
func castSkill0():
	
	aTerre = false
	
	yield(spriteAnim,"animation_finished")
	
	emit_signal("skillCast")

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
		9:
			castSkill0()
			yield(self,"skillCast")
		
	tourEffectue = true
	emit_signal("skillFinished")

func clearThings():
	lacere = false
	bouclier = false
	guard = false
	contre = false
