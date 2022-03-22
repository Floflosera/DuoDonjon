extends "res://Scenes/Dialogue.gd"

#Les constantes ici sont le chemin vers les fichiers contenant les dialogues

const dialogueTest = "res://text/FR/DialogueTest.json"
const dialogueTesten = "res://text/EN/Battle1/DialogBattle1Test.json"

#En français
const dialogueIntroFR = "res://text/FR/Battle2/DialogBattleIntro.json"
const dialogueHint1FR = "res://text/FR/Battle2/DialogBattleHint1.json"
const dialogueHint2FR = "res://text/FR/Battle2/DialogBattleHint2.json"
const dialogueStunFR = "res://text/FR/Battle2/DialogBattleStun.json"
const dialogueEndFR = "res://text/FR/Battle2/DialogBattleEnd.json"

#En anglais
const dialogueIntroEN = "res://text/EN/Battle2/DialogBattleIntro.json"
const dialogueHint1EN = "res://text/EN/Battle2/DialogBattleHint1.json"
const dialogueHint2EN = "res://text/EN/Battle2/DialogBattleHint2.json"
const dialogueStunEN = "res://text/EN/Battle2/DialogBattleStun.json"
const dialogueEndEN = "res://text/EN/Battle2/DialogBattleEnd.json"

#Dialogue pour tester
func dialogueTest():
	#En fonction du booléen de la langue on charge un chemin différent
	if(fr):
		dialogue_file = dialogueTest #déclaré au dessus: const dialogueTest = "res://text/FR/DialogueTest.json"
	elif(en):
		dialogue_file = dialogueTesten
	yield(main,"finiTransition")
	dialogueRead() #puis on lance la lecture du dialogue

func dialogueIntro():
	if(fr):
		dialogue_file = dialogueIntroFR
	elif(en):
		dialogue_file = dialogueIntroEN
	dialogueRead()

func dialogueHint1():
	if(fr):
		dialogue_file = dialogueHint1FR
	elif(en):
		dialogue_file = dialogueHint1EN
	dialogueRead()

func dialogueHint2():
	if(fr):
		dialogue_file = dialogueHint2FR
	elif(en):
		dialogue_file = dialogueHint2EN
	dialogueRead()

func dialogueStun():
	if(fr):
		dialogue_file = dialogueStunFR
	elif(en):
		dialogue_file = dialogueStunEN
	dialogueRead()

func dialogueEnd():
	if(fr):
		dialogue_file = dialogueEndFR
	elif(en):
		dialogue_file = dialogueEndEN
	dialogueRead()
