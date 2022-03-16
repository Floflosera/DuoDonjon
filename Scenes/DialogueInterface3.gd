extends "res://Scenes/Dialogue.gd"

#En français
const dialogueIntroFR = "res://text/FR/Battle3/DialogBattleIntro.json"
const dialogueHint1FR = "res://text/FR/Battle3/DialogBattleHint1.json"
const dialogueHint2FR = "res://text/FR/Battle3/DialogBattleHint2.json"
const dialogueEndFR = "res://text/FR/Battle3/DialogBattleEnd.json"

#En anglais
const dialogueIntroEN = "res://text/EN/Battle3/DialogBattleIntro.json"
const dialogueHint1EN = "res://text/EN/Battle3/DialogBattleHint1.json"
const dialogueHint2EN = "res://text/EN/Battle3/DialogBattleHint2.json"
const dialogueEndEN = "res://text/EN/Battle3/DialogBattleEnd.json"

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

func dialogueEnd():
	if(fr):
		dialogue_file = dialogueEndFR
	elif(en):
		dialogue_file = dialogueEndEN
	dialogueRead()
