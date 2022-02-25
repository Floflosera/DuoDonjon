extends "res://Scenes/Perso.gd"

onready var hide = false
onready var affute = 0

func _ready():
	allie = get_node("../Harry")
	pvmax = 177
	pv = 177
	defense = 10
	vitesse = 4

#Surcharge pour les compétences prioritaires et qui ciblent
func _on_Skill1_pressed():
	choixSkill = 0
	abled()
	skill1.disabled = true
	priorite = true
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
	ciblage = true
	emit_signal("butPressed")

func flauxDegats(degats):
	if(affute > 0 && allie.launch):
		deg = cible.degatsPrisDef(int(degats*3.5))
	elif(affute > 0):
		deg = cible.degatsPrisDef(int(degats*2.5))
	elif(allie.launch):
		deg = cible.degatsPrisDef(int(degats*1.5))
	else:
		deg = cible.degatsPrisDef(degats)
	
	yield(cible.spriteAnim,"frame_changed")
	cible.showDegats.add_color_override("default_color", Color(172.0/255.0,50.0/255.0,50.0/255.0,1))
	cible.showDegats.set_bbcode(cible.showDegats.get_bbcode() + deg)

#Surcharge des castSkill
func castSkill1():
	
	hide = true
	priorite = false
	
	yield(spriteAnim,"animation_finished")
	emit_signal("skillCast")

func castSkill2():
	
	flauxDegats(77+randi()%8)
	ciblage = false
	
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill3():#faut tout revoir
	for ci in ennemis:
		cibler(ci)
		flauxDegats(50+randi()%6)
		yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

func castSkill4():
	
	flauxDegats(50+randi()%6)
	ciblage = false
	
	cible.lacere = true
	
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill5():
	
	affute = 2
	
	yield(spriteAnim,"animation_finished")
	emit_signal("skillCast")

func clearThings():
	hide = false
	if(affute > 0):
		affute -= 1
