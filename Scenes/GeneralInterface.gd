extends MarginContainer

#Signal déclanché quand on finit le choix d'un tour
signal choixTourFini

#Les variables qui informe de si le jeu est en français ou anglais
onready var fr = false
onready var en = true

#Tous les boutons de skills d'Harry sont stockés dans une variable pour agir sur leur focus plus tard
onready var skillsHarryChargeBouclier = get_node("HBoxContainer/Harry/HarryMenu/Background/Menu/VBoxContainer/GridContainer/SkillChargeBouclier")
#Et chaque skill a une variable qui stockera sa description qui s'affiche pendant le choix
var chargeBouclierDesc
onready var skillsHarryLancerBouclier = get_node("HBoxContainer/Harry/HarryMenu/Background/Menu/VBoxContainer/GridContainer/SkillLancerBouclier")
var lancerBouclierDesc
onready var skillsHarrySoin = get_node("HBoxContainer/Harry/HarryMenu/Background/Menu/VBoxContainer/GridContainer/SkillSoin")
var soinDesc
onready var skillsHarryDefense = get_node("HBoxContainer/Harry/HarryMenu/Background/Menu/VBoxContainer/GridContainer/SkillDefense")
var defenseDesc
onready var skillsHarryLancement = get_node("HBoxContainer/Harry/HarryMenu/Background/Menu/VBoxContainer/GridContainer/SkillLancement")
var lancementDesc
#De même, les boutons de skills de Flaux dans une variable pour agir sur leur focus plus tard
onready var skillsFlauxSeCacher = get_node("HBoxContainer/Flaux/FlauxMenu/Background/Menu/VBoxContainer/GridContainer/SkillSeCacher")
var seCacherDesc
onready var skillsFlauxCoupPlongeant = get_node("HBoxContainer/Flaux/FlauxMenu/Background/Menu/VBoxContainer/GridContainer/SkillCoupPlongeant")
var coupPlongeantDesc
onready var skillsFlauxLabourage = get_node("HBoxContainer/Flaux/FlauxMenu/Background/Menu/VBoxContainer/GridContainer/SkillLabourage")
var labourageDesc
onready var skillsFlauxLaceration = get_node("HBoxContainer/Flaux/FlauxMenu/Background/Menu/VBoxContainer/GridContainer/SkillLaceration")
var lacerationDesc
onready var skillsFlauxAffutage = get_node("HBoxContainer/Flaux/FlauxMenu/Background/Menu/VBoxContainer/GridContainer/SkillAffutage")
var affutageDesc

#Fonction qui se lance automatiquement à l'apparition de GeneralInterface
func _ready():
	#Ici on vide le contenu des descriptions des skills, utilisé car on a gardé un texte exemple sur l'interface
	$HBoxContainer/Harry.modifDesc("")
	$HBoxContainer/Flaux.modifDesc("")
	
	load_skills() 						#lecture du fichier Skills.json pour le nom et la desc des skills
	$HBoxContainer/Harry.labelVieF()	#permet de mettre HP à la place de PV si le jeu est en anglais
	$HBoxContainer/Flaux.labelVieF()

#Fonction qui permet au joueur de sélectionner les actions qu'il souhaite faire
func choixTour():
	
	#On vérifie toujours si le personnage à assez de vie pour agir
	if($HBoxContainer/Harry.pv > 0):
		skillsHarryChargeBouclier.grab_focus() #met le curseur de menu sur le premier skill d'Harry
		
		#on attend qu'un des boutons de skills d'Harry soit pressé,
		#on continuera quand on aura reçu le signal "butPressed" de la scène Harry
		yield($HBoxContainer/Harry, "butPressed")
		
		#Permet de retirer le curseur tous les boutons d'Harry (le groupe "HarryButtons" contient chaque bouton d'Harry)
		#get_tree().call_group("HarryButtons", "release_focus")
		$HBoxContainer/Harry.modifDesc("") #Une fois l'action choisie, on vide la description des actions
		$HBoxContainer/Harry.tourEffectue = false #Le tour venant d'être choisi n'est pas encore effectué
	
	if($HBoxContainer/Flaux.pv > 0):
		skillsFlauxSeCacher.grab_focus() #met le curseur de menu sur le premier skill de Flaux
		
		#de même on attend le signal "butPressed" mais pour la scène de Flaux
		yield($HBoxContainer/Flaux, "butPressed")
		
		#Permet de retirer le curseur tous les boutons de Flaux (le groupe "FlauxButtons" contient chaque bouton de Flaux)
		get_tree().call_group("FlauxButtons", "release_focus")
		$HBoxContainer/Flaux.modifDesc("") #Une fois l'action choisie, on vide la description des actions
		$HBoxContainer/Flaux.tourEffectue = false #Le tour venant d'être choisi n'est pas encore effectué
	
	emit_signal("choixTourFini") #Permet d'avertir la scène de combat que le tour est terminé

#Fonction qui boucle à l'infini, elle est toujours actif tant que la scène est présente
func _process(delta):
	#En fonction d'où se situe le focus, on affiche un texte différent dans la description du personnage concerné
	if(skillsHarryChargeBouclier.has_focus()):
		$HBoxContainer/Harry.modifDesc(chargeBouclierDesc)
	if(skillsHarryLancerBouclier.has_focus()):
		$HBoxContainer/Harry.modifDesc(lancerBouclierDesc)
	if(skillsHarrySoin.has_focus()):
		$HBoxContainer/Harry.modifDesc(soinDesc)
	if(skillsHarryDefense.has_focus()):
		$HBoxContainer/Harry.modifDesc(defenseDesc)
	if(skillsHarryLancement.has_focus()):
		$HBoxContainer/Harry.modifDesc(lancementDesc)
	
	if(skillsFlauxSeCacher.has_focus()):
		$HBoxContainer/Flaux.modifDesc(seCacherDesc)
	if(skillsFlauxCoupPlongeant.has_focus()):
		$HBoxContainer/Flaux.modifDesc(coupPlongeantDesc)
	if(skillsFlauxLabourage.has_focus()):
		$HBoxContainer/Flaux.modifDesc(labourageDesc)
	if(skillsFlauxLaceration.has_focus()):
		$HBoxContainer/Flaux.modifDesc(lacerationDesc)
	if(skillsFlauxAffutage.has_focus()):
		$HBoxContainer/Flaux.modifDesc(affutageDesc)

#La lecture des skills fonctionne d'une manière similaire à la lecture des dialogues dans un fichier
export(String, FILE, "*.json") var skill_file
var skills_keys = []
var skills_name = "" #Pour les skills on ne souhaite récupérer que les noms
var skills_desc = "" #et les descriptions
var current = 0

#Le chemin pour la lecture du fichier des compétences en français et en anglais
const skill_fileFR = "res://text/FR/Skills.json"
const skill_fileEN = "res://text/EN/Skills.json"

#Commence la lecture du fichier avec l'indexage
func start_skills():
	current = 0
	index_skills()
	skills_name = skills_keys[current].nameSkill
	skills_desc = skills_keys[current].descSkill

#Permet de faire la lecture des lignes suivantes
func next_skills():
	current += 1
	skills_name = skills_keys[current].nameSkill
	skills_desc = skills_keys[current].descSkill

#Indexe le fichier
func index_skills():
	var skills = load_fileSkills(skill_file)
	skills_keys.clear()
	for key in skills:
		skills_keys.append(skills[key])

#Charge le fichier à l'emplacement voulu
func load_fileSkills(file_path):
	var file = File.new()
	if file.file_exists(file_path):
		file.open(file_path, file.READ)
		var skills = parse_json(file.get_as_text())
		return skills

#Permet de lancer le chargement du fichier dans la langue souhaité puis de stocker la description
#des compétences et de remplacer le nom des boutons par ceux du fichier
func load_skills():
	#En fonction de la langue, prend un chemin différent
	if(fr):
		skill_file = skill_fileFR
	elif(en):
		skill_file = skill_fileEN
	#Charge le fichier
	load_fileSkills(skill_file)
	
	#Commence la lecture puis continue 4 fois pour les compétences d'Harry
	start_skills()
	skillsHarryChargeBouclier.set_text(skills_name)
	chargeBouclierDesc = skills_desc
	next_skills()
	skillsHarryLancerBouclier.set_text(skills_name)
	lancerBouclierDesc = skills_desc
	next_skills()
	skillsHarrySoin.set_text(skills_name)
	soinDesc = skills_desc
	next_skills()
	skillsHarryDefense.set_text(skills_name)
	defenseDesc = skills_desc
	next_skills()
	skillsHarryLancement.set_text(skills_name)
	lancementDesc = skills_desc
	
	#Continue la lecture pour les 5 compétences de Flaux
	next_skills()
	skillsFlauxSeCacher.set_text(skills_name)
	seCacherDesc = skills_desc
	next_skills()
	skillsFlauxCoupPlongeant.set_text(skills_name)
	coupPlongeantDesc = skills_desc
	next_skills()
	skillsFlauxLabourage.set_text(skills_name)
	labourageDesc = skills_desc
	next_skills()
	skillsFlauxLaceration.set_text(skills_name)
	lacerationDesc = skills_desc
	next_skills()
	skillsFlauxAffutage.set_text(skills_name)
	affutageDesc = skills_desc
