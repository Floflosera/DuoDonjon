extends "res://Scenes/Combattant.gd"

#les signaux permettent de transmettre une information à d'autres scènes
signal butPressed

#à l'apparition du personnage, on lui donne ses caractèristiques qui ne changent pas
func _ready():
	ennemi = false
	spriteAnim = get_node("Portrait/VBoxContainer/Cadre/Sprite")
	barreVie = get_node("Portrait/VBoxContainer/LifeBar")

#Stockage du label de vie pour pouvoir accéder à son contenu plus facilement
onready var labelVie = get_node("CadreMenu/Background/Menu/VBoxContainer/GridContainer/PV")

#Nom des personnages en chaîne de caractères
var nom = ""
#Stockage de la scène de l'allié dans une variable pour vérifier ses informations plus tard
var allie
#On stocke le groupe ennemis et les ennemis de ce groupe dans des variables, pour faciliter le ciblage ou autre
onready var ennemiGroup = get_node("../../../EnnemiGroup")
onready var ennemis =  ennemiGroup.ennemis

#permet l'affichage des dégâts ennemis
onready var deg = ""
#permet de vérifier si le tour a été choisi
onready var tourChoisi = false
#permet de vérifier si Flaux a annulé son tour (pour rendre la main à Harry)
onready var annuleF = false

#lorsque le personnage est prisonnier ou autre
onready var horsCombat = false

#on stocke les compétences dans des variables avec un nom plus simple
onready var skill1 = $CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill1
onready var skill2 = $CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill2
onready var skill3 = $CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill3
onready var skill4 = $CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill4
onready var skill5 = $CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill5

#on met ces compétences dans un tableau pour pouvoir y accéder d'une autre manière (avec des indices)
onready var skills = [skill1,skill2,skill3,skill4,skill5]

onready var emotion = 0

#Méthode qui permet de modifier le contenu du texte qui décrit les compétences avec ce qui est entré en paramètre
func modifDesc(text):
	$CadreMenu/Background/Menu/VBoxContainer/MarginContainer/Description.set_text(text)

#s'il faut un 2e texte de skill
onready var textSkill2 = ""

func aTextSkill2Put(text):
	textSkill2 = text

func aTextSkill2():
	return textSkill2

#Change le sprite en fonction du nombre entré en paramètre
func changerSpriteDia(n):
	match n:
		0:
			spriteAnim.play("Neutre")
		1:
			spriteAnim.play("Content")
		2:
			spriteAnim.play("Enerve")
		3:
			spriteAnim.play("Triste")
		4:
			spriteAnim.play("Inquiet")
		5:
			spriteAnim.play("Fatigue")
		6:
			spriteAnim.play("Blesse")
		7:
			spriteAnim.play("KO")

#Surcharge pour les persos
func changerSprite():
	if(horsCombat):						#Le personnage est emprisonné par l'ennemi
		spriteAnim.play("Prisonnier")
	elif(pv == 0):						#Le personnage n'a plus assez de vie pour combattre
		spriteAnim.play("KO")
		emotion = -1
	elif(allie.pv == 0):				#L'autre personnage n'a plus beaucoup de vie
		spriteAnim.play("Enerve")
		emotion = 3
	elif(pv <= pvmax*0.4):				#Le personnage n'a plus beaucoup de vie
		spriteAnim.play("Fatigue")
		emotion = 2
	elif(allie.pv <= allie.pvmax*0.4):	#L'autre personnage n'a plus beaucoup de vie
		spriteAnim.play("Inquiet")
		emotion = 1
	else:								#Aucun des problèmes si-dessus
		spriteAnim.play("Neutre")
		emotion = 0

#Pour afficher la vie en fonction de la langue
func labelVieF():
	if(get_node("../..").fr):
		labelVie.set_text("PV : " + str(pv) + "/" + str(pvmax))	#Avec PV
	else:
		labelVie.set_text("HP : " + str(pv) + "/" + str(pvmax))	#Ou HP

#Surcharge pour l'affichage de vie et changement allié
func degatsPris(degats):
	degats = int(degats)
	spriteAnim.play("Blesse")		#Lance l'animation des dégâts pris
	if(degats < 1):
		degats = 0
	if(pv - degats <= 0):			#La condition fait en sorte de ne pas avoir des pv négatifs
		pv = 0						#Si les pv sont inférieurs aux dégâts réçus, alors on tombe à 0pv
		tourEffectue = true			#Si un allié n'a plus de pv, alors son tour sera compté comme déjà passé
	else:
		pv -= degats				#Sinon les dégâts sont soustraits aux pv du personnage
	barreVie.value = pv				#On met à jour l'affichage des pv de la barre
	labelVieF()						#Et des PV en textes
	yield(spriteAnim,"animation_finished")	#Attend la fin de l'animation de blessure
	changerSprite()							#Change le sprite des 2 persos
	allie.changerSprite()					#pour revérifier quelle sprite il faut afficher
	emit_signal("degatsTermine")

#Surcharge pour les persos
func soinPV(valeur):
	if(pv + valeur >= pvmax):		#On ne peut pas dépasser sa valeur max de vie
		pv = pvmax					#Comme pour les dégâts, on donne une valeur fixe auquel cas
	else:
		pv += valeur				#Sinon on se soigne de la valeur en question
	barreVie.value = pv				#On met à jour l'affichage des pv de la barre
	labelVieF()						#Et des PV en textes
	changerSprite()					#On change le sprite des 2 persos
	allie.changerSprite()			#pour revérifier quelle sprite il faut afficher

#permet de rerendre toutes les compétences réutilisables
func abled():
	skill1.disabled = false
	skill2.disabled = false
	skill3.disabled = false
	skill4.disabled = false
	skill5.disabled = false

#Liste des bouttons que l'on peut presser, il renvoie tous le signal "un bouton a été pressé"
#Ce signal est ensuite reçu dans GeneralInterface pour savoir que le choix a eu lieu
#La variable "choixSkill" est un nombre qui porte le numéro de la compétence choisie pour la lancer plus tard
#On passe la priorite a vrai si l'attaque en question est prioritaire à l'ordre de la vitesse
#On passe le ciblage a vrai si l'attaque en question doit cibler un ennemi précisément
#Pour paramètrer ces informations, on fait des surcharges sur les personnages
func _on_Skill1_pressed():
	choixSkill = 0
	
	priorite = false
	ciblage = false
	emit_signal("butPressed")

func _on_Skill2_pressed():
	choixSkill = 1
	
	priorite = false
	ciblage = false
	emit_signal("butPressed")

func _on_Skill3_pressed():
	choixSkill = 2
	
	priorite = false
	ciblage = false
	emit_signal("butPressed")

func _on_Skill4_pressed():
	choixSkill = 3
	
	priorite = false
	ciblage = false
	emit_signal("butPressed")

func _on_Skill5_pressed():
	choixSkill = 4
	
	priorite = false
	ciblage = false
	emit_signal("butPressed")
