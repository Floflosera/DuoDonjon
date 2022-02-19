extends MarginContainer

signal choixTourFini

onready var fr = true
onready var en = false

#Tous les boutons de skills d'Harry sont stockés dans une variable pour agir sur leur focus plus tard
onready var skillsHarryChargeBouclier = get_node("HBoxContainer/Harry/HarryMenu/Background/Menu/VBoxContainer/GridContainer/SkillChargeBouclier")
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
		$HBoxContainer/Harry.tourEffectue = false
	
	if($HBoxContainer/Flaux.pv > 0):
		skillsFlauxSeCacher.grab_focus() #met le curseur de menu sur le premier skill de Flaux
		
		#de même on attend le signal "butPressed" mais pour la scène de Flaux
		yield($HBoxContainer/Flaux, "butPressed")
		
		#Permet de retirer le curseur tous les boutons de Flaux (le groupe "FlauxButtons" contient chaque bouton de Flaux)
		get_tree().call_group("FlauxButtons", "release_focus")
		$HBoxContainer/Flaux.modifDesc("") #Une fois l'action choisie, on vide la description des actions
		$HBoxContainer/Flaux.tourEffectue = false
	
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

#Fonction reliée au signal "butPressed" d'Harry, elle s'active lorsqu'un bouton d'Harry est pressé
func _on_Harry_butPressed():
	
	#Des testes pour voir si "degatsPris(x)" fonctionne
	#$HBoxContainer/Harry.degatsPris(300)
	#$HBoxContainer/Flaux.degatsPris(0)
	pass

#Fonction reliée au signal "butPressed" de Flaux, elle s'active lorsqu'un bouton de Flaux est pressé
func _on_Flaux_butPressed():
	
	#Des testes pour voir si "degatsPris(x)" fonctionne
	#$HBoxContainer/Harry.pv = $HBoxContainer/Harry.pvmax #Pour remettre Harry full life et testé quand il regarde Flaux
	#$HBoxContainer/Harry.degatsPris(0)
	#$HBoxContainer/Flaux.degatsPris(300)
	#choixTour() #permet de tester plusieurs choix de tour d'affiler
	pass

export(String, FILE, "*.json") var skill_file
var skills_keys = []
var skills_name = ""
var skills_desc = ""
var current = 0

const skill_fileFR = "res://text/FR/Skills.json"
const skill_fileEN = "res://text/EN/Skills.json"

func start_skills():
	current = 0
	index_skills()
	skills_name = skills_keys[current].nameSkill
	skills_desc = skills_keys[current].descSkill


func next_skills():
	current += 1
	skills_name = skills_keys[current].nameSkill
	skills_desc = skills_keys[current].descSkill


func index_skills():
	var skills = load_fileSkills(skill_file)
	skills_keys.clear()
	for key in skills:
		skills_keys.append(skills[key])


func load_fileSkills(file_path):
	var file = File.new()
	if file.file_exists(file_path):
		file.open(file_path, file.READ)
		var skills = parse_json(file.get_as_text())
		return skills

func load_skills():
	if(fr):
		skill_file = skill_fileFR
	elif(en):
		skill_file = skill_fileEN
	load_fileSkills(skill_file)
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
