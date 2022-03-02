extends "res://Scenes/Dialogue.gd"

#Les constantes ici sont le chemin vers les fichiers contenant les dialogues

const dialogueTest = "res://text/FR/DialogueTest.json"
const dialogueTesten = "res://text/EN/Battle1/DialogBattle1Test.json"

#En français
const dialogue2IntroFR = "res://text/FR/Battle2/DialogBattle1Intro.json"
const dialogue2Hint1FR = "res://text/FR/Battle2/DialogBattle1Hint1.json"
const dialogue2Hint2FR = "res://text/FR/Battle2/DialogBattle1Hint2.json"
const dialogue2MidFR = "res://text/FR/Battle2/DialogBattle1Mid.json"
const dialogue2EndFR = "res://text/FR/Battle2/DialogBattle1End.json"

#En anglais
const dialogue2IntroEN = "res://text/EN/Battle2/DialogBattle1Intro.json"
const dialogue2Hint1EN = "res://text/EN/Battle2/DialogBattle1Hint1.json"
const dialogue2Hint2EN = "res://text/EN/Battle2/DialogBattle1Hint2.json"
const dialogue2MidEN = "res://text/EN/Battle2/DialogBattle1Mid.json"
const dialogue2EndEN = "res://text/EN/Battle2/DialogBattle1End.json"

#Dialogue pour tester
func dialogueTest():
	#En fonction du booléen de la langue on charge un chemin différent
	if(fr):
		dialogue_file = dialogueTest #déclaré au dessus: const dialogueTest = "res://text/FR/DialogueTest.json"
	elif(en):
		dialogue_file = dialogueTesten
	dialogueRead() #puis on lance la lecture du dialogue

func dialogueIntro():
	if(fr):
		dialogue_file = dialogue2IntroFR
	elif(en):
		dialogue_file = dialogue2IntroEN
	dialogueRead()

func dialogueHint1():
	if(fr):
		dialogue_file = dialogue2Hint1FR
	elif(en):
		dialogue_file = dialogue2Hint1EN
	dialogueRead()

func dialogueHint2():
	if(fr):
		dialogue_file = dialogue2Hint2FR
	elif(en):
		dialogue_file = dialogue2Hint2EN
	dialogueRead()

func dialogueMid():
	if(fr):
		dialogue_file = dialogue2MidFR
	elif(en):
		dialogue_file = dialogue2MidEN
	dialogueRead()

func dialogueEnd():
	if(fr):
		dialogue_file = dialogue2EndFR
	elif(en):
		dialogue_file = dialogue2EndEN
	dialogueRead()
