extends MarginContainer

#Signal déclanché quand on finit le choix d'un tour
signal choixTourFini

#Les variables qui informe de si le jeu est en français ou anglais
onready var fr = true
onready var en = false

#Tous les boutons de skills d'Harry sont stockés dans une variable pour agir sur leur focus plus tard
onready var skillsHarry1 = $HBoxContainer/Harry/CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill1
#Et chaque skill a une variable qui stockera sa description qui s'affiche pendant le choix
var coupBouclierDesc
onready var skillsHarry2 = $HBoxContainer/Harry/CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill2
var lancerBouclierDesc
onready var skillsHarry3 = $HBoxContainer/Harry/CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill3
var soinDesc
onready var skillsHarry4 = $HBoxContainer/Harry/CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill4
var defenseDesc
onready var skillsHarry5 = $HBoxContainer/Harry/CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill5
var lancementDesc
#De même, les boutons de skills de Flaux dans une variable pour agir sur leur focus plus tard
onready var skillsFlaux1 = $HBoxContainer/Flaux/CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill1
var seCacherDesc
onready var skillsFlaux2 = $HBoxContainer/Flaux/CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill2
var coupPlongeantDesc
onready var skillsFlaux3 = $HBoxContainer/Flaux/CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill3
var labourageDesc
onready var skillsFlaux4 = $HBoxContainer/Flaux/CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill4
var lacerationDesc
onready var skillsFlaux5 = $HBoxContainer/Flaux/CadreMenu/Background/Menu/VBoxContainer/GridContainer/Skill5
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
		skillsHarry1.grab_focus() #met le curseur de menu sur le premier skill d'Harry
		
		#on attend qu'un des boutons de skills d'Harry soit pressé,
		#on continuera quand on aura reçu le signal "butPressed" de la scène Harry
		yield($HBoxContainer/Harry, "butPressed")
		
		#Permet de retirer le curseur tous les boutons d'Harry (le groupe "HarryButtons" contient chaque bouton d'Harry)
		get_tree().call_group("HarryButtons", "release_focus")
		$HBoxContainer/Harry.modifDesc("") #Une fois l'action choisie, on vide la description des actions
		$HBoxContainer/Harry.tourEffectue = false #Le tour venant d'être choisi n'est pas encore effectué
	
	if($HBoxContainer/Flaux.pv > 0):
		skillsFlaux1.grab_focus() #met le curseur de menu sur le premier skill de Flaux
		
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
	if(skillsHarry1.has_focus()):
		$HBoxContainer/Harry.modifDesc(coupBouclierDesc)
	if(skillsHarry2.has_focus()):
		$HBoxContainer/Harry.modifDesc(lancerBouclierDesc)
	if(skillsHarry3.has_focus()):
		$HBoxContainer/Harry.modifDesc(soinDesc)
	if(skillsHarry4.has_focus()):
		$HBoxContainer/Harry.modifDesc(defenseDesc)
	if(skillsHarry5.has_focus()):
		$HBoxContainer/Harry.modifDesc(lancementDesc)
	
	if(skillsFlaux1.has_focus()):
		$HBoxContainer/Flaux.modifDesc(seCacherDesc)
	if(skillsFlaux2.has_focus()):
		$HBoxContainer/Flaux.modifDesc(coupPlongeantDesc)
	if(skillsFlaux3.has_focus()):
		$HBoxContainer/Flaux.modifDesc(labourageDesc)
	if(skillsFlaux4.has_focus()):
		$HBoxContainer/Flaux.modifDesc(lacerationDesc)
	if(skillsFlaux5.has_focus()):
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
	skillsHarry1.set_text(skills_name)
	coupBouclierDesc = skills_desc
	next_skills()
	skillsHarry2.set_text(skills_name)
	lancerBouclierDesc = skills_desc
	next_skills()
	skillsHarry3.set_text(skills_name)
	soinDesc = skills_desc
	next_skills()
	skillsHarry4.set_text(skills_name)
	defenseDesc = skills_desc
	next_skills()
	skillsHarry5.set_text(skills_name)
	lancementDesc = skills_desc
	
	#Continue la lecture pour les 5 compétences de Flaux
	next_skills()
	skillsFlaux1.set_text(skills_name)
	seCacherDesc = skills_desc
	next_skills()
	skillsFlaux2.set_text(skills_name)
	coupPlongeantDesc = skills_desc
	next_skills()
	skillsFlaux3.set_text(skills_name)
	labourageDesc = skills_desc
	next_skills()
	skillsFlaux4.set_text(skills_name)
	lacerationDesc = skills_desc
	next_skills()
	skillsFlaux5.set_text(skills_name)
	affutageDesc = skills_desc
