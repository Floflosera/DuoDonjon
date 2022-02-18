extends MarginContainer

signal choixTourFini

#Tous les boutons de skills d'Harry sont stockés dans une variable pour agir sur leur focus plus tard
onready var skillsHarryChargeBouclier = get_node("HBoxContainer/Harry/HarryMenu/Background/Menu/VBoxContainer/GridContainer/SkillChargeBouclier")
onready var skillsHarryLancerBouclier = get_node("HBoxContainer/Harry/HarryMenu/Background/Menu/VBoxContainer/GridContainer/SkillLancerBouclier")
onready var skillsHarrySoin = get_node("HBoxContainer/Harry/HarryMenu/Background/Menu/VBoxContainer/GridContainer/SkillSoin")
onready var skillsHarryDefense = get_node("HBoxContainer/Harry/HarryMenu/Background/Menu/VBoxContainer/GridContainer/SkillDefense")
onready var skillsHarryLancement = get_node("HBoxContainer/Harry/HarryMenu/Background/Menu/VBoxContainer/GridContainer/SkillLancement")
#De même, les boutons de skills de Flaux dans une variable pour agir sur leur focus plus tard
onready var skillsFlauxSeCacher = get_node("HBoxContainer/Flaux/FlauxMenu/Background/Menu/VBoxContainer/GridContainer/SkillSeCacher")
onready var skillsFlauxCoupPlongeant = get_node("HBoxContainer/Flaux/FlauxMenu/Background/Menu/VBoxContainer/GridContainer/SkillCoupPlongeant")
onready var skillsFlauxLabourage = get_node("HBoxContainer/Flaux/FlauxMenu/Background/Menu/VBoxContainer/GridContainer/SkillLabourage")
onready var skillsFlauxLaceration = get_node("HBoxContainer/Flaux/FlauxMenu/Background/Menu/VBoxContainer/GridContainer/SkillLaceration")
onready var skillsFlauxAffutage = get_node("HBoxContainer/Flaux/FlauxMenu/Background/Menu/VBoxContainer/GridContainer/SkillAffutage")

#Fonction qui se lance automatiquement à l'apparition de GeneralInterface
func _ready():
	#Ici on vide le contenu des descriptions des skills, utilisé car on a gardé un texte exemple sur l'interface
	$HBoxContainer/Harry.modifDesc("")
	$HBoxContainer/Flaux.modifDesc("")

#Fonction qui permet au joueur de sélectionner les actions qu'il souhaite faire
func choixTour():
	
	#On vérifie toujours si le personnage à assez de vie pour agir
	if($HBoxContainer/Harry.pv > 0):
		skillsHarryChargeBouclier.grab_focus() #met le curseur de menu sur le premier skill d'Harry
		
		#on attend qu'un des boutons de skills d'Harry soit pressé,
		#on continuera quand on aura reçu le signal "butPressed" de la scène Harry
		yield($HBoxContainer/Harry, "butPressed")
		
		#Permet de retirer le curseur tous les boutons d'Harry (le groupe "HarryButtons" contient chaque bouton d'Harry)
		get_tree().call_group("HarryButtons", "release_focus")
		$HBoxContainer/Harry.modifDesc("") #Une fois l'action choisie, on vide la description des actions
	
	if($HBoxContainer/Flaux.pv > 0):
		skillsFlauxSeCacher.grab_focus() #met le curseur de menu sur le premier skill de Flaux
		
		#de même on attend le signal "butPressed" mais pour la scène de Flaux
		yield($HBoxContainer/Flaux, "butPressed")
		
		#Permet de retirer le curseur tous les boutons de Flaux (le groupe "FlauxButtons" contient chaque bouton de Flaux)
		get_tree().call_group("FlauxButtons", "release_focus")
		$HBoxContainer/Flaux.modifDesc("") #Une fois l'action choisie, on vide la description des actions
	
	emit_signal("choixTourFini") #Permet d'avertir la scène de combat que le tour est terminé

#Fonction qui boucle à l'infini, elle est toujours actif tant que la scène est présente
func _delta_process():
	#En fonction d'où se situe le focus, on affiche un texte différent dans la description du personnage concerné
	if(skillsHarryChargeBouclier.has_focus()):
		$HBoxContainer/Harry.modifDesc("Ça c'est genre Charge de Bouclier tu sais le truc là")
	if(skillsHarryLancerBouclier.has_focus()):
		$HBoxContainer/Harry.modifDesc("Ici on a le Lancer de Bouclier, genre tu prends le bouclier, tu le lances et tout")
	if(skillsHarrySoin.has_focus()):
		$HBoxContainer/Harry.modifDesc("Mec insane, ça c'est un skill, tu soignes, mais genre Flaux et toi")
	if(skillsHarryDefense.has_focus()):
		$HBoxContainer/Harry.modifDesc("Alors là c'est autre chose, tu mets ton bouclier devant toi et tu prends moins de dégâts")
	if(skillsHarryLancement.has_focus()):
		$HBoxContainer/Harry.modifDesc("Il est rigolo lui, c'est genre tu boost Flaux et elle fait mal")
	
	if(skillsFlauxSeCacher.has_focus()):
		$HBoxContainer/Flaux.modifDesc("Faux vite se cacher !")
	if(skillsFlauxCoupPlongeant.has_focus()):
		$HBoxContainer/Flaux.modifDesc("En haut ! C'est faux ! Ma faux !")
	if(skillsFlauxLabourage.has_focus()):
		$HBoxContainer/Flaux.modifDesc("Tu vas voir ce que ça fait d'être fauché !")
	if(skillsFlauxLaceration.has_focus()):
		$HBoxContainer/Flaux.modifDesc("Vrai ou faux ? Ma vrai faux va vraiment de faucher. Faux pas vraiment réfléchir.")
	if(skillsFlauxAffutage.has_focus()):
		$HBoxContainer/Flaux.modifDesc("Faux vraiment que je prenne soin de ma Flaux, euh Faux, faut vraiment du coup...")

#Fonction reliée au signal "butPressed" d'Harry, elle s'active lorsqu'un bouton d'Harry est pressé
func _on_Harry_butPressed():
	
	#Des testes pour voir si "degatsPris(x)" fonctionne
	#$HBoxContainer/Harry.degatsPris(180)
	#$HBoxContainer/Flaux.degatsPris(0)
	pass

#Fonction reliée au signal "butPressed" de Flaux, elle s'active lorsqu'un bouton de Flaux est pressé
func _on_Flaux_butPressed():
	
	#Des testes pour voir si "degatsPris(x)" fonctionne
	#$HBoxContainer/Harry.pv = $HBoxContainer/Harry.pvmax #Pour remettre Harry full life et testé quand il regarde Flaux
	#$HBoxContainer/Harry.degatsPris(0)
	#$HBoxContainer/Flaux.degatsPris(160)
	#choixTour() #permet de tester plusieurs choix de tour d'affiler
	pass
