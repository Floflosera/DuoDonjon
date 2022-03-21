extends "Dialogue.gd"

#En français
const dialogueIntroFR = "res://text/FR/Battle1/DialogBattleIntro.json"
const dialogueHint1FR = "res://text/FR/Battle1/DialogBattleHint1.json"
const dialogueHint2FR = "res://text/FR/Battle1/DialogBattleHint2.json"
const dialogueBroken1FR = "res://text/FR/Battle1/DialogBattleBroken1.json"
const dialogueBroken2FR = "res://text/FR/Battle1/DialogBattleBroken2.json"
const dialogueEndFR = "res://text/FR/Battle1/DialogBattleEnd.json"

#En anglais
const dialogueIntroEN = "res://text/EN/Battle1/DialogBattleIntro.json"
const dialogueHint1EN = "res://text/EN/Battle1/DialogBattleHint1.json"
const dialogueHint2EN = "res://text/EN/Battle1/DialogBattleHint2.json"
const dialogueBroken1EN = "res://text/EN/Battle1/DialogBattleBroken1.json"
const dialogueBroken2EN = "res://text/EN/Battle1/DialogBattleBroken2.json"
const dialogueEndEN = "res://text/EN/Battle1/DialogBattleEnd.json"

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
	
func dialogueBroken1():
	if(fr):
		dialogue_file = dialogueBroken1FR
	elif(en):
		dialogue_file = dialogueBroken1EN
	dialogueRead()
	
func dialogueBroken2():
	if(fr):
		dialogue_file = dialogueBroken2FR
	elif(en):
		dialogue_file = dialogueBroken2EN
	dialogueRead()

func dialogueEnd():
	if(fr):
		dialogue_file = dialogueEndFR
	elif(en):
		dialogue_file = dialogueEndEN
	dialogueRead()
