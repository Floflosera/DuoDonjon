extends MarginContainer

#variable utiliser pour énumérer un nombre de vérification dans une boucle
onready var i = 0

#Signal déclanché quand on finit le choix d'un tour
signal choixTourFini
signal choixCharaTourFini

onready var main = get_node("../../..")

#Les variables qui informe de si le jeu est en français ou anglais
onready var fr = main.fr
onready var en = main.en

#les personnages sont stockés dans des variables pour y accéder plus facilement
onready var cHarry = $HBoxContainer/Harry
onready var cFlaux = $HBoxContainer/Flaux
#le groupe d'ennemi est stocké aussi
onready var groupeEnnemi = get_node("../EnnemiGroup")
onready var premiereCible = false

#on initialise la variable qui informe qui est en train de cibler (si le personnage cible)
onready var kiCible = 0

#un booléen qui permet d'annuler le choix d'action d'Harry quand on est au choix de Flaux
onready var cFlauxFait = false

#Chaque skill a une variable qui stockera sa description qui s'affiche pendant le choix
var coupBouclierDesc
var lancerBouclierDesc
var soinDesc
var defenseDesc
var lancementDesc
#De même, les boutons de skills de Flaux dans une variable pour agir sur leur focus plus tard
var seCacherDesc
var coupPlongeantDesc
var labourageDesc
var lacerationDesc
var affutageDesc

#Fonction qui se lance automatiquement à l'apparition de GeneralInterface
func _ready():
	
	#Ici on vide le contenu des descriptions des skills, utilisé car on a gardé un texte exemple sur l'interface
	cHarry.modifDesc("")
	cFlaux.modifDesc("")
	
	load_skills() 						#lecture du fichier Skills.json pour le nom et la desc des skills
	cHarry.labelVieF()	#permet de mettre HP à la place de PV si le jeu est en anglais
	cFlaux.labelVieF()

#fonction qui permet de choisir les actions d'un tour du personnage mis en paramètre
func choixCharaTour(chara):
	
	#au début, on dit que le tour n'est pas encore choisi
	chara.tourChoisi = false
	
	#tant que le tour n'est pas choisi et qu'on n'annule pas le tour avec Flaux
	while(not(chara.tourChoisi) && not(chara.annuleF)):
		
		#On prend en focus le bouton 0 au début puis le dernier bouton choisi précédement
		chara.skills[chara.choixSkill].grab_focus()#met le curseur de menu sur le premier skill d'Harry
		
		#on attend qu'un des boutons de skills du perso soit pressé,
		#on continuera quand on aura reçu le signal "butPressed" du perso en paramètre
		yield(chara, "butPressed")
		
		#si on n'a pas annulé le tour avec Flaux
		if(not(chara.annuleF)):
			#en fonction du personnage, et donc de qui cible, on release le groupe de skills
			if(kiCible == 0):
				#Permet de retirer le curseur tous les boutons d'un personnage
				#(exemble : le groupe "HarryButtons" contient chaque bouton d'Harry)
				get_tree().call_group("HarryButtons", "release_focus")
			else:
				#Retirer le focus de tous les boutons empêche Flaux de faire grab_focus
				#parce que ça va trop vite
				get_tree().call_group("FlauxButtons", "release_focus")
			
			#si le personnage cible avec son attaque, alors
			if(chara.ciblage):
				if(not(cFlaux.multi)):
					#on nettoie les ciblages de l'ennemi pour éviter les problèmes si on annule l'action d'Harry
					#après sa sélection, seulement en solo car le soucis a lieu quand on annule avec Flaux
					get_tree().call_group("EnnemiGroupe", "clearCible")
				
				premiereCible = false
				
				for enn in groupeEnnemi.ennemis:
					if(enn.pv > 0):
						enn.selection.show() #on fait apparaître le bouton de ciblage
						if(not(premiereCible)):
							enn.selection.grab_focus() #on prend le focus du bouton de l'ennemi
							premiereCible = true
				
				#on attend une sélection ou une annulation
				yield(groupeEnnemi,"selectionne")
				#on enlève le focus et cache les infos précédemment afficher
				get_tree().call_group("EnnemiButton", "release_focus")
				get_tree().call_group("EnnemiButton", "hide")
				get_tree().call_group("LifeBarEnnemi", "hide")
				
				#On vérifie quel ennemi a été ciblé
				while(i < groupeEnnemi.ennemis.size() && not(groupeEnnemi.ennemis[i].ciblePar[kiCible])):
					i += 1
				#si un ennemi a été ciblé, on le fait cibler par le personnage
				if(i < groupeEnnemi.ennemis.size()):
					chara.cibler(groupeEnnemi.ennemis[i])
					chara.tourChoisi = true
				#sinon le ciblage n'a pas eu lieu et on retourne au début du tant que
				else:
					chara.ciblage = false
				#on remet i à 0 dans tous les cas
				i = 0
			#si on n'a pas cibler alors on ne peut pas annuler son action après coup (pas directement)
			else:
				chara.tourChoisi = true
	
	chara.modifDesc("") #Une fois l'action choisie, on vide la description des actions
	
	#quand on sort de la boucle, on vérifie si c'est parce que Flaux a annulé son tour
	if(chara.annuleF):
		#Le tour venant d'être choisi n'est pas encore effectué
		#donc on bouclera dans la fonction choixTour en disant que Flaux n'a pas fait son tour
		cFlauxFait = false
	
	emit_signal("choixCharaTourFini")

#Fonction qui permet au joueur de sélectionner les actions qu'il souhaite faire
func choixTour():
	
	cFlauxFait = false #booléen pour vérifier si Flaux annule l'action (donc faux de base)
	
	if(cFlaux.multi && cFlaux.pv > 0 && not(cFlaux.horsCombat)):
		cFlaux.fFait = false
		if(not(cFlaux.skill1.disabled)):
			cFlaux.skill1y = true
		else:
			cFlaux.skill2y = true
	
	if(cFlaux.horsCombat):
		cHarry.skills[4].disabled = true
	
	while(not(cFlauxFait)): #tant que Flaux n'a pas annulé l'action
		
		kiCible = 0 #premier personnage qui cible, Harry (utilisé pour cibler les ennemis, entre autres)
		
		#On vérifie toujours si le personnage à assez de vie pour agir
		if(cHarry.pv > 0 && not(cHarry.horsCombat)):
			choixCharaTour(cHarry)
			yield(self,"choixCharaTourFini")
		else:
			#pour être sûr que le tour dur au moins un petit temps et éviter d'envoyer un signal trop vite
			yield(cHarry.spriteAnim,"frame_changed")
		
		
		kiCible = 1 #premier personnage qui cible, Flaux
		#avant le tour de Flaux, on fait passer son annulation de tour à faux au cas où
		#le joueur appuie sur "cancel" avant le tour de Flaux
		cFlaux.annuleF = false
		
		if(cFlaux.pv > 0 && not(cFlaux.horsCombat) && not(cFlaux.multi)):
			cFlauxFait = true #s'il n'y a pas d'annulation alors ceci restera vrai
			choixCharaTour(cFlaux)
			yield(self,"choixCharaTourFini")
		else:
			#si Flaux n'a pas de vie alors on ne pourra pas annuler son tour
			#donc on sortira de la boucle directement
			cFlauxFait = true
			
			if(cFlaux.multi && cFlaux.pv > 0 && not(cFlaux.horsCombat)):
				if(not(cFlaux.fFait)):
					yield(cFlaux,"multiFait")
	
	#permet de rendre toutes les compétences réutilisables puis d'empêcher l'utilisation
	#de la compétence choisie ce tour pendant un tour
	cHarry.abled()
	cHarry.skills[cHarry.choixSkill].disabled = true
	cFlaux.abled()
	cFlaux.skills[cFlaux.choixSkill].disabled = true
	
	emit_signal("choixTourFini") #Permet d'avertir la scène de combat que le tour est terminé

#Fonction qui boucle à l'infini, elle est toujours actif tant que la scène est présente
func _process(delta):
	#En fonction d'où se situe le focus, on affiche un texte différent dans la description du personnage concerné
	if(cHarry.skill1.has_focus()):
		cHarry.modifDesc(coupBouclierDesc)
	if(cHarry.skill2.has_focus()):
		cHarry.modifDesc(lancerBouclierDesc)
	if(cHarry.skill3.has_focus()):
		cHarry.modifDesc(soinDesc)
	if(cHarry.skill4.has_focus()):
		cHarry.modifDesc(defenseDesc)
	if(cHarry.skill5.has_focus()):
		cHarry.modifDesc(lancementDesc)
	
	if(cFlaux.skill1.has_focus()):
		cFlaux.modifDesc(seCacherDesc)
	if(cFlaux.skill2.has_focus()):
		cFlaux.modifDesc(coupPlongeantDesc)
	if(cFlaux.skill3.has_focus()):
		cFlaux.modifDesc(labourageDesc)
	if(cFlaux.skill4.has_focus()):
		cFlaux.modifDesc(lacerationDesc)
	if(cFlaux.skill5.has_focus()):
		cFlaux.modifDesc(affutageDesc)

#La lecture des skills fonctionne d'une manière similaire à la lecture des dialogues dans un fichier
export(String, FILE, "*.json") var skill_file
var skills_keys = []
var skills_name = "" #Pour les skills on ne souhaite récupérer que les noms
var skills_desc = "" #les descriptions
var skills_text = "" #et ce qui est afficher au lancement de l'attaque
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
	skills_text = skills_keys[current].textSkill

#Permet de faire la lecture des lignes suivantes
func next_skills():
	current += 1
	skills_name = skills_keys[current].nameSkill
	skills_desc = skills_keys[current].descSkill
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
	cHarry.skill1.set_text(skills_name)
	coupBouclierDesc = skills_desc
	cHarry.skillTextAppend(skills_text)
	next_skills()
	cHarry.skill2.set_text(skills_name)
	lancerBouclierDesc = skills_desc
	cHarry.skillTextAppend(skills_text)
	next_skills()
	cHarry.skill3.set_text(skills_name)
	soinDesc = skills_desc
	cHarry.skillTextAppend(skills_text)
	next_skills()
	cHarry.skill4.set_text(skills_name)
	defenseDesc = skills_desc
	cHarry.skillTextAppend(skills_text)
	next_skills()
	cHarry.skill5.set_text(skills_name)
	lancementDesc = skills_desc
	cHarry.skillTextAppend(skills_text)
	
	#Continue la lecture pour les 5 compétences de Flaux
	next_skills()
	cFlaux.skill1.set_text(skills_name)
	seCacherDesc = skills_desc
	cFlaux.skillTextAppend(skills_text)
	next_skills()
	cFlaux.skill2.set_text(skills_name)
	coupPlongeantDesc = skills_desc
	cFlaux.skillTextAppend(skills_text)
	next_skills()
	cFlaux.skill3.set_text(skills_name)
	labourageDesc = skills_desc
	cFlaux.skillTextAppend(skills_text)
	next_skills()
	cFlaux.skill4.set_text(skills_name)
	lacerationDesc = skills_desc
	cFlaux.skillTextAppend(skills_text)
	next_skills()
	cFlaux.skill5.set_text(skills_name)
	affutageDesc = skills_desc
	cFlaux.skillTextAppend(skills_text)
