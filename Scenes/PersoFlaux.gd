extends "res://Scenes/Perso.gd"

signal multiFait

#variables spécifiques à Flaux si elle se cache ou affute son arme
onready var hide = false
onready var affute = false

onready var multi = main.multi
onready var skill1y = false
onready var skill2y = false
onready var skill3y = false
onready var skill4y = false
onready var skill5y = false

onready var fFait = false
onready var premiereCible = false
onready var ciblageF = false
onready var i = 0

#quand elle apparaît, elle prend en allié Harry et récupère ses statistiques (qui ne changent pas)
func _ready():
	allie = get_node("../Harry")
	pvmax = 177
	pv = 177
	defense = 10
	vitesse = 4
	nom = "Flaux"

#Flaux utilise un _process(delta) pour que le joueur puisse annuler le choix du tour de Flaux pour le moment
#et recommencer le choix du tour d'Harry
func _process(_delta):
	#si on n'est pas en train de cibler avec Flaux (auquel cas "cancel" renvoie au menu de Flaux)
	if(not(multi) && not(ciblage) && interfaceGeneral.cFlauxFait):
		if(Input.is_action_just_pressed("ui_cancel")):	#lorsqu'on appuie sur cancel
			main.seCancel.play()
			annuleF = true								#on informe qu'on veut annuler le tour
			emit_signal("butPressed")					#et on envoie le signal pour que choixTour continue
	
	if(multi && pv>0 && not(horsCombat)):
		if(skill1y):
			#skill1.set("custom_colors/font_color", Color(1.0, 84.0/255.0, 53.0/255.0))
			skill1.skillName.set("custom_colors/font_color", Color(1, 125.0/255.0, 100.0/255.0))
			modifDesc(interfaceGeneral.seCacherDesc)
			if((Input.is_action_just_pressed("ui_multi_right") || Input.is_action_just_pressed("ui_multi_left")) && not(skill2.disabled)):
				main.seCursor.play()
				skill2y = true
				skill1y = false
				#skill1.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				skill1.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				yield(spriteAnim,"frame_changed")
			elif((Input.is_action_just_pressed("ui_multi_down") || Input.is_action_just_pressed("ui_multi_up")) && not(skill3.disabled)):
				main.seCursor.play()
				skill3y = true
				skill1y = false
				#skill1.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				skill1.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				yield(spriteAnim,"frame_changed")
			elif(Input.is_action_just_pressed("ui_multi_select")):
				_on_Skill1_pressed()
				main.seValider.play()
				skill1y = false
				#skill1.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				skill1.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				fFait = true
				emit_signal("multiFait")
		elif(skill2y):
			#skill2.set("custom_colors/font_color", Color(1.0, 84.0/255.0, 53.0/255.0))
			skill2.skillName.set("custom_colors/font_color", Color(1, 125.0/255.0, 100.0/255.0))
			modifDesc(interfaceGeneral.coupPlongeantDesc)
			if((Input.is_action_just_pressed("ui_multi_right") || Input.is_action_just_pressed("ui_multi_left")) && not(skill1.disabled)):
				main.seCursor.play()
				skill1y = true
				skill2y = false
				#skill2.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				skill2.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				yield(spriteAnim,"frame_changed")
			elif(Input.is_action_just_pressed("ui_multi_down")):
				main.seCursor.play()
				if(skill4.visible):
					if(not(skill4.disabled)):
						skill4y = true
						skill2y = false
						#skill2.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
						skill2.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
						yield(spriteAnim,"frame_changed")
					else:
						if(skill5.visible):
							skill5y = true
							skill2y = false
							#skill2.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
							skill2.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
							yield(spriteAnim,"frame_changed")
			elif((Input.is_action_just_pressed("ui_multi_up")) && not(skill5.disabled)):
				main.seCursor.play()
				if(skill5.visible):
					skill5y = true
					skill2y = false
					#skill2.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
					skill2.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
					yield(spriteAnim,"frame_changed")
			elif(Input.is_action_just_pressed("ui_multi_select")):
				_on_Skill2_pressed()
				main.seValider.play()
				skill2y = false
				#skill2.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				skill2.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				ciblageF = true
				yield(spriteAnim,"frame_changed")
		elif(skill3y):
			#skill3.set("custom_colors/font_color", Color(1.0, 84.0/255.0, 53.0/255.0))
			skill3.skillName.set("custom_colors/font_color", Color(1, 125.0/255.0, 100.0/255.0))
			modifDesc(interfaceGeneral.labourageDesc)
			if((Input.is_action_just_pressed("ui_multi_right") || Input.is_action_just_pressed("ui_multi_left")) && not(skill4.disabled)):
				main.seCursor.play()
				if(skill4.visible):
					skill4y = true
					skill3y = false
					#skill3.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
					skill3.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
					yield(spriteAnim,"frame_changed")
			elif((Input.is_action_just_pressed("ui_multi_down") || Input.is_action_just_pressed("ui_multi_up")) && not(skill1.disabled)):
				main.seCursor.play()
				skill1y = true
				skill3y = false
				#skill3.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				skill3.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				yield(spriteAnim,"frame_changed")
			elif(Input.is_action_just_pressed("ui_multi_select")):
				_on_Skill3_pressed()
				main.seValider.play()
				skill3y = false
				#skill3.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				skill3.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				fFait = true
				emit_signal("multiFait")
		elif(skill4y):
			#skill4.set("custom_colors/font_color", Color(1.0, 84.0/255.0, 53.0/255.0))
			skill4.skillName.set("custom_colors/font_color", Color(1, 125.0/255.0, 100.0/255.0))
			modifDesc(interfaceGeneral.lacerationDesc)
			if((Input.is_action_just_pressed("ui_multi_right") || Input.is_action_just_pressed("ui_multi_left")) && not(skill3.disabled)):
				main.seCursor.play()
				skill3y = true
				skill4y = false
				#skill4.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				skill4.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				yield(spriteAnim,"frame_changed")
			elif((Input.is_action_just_pressed("ui_multi_down")) && not(skill5.disabled)):
				main.seCursor.play()
				if(skill5.visible):
					skill5y = true
					skill4y = false
					#skill4.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
					skill4.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
					yield(spriteAnim,"frame_changed")
			elif((Input.is_action_just_pressed("ui_multi_up")) && not(skill2.disabled)):
				main.seCursor.play()
				skill2y = true
				skill4y = false
				#skill4.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				skill4.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				yield(spriteAnim,"frame_changed")
			elif(Input.is_action_just_pressed("ui_multi_select")):
				_on_Skill4_pressed()
				main.seValider.play()
				skill4y = false
				#skill4.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				skill4.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				ciblageF = true
				yield(spriteAnim,"frame_changed")
		elif(skill5y):
			#skill5.set("custom_colors/font_color", Color(1.0, 84.0/255.0, 53.0/255.0))
			skill5.skillName.set("custom_colors/font_color", Color(1, 125.0/255.0, 100.0/255.0))
			modifDesc(interfaceGeneral.affutageDesc)
			if(Input.is_action_just_pressed("ui_multi_up")):
				main.seCursor.play()
				if(not(skill4.disabled)):
					skill4y = true
					skill5y = false
					#skill5.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
					skill5.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
					yield(spriteAnim,"frame_changed")
				else:
					skill2y = true
					skill5y = false
					#skill5.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
					skill5.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
					yield(spriteAnim,"frame_changed")
			elif((Input.is_action_just_pressed("ui_multi_down")) && not(skill2.disabled)):
				main.seCursor.play()
				skill2y = true
				skill5y = false
				#skill5.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				skill5.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				yield(spriteAnim,"frame_changed")
			elif(Input.is_action_just_pressed("ui_multi_select")):
				_on_Skill5_pressed()
				main.seValider.play()
				skill5y = false
				#skill5.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				skill5.skillName.set("custom_colors/font_color", Color( 0.88, 0.88, 0.88, 1 ))
				fFait = true
				emit_signal("multiFait")
		elif(ciblageF):
			modifDesc("")
			if(ennemis[i].pv > 0):
				ennemis[i].selectionF.show()
				ennemis[i].barreVie.show()
			else:
				if(i < ennemis.size()-1):
					i += 1
				else:
					i = 0
			if(Input.is_action_just_pressed("ui_multi_right")):
				ennemis[i].selectionF.hide()
				ennemis[i].barreVie.hide()
				if(i < ennemis.size()-1):
					i += 1
				else:
					i = 0
			if(Input.is_action_just_pressed("ui_multi_left")):
				ennemis[i].selectionF.hide()
				ennemis[i].barreVie.hide()
				if(i > 0):
					i -= 1
				else:
					i = ennemis.size()-1
			if(Input.is_action_just_pressed("ui_multi_cancel")):
				ciblageF = false
				main.seCancel.play()
				ennemis[i].selectionF.hide()
				ennemis[i].barreVie.hide()
				if(not(skill1.disabled)):
					skill1y = true
				else:
					skill2y = true
				yield(spriteAnim,"frame_changed")
			if(Input.is_action_just_pressed("ui_multi_select")):
				ciblageF = false
				main.seValider.play()
				ennemis[i]._on_SelectionFlaux_pressed()
				ennemis[i].selectionF.hide()
				ennemis[i].barreVie.hide()
				cibler(ennemis[i])
				fFait = true
				emit_signal("multiFait")
		else:
			modifDesc("")

#Surcharge pour les compétences prioritaires et qui ciblent
func _on_Skill1_pressed():
	choixSkill = 0
	
	priorite = true
	ciblage = false
	
	tourEffectue = false
	emit_signal("butPressed")

func _on_Skill2_pressed():
	choixSkill = 1
	
	priorite = false
	ciblage = true
	
	tourEffectue = false
	emit_signal("butPressed")

func _on_Skill4_pressed():
	choixSkill = 3
	
	priorite = false
	ciblage = true
	
	tourEffectue = false
	emit_signal("butPressed")

func degatsPrisDef(degats):
	if(emotion == 3):
		degats += 20
	elif(emotion == 2):
		degats -= 20
	elif(emotion == 1):
		degats -= 10
	
	degatsPris(degats-defense)

#fonction qui permet d'infliger des dégâts en fonction de l'état du personnage
#degatsPrisDef renvoie une chaîne de caractères que deg prend
#pour qu'on puisse ensuite afficher les dégats en changeant le texte "showDegats" de l'ennemi ciblé
func flauxDegats(degats):
	if(emotion == 3):
		degats += 20
	elif(emotion == 2):
		degats -= 10
	elif(emotion == 1):
		degats += 10
	
	if(affute && allie.launch):
		deg = cible.degatsPrisDef(int(degats*3.5))
	elif(affute):
		deg = cible.degatsPrisDef(int(degats*2.5))
	elif(allie.launch):
		deg = cible.degatsPrisDef(int(degats*1.5))
	else:
		deg = cible.degatsPrisDef(degats)
	
	main.seFlauxTappe.play()
	
	#on attend un petit instant (un changement de frame) pour afficher les dégâts quand l'ennemi clignote
	yield(cible.spriteAnim,"frame_changed")
	#on change la couleur du texte de l'affichage des dégâts (parce que c'est cool)
	cible.showDegats.add_color_override("default_color", Color(172.0/255.0,50.0/255.0,50.0/255.0,1))
	#on concatène les dégâts effectués avec le richText actuel (pour garder les effets de textes)
	cible.showDegats.set_bbcode(cible.showDegats.get_bbcode() + deg)

#Surcharge des castSkill avec l'effet des compétences
func castSkill1():
	
	hide = true
	priorite = false
	
	yield(spriteAnim,"animation_finished")
	emit_signal("skillCast")

func castSkill2():
	
	if(cible.pv == 0):
		for ci in ennemis:
			if(ci.pv > 0):
				cibler(ci)
	
	flauxDegats(77+randi()%8)
	ciblage = false
	priorite = false
	
	yield(cible,"degatsTermine")
	
	affute = false
	
	emit_signal("skillCast")

func castSkill3():
	
	for ci in ennemis:
		if(ci.pv > 0):
			cibler(ci)
			flauxDegats(50+randi()%6)
			yield(cible.spriteAnim,"frame_changed")
	
	priorite = false
	
	yield(cible,"degatsTermine")
	
	affute = false
	
	emit_signal("skillCast")

func castSkill4():
	
	if(cible.pv == 0):
		for ci in ennemis:
			if(ci.pv > 0):
				cibler(ci)
	
	flauxDegats(50+randi()%6)
	ciblage = false
	priorite = false
	
	cible.lacere = true
	
	yield(cible,"degatsTermine")
	
	affute = false
	
	emit_signal("skillCast")

func castSkill5():
	
	priorite = false
	affute = true
	
	yield(spriteAnim,"animation_finished")
	emit_signal("skillCast")

#met à jour les effets temporaires
func clearThings():
	hide = false
