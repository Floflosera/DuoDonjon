extends "res://Scenes/Combattant.gd"

signal butPressed

onready var fr = true
onready var en = false

onready var combat = get_node("../..")

onready var selection = $Selection
onready var showDegats = $Degats

onready var ciblePar = [false,false]

onready var lacere = false

func degatsPris(degats):
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
	showDegats.set_bbcode("[center][wave freq=25]")
	emit_signal("degatsTermine")

func degatsPrisDef(degats):
	if(lacere):
		degatsPris(int((degats-defense)*1.25))
		return str((degats-defense)*1.25)
	else:
		degatsPris(degats-defense)
		return str(degats-defense)

func _ready():
	spriteAnim = self
	ennemi = true
	barreVie = $LifeBar
	load_skills()

func clearCible():
	ciblePar[0] = false
	ciblePar[1] = false

#Surcharge
func clearThings():
	lacere = false

#La lecture des skills fonctionne d'une manière similaire à la lecture des dialogues dans un fichier
export(String, FILE, "*.json") var skill_file
var skills_keys = []
var skills_name = "" #Pour les skills on ne souhaite récupérer que les noms
var skills_text = "" #et ce qui est afficher au lancement de l'attaque
var current = 0

#Le chemin pour la lecture du fichier des compétences en français et en anglais
const ennemiSkill_fileFR = "res://text/FR/EnnemisSkills.json"
const ennemiSkill_fileEN = "res://text/EN/EnnemisSkills.json"

#Commence la lecture du fichier avec l'indexage
func ligne_skills(ligne):
	current = ligne
	skills_name = skills_keys[current].nameSkill
	skills_text = skills_keys[current].textSkill

#Permet de faire la lecture des lignes suivantes
func next_skills():
	current += 1
	skills_name = skills_keys[current].nameSkill
	skills_text = skills_keys[current].textSkill

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

func load_skills():
	#En fonction de la langue, prend un chemin différent
	if(fr):
		skill_file = ennemiSkill_fileFR
	elif(en):
		skill_file = ennemiSkill_fileEN
	#Charge le fichier
	load_fileSkills(skill_file)
	index_skills()
