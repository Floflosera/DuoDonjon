extends "res://Scenes/Dialogue.gd"

#En français
const dialogueIntroFR = "res://text/FR/Battle4/DialogBattleIntro.json"
const dialogueHint1FR = "res://text/FR/Battle4/DialogBattleHint1.json"
const dialogueEndFR = "res://text/FR/Battle4/DialogBattleEnd.json"

#En anglais
const dialogueIntroEN = "res://text/EN/Battle4/DialogBattleIntro.json"
const dialogueHint1EN = "res://text/EN/Battle4/DialogBattleHint1.json"
const dialogueEndEN = "res://text/EN/Battle4/DialogBattleEnd.json"

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

func dialogueEnd():
	if(fr):
		dialogue_file = dialogueEndFR
	elif(en):
		dialogue_file = dialogueEndEN
	dialogueRead()
