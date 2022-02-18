extends HBoxContainer

#les signaux permettent de transmettre une information à d'autres scènes
signal butPressed

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
	else:
		pv -= degats				#Sinon les dégâts sont soustraits aux pv du personnage
	barreVie.value = pv										#On met à jour l'affichage des pv de la barre
	labelVie.set_text("PV :" + str(pv) + "/" + str(pvmax))	#Et du texte
	$TimerBlesse.start()			#On lance un timer de une seconde pour savoir quand arrêter l'animation de blessure

#Quand le timmer "TimerBlesse" se termine (au bout d'une seconde)
func _on_TimerBlesse_timeout():
	changerSprite()			#On modifie le sprite en veillant à respecter les conditions dans la méthode
	$TimerBlesse.stop()		#On arrête le timer quand c'est fini

#Liste des bouttons que l'on peut presser, il renvoie tous le signal "un bouton a été pressé"
#Ce signal est ensuite reçu dans GeneralInterface pour savoir que le choix a eu lieu
func _on_SkillChargeBouclier_pressed():
	emit_signal("butPressed")


func _on_SkillLancerBouclier_pressed():
	emit_signal("butPressed")


func _on_SkillSoin_pressed():
	emit_signal("butPressed")


func _on_SkillDefense_pressed():
	emit_signal("butPressed")


func _on_SkillLancement_pressed():
	emit_signal("butPressed")
