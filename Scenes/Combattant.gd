extends Node

#signal envoyé quand on a fini de recevoir des dégâts et l'animation blessure
signal degatsTermine
#signaux lorsque l'on lance une compétence
signal skillCast
signal skillFinished

#booléen qui dit si le combattant est un ennemi ou non
var ennemi = false
#accès au noeud principal (défini en fonction du type de combattant)
onready var main = get_node("../../../..") #chemin pour ennemi

#Stockage du sprite dans une variable pour pouvoir modifier son animation plus rapidement (et intuitivement)
var spriteAnim

#La variable qui permet de savoir si une action a été effectué
#Elle est false de base, et devient true lorsqu'on effectue une action (ou que le personnage n'a plus de pv)
#Elle redevient false lorsque l'on choisit sa nouvelle action
onready var tourEffectue = true

#Stocke le choix d'action du joueur et des ennemis
onready var choixSkill = 0
#Variable qui permet de vérifier si une action est prioritaire ou non
#Elle devient vrai lorsque l'on choisit une attaque prioritaire
#Elle redevient fausse lorsque l'on lance une attaque prioritaire
onready var priorite = false

#variable utilisé pour les compétences qui ciblent des alliés
onready var ciblage = false
#contient un combattant actuellement ciblé par le combattant
var cible

#permet de changer de cible avec une méthode
func cibler(c):
	cible = c

#définie si on lance un second texte après une action
onready var secondText = false

#Les statistiques
export var pvmax = 1		#les points de vie qu'il peut avoir au maximum
export var pv = 1			#les points de vie qu'il a actuellement
export var defense = 0		#sa défense, influt sur les dégâts reçus
export var vitesse = 0 		#sa vitesse, influt sur l'ordre des actions d'un tour

var barreVie #Barre de vie en textureProgress

var textSkill = [] #tableau des textes affichés au lancement d'une attaque

#tableau qui contient la description des actions lancées
func skillTextAppend(skillsText):
	textSkill.append(skillsText)

#renvoie une chaîne de caractères qui est la description de l'action choisi lorsqu'elle est lancée
func aTextSkill():
	return textSkill[choixSkill]

#Tout le monde pourrait l'avoir mais le texte est spécifique au combattant qui l'utilise
#Cette méthode renvoie une chaîne de caractère spécifique au combattant
func aTextSkill2():
	pass

#Méthode qui permet de changer le sprite du personnage en fonction de son état par priorité
func changerSprite():
	spriteAnim.play("Neutre")

#Méthode qui permet d'infliger "degats" points de degats au personnage visé
func degatsPris(degats):
	degats = int(degats)
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
	emit_signal("degatsTermine")

#Méthode qui permet de déduire les dégâts à la défense du combattant
#Est surchargé par les combattants en fonction des autres effets qui changent les dégâts
func degatsPrisDef(degats):
	degatsPris(degats-defense)

#Fonction lancer lorsqu'un soin est utilisé sur un personnage, il soigne "valeur" pv
func soinPV(valeur):
	if(pv + valeur >= pvmax):		#On ne peut pas dépasser sa valeur max de vie
		pv = pvmax					#Comme pour les dégâts, on donne une valeur fixe auquel cas
	else:
		pv += valeur				#Sinon on se soigne de la valeur en question
	barreVie.value = pv				#On met à jour l'affichage des pv de la barre

#Chaque bouton permet de pouvoir lancer un sort plus tard durant la déroulement du tour
#Ces sorts sont associés aux fonctions "castSkill" et ont chacun des effets différents
func castSkill1():
	emit_signal("skillCast")

func castSkill2():
	emit_signal("skillCast")

func castSkill3():
	emit_signal("skillCast")

func castSkill4():
	emit_signal("skillCast")

func castSkill5():
	emit_signal("skillCast")

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

#à surcharger en fonction du combattants
#permet de mettre à jour les effets temporaires
func clearThings():
	pass
