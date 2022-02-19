extends HBoxContainer

#les signaux permettent de transmettre une information à d'autres scènes
signal butPressed
signal degatsTermine
signal skillCasted

onready var tourEffectue = false

var choixSkill
onready var priorite = false

#Les statistiques de Flaux
export var pvmax = 177		#les points de vie qu'elle peut avoir au maximum
export var pv = 177			#les points de vie qu'elle a actuellement
export var defense = 1		#sa défense, influt sur les dégâts reçus
export var vitesse = 4		#sa vitesse, influt sur l'ordre des actions d'un tour

#Stockage du sprite dans une variable pour pouvoir modifier son animation plus rapidement (et intuitivement)
onready var spriteAnim = get_node("FlauxPortrait/VBoxContainer/Cadre/FlauxSprite")
#Stockage de ce qui affiche la vie pour pouvoir modifier leur valeur plus rapidement/intuitivement
onready var barreVie = get_node("FlauxPortrait/VBoxContainer/FlauxLifeBar") #Barre de vie en textureProgress
onready var labelVie = get_node("FlauxMenu/Background/Menu/VBoxContainer/GridContainer/PV") #Zone de texte avec la vie

#onready var interfaceGeneralF = get_node("../..") #permet d'accéder aux méthodes/variables de l'interface, non utilisé

#Stockage de la scène d'Harry dans une variable pour vérifier ses informations plus tard
onready var etatHarry = get_node("../Harry")

#Fonction qui s'active à l'apparition de la scène, non utilisé pour l'instant
func _ready():
	pass

#Méthode qui permet de modifier le contenu du texte qui décrit les compétences avec ce qui est entré en paramètre
func modifDesc(text):
	$FlauxMenu/Background/Menu/VBoxContainer/MarginContainer/Description.set_text(text)

#Méthode qui permet de changer le sprite du personnage en fonction de son état par priorité
func changerSprite():
	if(pv == 0):						#Le personnage n'a plus assez de vie pour combattre
		spriteAnim.play("KO")
	elif(etatHarry.pv == 0):			#L'autre personnage n'a plus beaucoup de vie
		spriteAnim.play("Enervee")
	elif(pv <= pvmax/3):				#Le personnage n'a plus beaucoup de vie
		spriteAnim.play("Fatiguee")
	elif(etatHarry.pv <= pvmax/3):		#L'autre personnage n'a plus beaucoup de vie
		spriteAnim.play("Inquiete")
	else:								#Aucun des problèmes si-dessus
		spriteAnim.play("Neutre")

#Méthode qui permet d'infliger des "degats" points de degats au personnage visé
func degatsPris(degats):
	spriteAnim.play("Blessee")		#Lance l'animation des dégâts pris
	if(pv - degats <= 0):			#La condition fait en sorte de ne pas avoir des pv négatifs
		pv = 0						#Si les pv sont inférieurs aux dégâts réçus, alors on tombe à 0pv
		tourEffectue = true			#Si un allié n'a plus de pv, alors son tour sera compté comme déjà passé
	else:
		pv -= degats				#Sinon les dégâts sont soustraits aux pv du personnage
	barreVie.value = pv										#On met à jour l'affichage des pv de la barre
	labelVie.set_text("PV :" + str(pv) + "/" + str(pvmax))	#Et du texte
	yield(spriteAnim,"animation_finished")
	changerSprite()
	etatHarry.changerSprite()
	emit_signal("degatsTermine")

func soinPV(valeur):
	if(pv + valeur >= pvmax):
		pv = pvmax
	else:
		pv += valeur
	barreVie.value = pv										#On met à jour l'affichage des pv de la barre
	labelVie.set_text("PV :" + str(pv) + "/" + str(pvmax))	#Et du texte
	changerSprite()
	etatHarry.changerSprite()

#Liste des bouttons que l'on peut presser, il renvoie tous le signal "un bouton a été pressé"
#Ce signal est ensuite reçu dans GeneralInterface pour savoir que le choix a eu lieu
func _on_SkillSeCacher_pressed():
	choixSkill = 0
	priorite = true
	emit_signal("butPressed")

func castSkillSeCacher():
	etatHarry.degatsPris(10)
	yield(etatHarry,"degatsTermine")

func _on_SkillCoupPlongeant_pressed():
	choixSkill = 1
	emit_signal("butPressed")

func castSkillCoupPlongeant():
	etatHarry.degatsPris(20)
	yield(etatHarry,"degatsTermine")

func _on_SkillLabourage_pressed():
	choixSkill = 2
	emit_signal("butPressed")

func castSkillLabourage():
	etatHarry.degatsPris(30)
	yield(etatHarry,"degatsTermine")

func _on_SkillLaceration_pressed():
	choixSkill = 3
	emit_signal("butPressed")

func castSkillLaceration():
	etatHarry.degatsPris(40)
	yield(etatHarry,"degatsTermine")

func _on_SkillAffutage_pressed():
	choixSkill = 4 
	emit_signal("butPressed")

func castSkillAffutage():
	etatHarry.degatsPris(50)
	yield(etatHarry,"degatsTermine")

func castSkill():
	match choixSkill:
		0:
			castSkillSeCacher()
			yield(etatHarry,"degatsTermine")
			priorite = false
		1:
			castSkillCoupPlongeant()
			yield(etatHarry,"degatsTermine")
		2:
			castSkillLabourage()
			yield(etatHarry,"degatsTermine")
		3:
			castSkillLaceration()
			yield(etatHarry,"degatsTermine")
		4:
			castSkillAffutage()
			yield(etatHarry,"degatsTermine")
			
	tourEffectue = true
	emit_signal("skillCasted")
