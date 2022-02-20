extends HBoxContainer

#les signaux permettent de transmettre une information à d'autres scènes
signal butPressed
signal degatsTermine
signal skillCasted

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

#Stockage de la scène de Flaux dans une variable pour vérifier ses informations plus tard
onready var etatFlaux = get_node("../Flaux")

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
	etatFlaux.changerSprite()				#pour revérifier quelle sprite il faut afficher
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
	etatFlaux.changerSprite()		#pour revérifier quelle sprite il faut afficher

#Liste des bouttons que l'on peut presser, il renvoie tous le signal "un bouton a été pressé"
#Ce signal est ensuite reçu dans GeneralInterface pour savoir que le choix a eu lieu
#La variable "choixSkill" est un nombre qui porte le numéro de la compétence choisie pour la lancer plus tard
#On passe la priorite a vrai si l'attaque en question est prioritaire à l'ordre de la vitesse
func _on_SkillChargeBouclier_pressed():
	choixSkill = 0
	emit_signal("butPressed")

#Chaque bouton permet de pouvoir lancer un sort plus tard durant la déroulement du tour
#Ces sorts sont associés aux fonctions "castSkill" et ont chacun des effets différents
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

#Le skill de soin permet de soigner les deux alliés
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

#castSkill() est la fonction qui lance une compétence en fonction du choix effectué précédemment
#les compétences prioritaires remettent la variable priorite sur false une fois lancé
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
		
	tourEffectue = true				#Quand une compétence est lancé, le tour est effectué
	emit_signal("skillCasted")
