extends HBoxContainer

#les signaux permettent de transmettre une information à d'autres scènes
signal butPressed
signal degatsTermine
signal skillCasted

onready var tourEffectue = false

var choixSkill
onready var priorite = false

#Les statistiques d'Harry
export var pvmax = 230		#les points de vie qu'il peut avoir au maximum
export var pv = 230			#les points de vie qu'il a actuellement
export var defense = 2		#sa défense, influt sur les dégâts reçus
export var vitesse = 2		#sa vitesse, influt sur l'ordre des actions d'un tour

#Stockage du sprite dans une variable pour pouvoir modifier son animation plus rapidement (et intuitivement)
onready var spriteAnim = get_node("HarryPortrait/VBoxContainer/Cadre/HarrySprite") #Sprite animé d'Harry
#Stockage de ce qui affiche la vie pour pouvoir modifier leur valeur plus rapidement/intuitivement
onready var barreVie = get_node("HarryPortrait/VBoxContainer/HarryLifeBar") #Barre de vie en textureProgress
onready var labelVie = get_node("HarryMenu/Background/Menu/VBoxContainer/GridContainer/PV") #Zone de texte avec la vie

#onready var interfaceGeneralH = get_node("../..") #permet d'accéder aux méthodes/variables de l'interface, non utilisé

#Stockage de la scène de Flaux dans une variable pour vérifier ses informations plus tard
onready var etatFlaux = get_node("../Flaux")

#Fonction qui s'active à l'apparition de la scène, non utilisé pour l'instant
func _ready():
	pass

#Méthode qui permet de modifier le contenu du texte qui décrit les compétences avec ce qui est entré en paramètre
func modifDesc(text):
	$HarryMenu/Background/Menu/VBoxContainer/MarginContainer/Description.set_text(text)

#Méthode qui permet de changer le sprite du personnage en fonction de son état par priorité
func changerSprite():
	if(pv == 0):						#Le personnage n'a plus assez de vie pour combattre
		spriteAnim.play("KO")
	elif(etatFlaux.pv == 0):			#L'autre personnage n'a plus beaucoup de vie
		spriteAnim.play("Enerve")
	elif(pv <= pvmax/3):				#Le personnage n'a plus beaucoup de vie
		spriteAnim.play("Fatigue")
	elif(etatFlaux.pv <= pvmax/3):		#L'autre personnage n'a plus beaucoup de vie
		spriteAnim.play("Inquiet")
	else:								#Aucun des problèmes si-dessus
		spriteAnim.play("Neutre")

#Méthode qui permet d'infliger des "degats" points de degats au personnage visé
func degatsPris(degats):
	spriteAnim.play("Blesse")		#Lance l'animation des dégâts pris
	if(pv - degats <= 0):			#La condition fait en sorte de ne pas avoir des pv négatifs
		pv = 0						#Si les pv sont inférieurs aux dégâts réçus, alors on tombe à 0pv
		tourEffectue = true			#Si un allié n'a plus de pv, alors son tour sera compté comme déjà passé
	else:
		pv -= degats				#Sinon les dégâts sont soustraits aux pv du personnage
	barreVie.value = pv										#On met à jour l'affichage des pv de la barre
	labelVie.set_text("PV :" + str(pv) + "/" + str(pvmax))	#Et du texte
	yield(spriteAnim,"animation_finished")
	changerSprite()
	etatFlaux.changerSprite()
	emit_signal("degatsTermine")

func soinPV(valeur):
	if(pv + valeur >= pvmax):
		pv = pvmax
	else:
		pv += valeur
	barreVie.value = pv										#On met à jour l'affichage des pv de la barre
	labelVie.set_text("PV :" + str(pv) + "/" + str(pvmax))	#Et du texte
	changerSprite()
	etatFlaux.changerSprite()

#Liste des bouttons que l'on peut presser, il renvoie tous le signal "un bouton a été pressé"
#Ce signal est ensuite reçu dans GeneralInterface pour savoir que le choix a eu lieu
func _on_SkillChargeBouclier_pressed():
	choixSkill = 0
	emit_signal("butPressed")

func castSkillChargeBouclier():
	etatFlaux.degatsPris(10)
	yield(etatFlaux,"degatsTermine")

func _on_SkillLancerBouclier_pressed():
	choixSkill = 1
	emit_signal("butPressed")

func castSkillLancerBouclier():
	etatFlaux.degatsPris(20)
	yield(etatFlaux,"degatsTermine")

func _on_SkillSoin_pressed():
	choixSkill = 2
	emit_signal("butPressed")

func castSkillSoin():
	soinPV(50)
	etatFlaux.soinPV(50)
	yield(spriteAnim,"animation_finished")
	#faire une petite animation de soin et attendre la fin

func _on_SkillDefense_pressed():
	choixSkill = 3
	priorite = true
	emit_signal("butPressed")

func castSkillDefense():
	etatFlaux.degatsPris(40)
	yield(etatFlaux,"degatsTermine")

func _on_SkillLancement_pressed():
	choixSkill = 4
	priorite = true
	emit_signal("butPressed")

func castSkillLancement():
	etatFlaux.degatsPris(50)
	yield(etatFlaux,"degatsTermine")

func castSkill():
	match choixSkill:
		0:
			castSkillChargeBouclier()
			yield(etatFlaux,"degatsTermine")
		1:
			castSkillLancerBouclier()
			yield(etatFlaux,"degatsTermine")
		2:
			castSkillSoin()
			yield(spriteAnim,"animation_finished")
			#faudra attendre la fin de l'anim de soin
		3:
			castSkillDefense()
			yield(etatFlaux,"degatsTermine")
			priorite = false
		4:
			castSkillLancement()
			yield(etatFlaux,"degatsTermine")
			priorite = false
		
	tourEffectue = true
	emit_signal("skillCasted")
