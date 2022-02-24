extends "res://Scenes/Ennemi.gd"

onready var aHarry = get_node("../../GeneralInterface/HBoxContainer/Harry")
onready var aFlaux = get_node("../../GeneralInterface/HBoxContainer/Flaux")

onready var allies = [aHarry,aFlaux]

onready var prepare = false
onready var assome = 0

func _ready():
	#Statistiques de l'ennemi
	pvmax = 500
	pv = 500
	defense = 15
	vitesse = 3
	
	ligne_skills(3)
	skillTextAppend(skills_text)
	next_skills()
	skillTextAppend(skills_text)
	charge_skills()

func charge_skills():
	skillTextAppend(skills_keys[5].textSkill)
	skillTextAppend(skills_keys[5].textSkill2)

func aTextSkill2():
	return textSkill[3]

func _on_Selection_pressed():
	emit_signal("butPressed")

#Surcharge
func degatsPrisDef(degats):
	if(lacere && assome > 0):
		degatsPris(int((degats-defense)*2.25))
	elif(assome > 0):
		degatsPris(int((degats-defense)*2))
	elif(lacere):
		degatsPris(int((degats-defense)*1.25))
	else:
		degatsPris(degats-defense)

func choixSkill():
	if(assome > 0):
		pass
	if(combat.nTour <= 3):
		choixSkill = 0
	elif(combat.nTour == 4):
		choixSkill = 1
	elif(prepare == true):
		choixSkill = 2
		prepare = false
	else:
		choixSkill = randi()%2
	
	if(assome > 0):
		tourEffectue = true
	else:
		tourEffectue = false

func castSkill1():
	
	secondText = false
			
	if(aFlaux.hide):
		cibler(aHarry)
	else:
		cibler(allies[randi()%2])
	
	cible.degatsPrisDef(60 + randi()%7)
	yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

func castSkill2():
	
	secondText = false
	prepare = true
	
	yield(self,"animation_finished")
	
	emit_signal("skillCast")

func castSkill3():
	
	if(aHarry.guard && aFlaux.hide):
		assome = 2
		secondText = true
		cibler(aHarry)
	elif(aFlaux.hide):
		secondText = false
		cibler(aHarry)
	else:
		secondText = false
		cibler(allies[randi()%2])
	
	cible.degatsPrisDef(150 + randi()%16)
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

#Surcharge 2
func clearThings():
	lacere = false
	if(assome > 0):
		assome -= 1
