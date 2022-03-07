extends "res://Scenes/Perso.gd"

#variables spécifiques à Flaux si elle se cache ou affute son arme
onready var hide = false
onready var affute = 0

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
func _process(delta):
	#si on n'est pas en train de cibler avec Flaux (auquel cas "cancel" renvoie au menu de Flaux)
	if(not(ciblage)):
		if(Input.is_action_just_pressed("ui_cancel")):	#lorsqu'on appuie sur cancel
			annuleF = true								#on informe qu'on veut annuler le tour
			emit_signal("butPressed")					#et on envoie le signal pour que choixTour continue

#Surcharge pour les compétences prioritaires et qui ciblent
func _on_Skill1_pressed():
	choixSkill = 0
	
	priorite = true
	ciblage = false
	emit_signal("butPressed")

func _on_Skill2_pressed():
	choixSkill = 1
	
	priorite = false
	ciblage = true
	emit_signal("butPressed")

func _on_Skill4_pressed():
	choixSkill = 3
	
	priorite = false
	ciblage = true
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
		degats -= 20
	elif(emotion == 1):
		degats += 10
	
	if(affute > 0 && allie.launch):
		deg = cible.degatsPrisDef(int(degats*3.5))
	elif(affute > 0):
		deg = cible.degatsPrisDef(int(degats*2.5))
	elif(allie.launch):
		deg = cible.degatsPrisDef(int(degats*1.5))
	else:
		deg = cible.degatsPrisDef(degats)
	
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
	
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill3():#faut tout revoir
	
	for ci in ennemis:
		if(ci.pv > 0):
			cibler(ci)
			flauxDegats(50+randi()%6)
			yield(cible.spriteAnim,"frame_changed")
	
	yield(cible,"degatsTermine")
	
	emit_signal("skillCast")

func castSkill4():
	
	if(cible.pv == 0):
		for ci in ennemis:
			if(ci.pv > 0):
				cibler(ci)
	
	flauxDegats(50+randi()%6)
	ciblage = false
	
	cible.lacere = true
	
	yield(cible,"degatsTermine")
	emit_signal("skillCast")

func castSkill5():
	
	affute = 2
	
	yield(spriteAnim,"animation_finished")
	emit_signal("skillCast")

#met à jour les effets temporaires
func clearThings():
	hide = false
	if(affute > 0):
		affute -= 1
