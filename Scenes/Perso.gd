extends HBoxContainer

#les signaux permettent de transmettre une information à d'autres scènes
signal butPressed
signal degatsTermine
signal skillCast
signal skillFinished

#La variable qui permet de savoir si une action a été effectué
#Elle est false de base, et devient true lorsqu'on effectue une action (ou que le personnage n'a plus de pv)
#Elle redevient false lorsque l'on choisit sa nouvelle action
onready var tourEffectue = false

#Stocke le choix d'action du joueur
var choixSkill
#Variable qui permet de vérifier si une action est prioritaire ou non
#Elle devient vrai lorsque l'on choisit une attaque prioritaire
#Elle redevient fausse lorsque l'on lance une attaque prioritaire
onready var priorite = false

#Les statistiques
export var pvmax = 1		#les points de vie qu'il peut avoir au maximum
export var pv = 1			#les points de vie qu'il a actuellement
export var defense = 0		#sa défense, influt sur les dégâts reçus
export var vitesse = 0 		#sa vitesse, influt sur l'ordre des actions d'un tour

#Stockage du sprite dans une variable pour pouvoir modifier son animation plus rapidement (et intuitivement)
onready var spriteAnim = get_node("Portrait/VBoxContainer/Cadre/Sprite") #Sprite animé d'Harry
#Stockage de ce qui affiche la vie pour pouvoir modifier leur valeur plus rapidement/intuitivement
onready var barreVie = get_node("Portrait/VBoxContainer/LifeBar") #Barre de vie en textureProgress
onready var labelVie = get_node("CadreMenu/Background/Menu/VBoxContainer/GridContainer/PV") #Zone de texte avec la vie

#Stockage de la scène de l'allié dans une variable pour vérifier ses informations plus tard
var allie

#Méthode qui permet de modifier le contenu du texte qui décrit les compétences avec ce qui est entré en paramètre
func modifDesc(text):
	$CadreMenu/Background/Menu/VBoxContainer/MarginContainer/Description.set_text(text)

#Méthode qui permet de changer le sprite du personnage en fonction de son état par priorité
func changerSprite():
	if(pv == 0):						#Le personnage n'a plus assez de vie pour combattre
		spriteAnim.play("KO")
	elif(allie.pv == 0):			#L'autre personnage n'a plus beaucoup de vie
		spriteAnim.play("Enerve")
	elif(pv <= pvmax/3):				#Le personnage n'a plus beaucoup de vie
		spriteAnim.play("Fatigue")
	elif(allie.pv <= pvmax/3):		#L'autre personnage n'a plus beaucoup de vie
		spriteAnim.play("Inquiet")
	else:								#Aucun des problèmes si-dessus
		spriteAnim.play("Neutre")

#Pour afficher la vie en fonction de la langue
func labelVieF():
	if(get_node("../..").fr):
		labelVie.set_text("PV : " + str(pv) + "/" + str(pvmax))	#Avec PV
	else:
		labelVie.set_text("HP : " + str(pv) + "/" + str(pvmax))	#Ou HP

#Méthode qui permet d'infliger "degats" points de degats au personnage visé
func degatsPris(degats):
	spriteAnim.play("Blesse")		#Lance l'animation des dégâts pris
	if(pv - degats <= 0):			#La condition fait en sorte de ne pas avoir des pv négatifs
		pv = 0						#Si les pv sont inférieurs aux dégâts réçus, alors on tombe à 0pv
		tourEffectue = true			#Si un allié n'a plus de pv, alors son tour sera compté comme déjà passé
	else:
		pv -= degats				#Sinon les dégâts sont soustraits aux pv du personnage
	barreVie.value = pv				#On met à jour l'affichage des pv de la barre
	labelVieF()						#Et des PV en textes
	yield(spriteAnim,"animation_finished")	#Attend la fin de l'animation de blessure
	changerSprite()							#Change le sprite des 2 persos
	allie.changerSprite()				#pour revérifier quelle sprite il faut afficher
	emit_signal("degatsTermine")

#Fonction lancer lorsqu'un soin est utilisé sur un personnage, il soigne "valeur" pv
func soinPV(valeur):
	if(pv + valeur >= pvmax):		#On ne peut pas dépasser sa valeur max de vie
		pv = pvmax					#Comme pour les dégâts, on donne une valeur fixe auquel cas
	else:
		pv += valeur				#Sinon on se soigne de la valeur en question
	barreVie.value = pv				#On met à jour l'affichage des pv de la barre
	labelVieF()						#Et des PV en textes
	changerSprite()					#On change le sprite des 2 persos
	allie.changerSprite()			#pour revérifier quelle sprite il faut afficher

#Permet de rerendre utilisable le skill utilise au tour précédent pour le tour suivant
func abled():
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill1.disabled = false
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill2.disabled = false
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill3.disabled = false
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill4.disabled = false
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill5.disabled = false

#Liste des bouttons que l'on peut presser, il renvoie tous le signal "un bouton a été pressé"
#Ce signal est ensuite reçu dans GeneralInterface pour savoir que le choix a eu lieu
#La variable "choixSkill" est un nombre qui porte le numéro de la compétence choisie pour la lancer plus tard
#On passe la priorite a vrai si l'attaque en question est prioritaire à l'ordre de la vitesse
func _on_Skill1_pressed():
	choixSkill = 0
	abled()
	#on bloque une action pendant un tour lorsqu'elle est utilisée
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill1.disabled = true
	emit_signal("butPressed")

#Chaque bouton permet de pouvoir lancer un sort plus tard durant la déroulement du tour
#Ces sorts sont associés aux fonctions "castSkill" et ont chacun des effets différents
func castSkill1():
	pass

func _on_Skill2_pressed():
	choixSkill = 1
	abled()
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill2.disabled = true
	emit_signal("butPressed")

func castSkill2():
	pass

func _on_Skill3_pressed():
	choixSkill = 2
	abled()
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill3.disabled = true
	emit_signal("butPressed")

#Le skill de soin permet de soigner les deux alliés
func castSkill3():
	pass

func _on_Skill4_pressed():
	choixSkill = 3
	abled()
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill4.disabled = true
	emit_signal("butPressed")

func castSkill4():
	pass

func _on_Skill5_pressed():
	choixSkill = 4
	abled()
	$CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill5.disabled = true
	emit_signal("butPressed")

func castSkill5():
	pass

#castSkill() est la fonction qui lance une compétence en fonction du choix effectué précédemment
#les compétences prioritaires remettent la variable priorite sur false une fois lancé
#La fonction est un peu détaillée mais elle devra être surchargée
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
		
	tourEffectue = true				#Quand une compétence est lancé, le tour est effectué
	emit_signal("skillFinished")
