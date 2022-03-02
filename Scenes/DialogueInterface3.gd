extends "res://Scenes/Dialogue.gd"

#En français
const dialogue3IntroFR = "res://text/FR/Battle3/DialogBattle3Intro.json"
const dialogue3Hint1FR = "res://text/FR/Battle3/DialogBattle3Hint1.json"
const dialogue3Hint2FR = "res://text/FR/Battle3/DialogBattle3Hint2.json"
const dialogue3MidFR = "res://text/FR/Battle3/DialogBattle3Mid.json"
const dialogue3EndFR = "res://text/FR/Battle3/DialogBattle3End.json"

#En anglais
const dialogue3IntroEN = "res://text/EN/Battle3/DialogBattle3Intro.json"
const dialogue3Hint1EN = "res://text/EN/Battle3/DialogBattle3Hint1.json"
const dialogue3Hint2EN = "res://text/EN/Battle3/DialogBattle3Hint2.json"
const dialogue3MidEN = "res://text/EN/Battle3/DialogBattle3Mid.json"
const dialogue3EndEN = "res://text/EN/Battle3/DialogBattle3End.json"

func dialogueIntro():
	if(fr):
		dialogue_file = dialogue3IntroFR
	elif(en):
		dialogue_file = dialogue3IntroEN
	dialogueRead()

func dialogueHint1():
	if(fr):
		dialogue_file = dialogue3Hint1FR
	elif(en):
		dialogue_file = dialogue3Hint1EN
	dialogueRead()

func dialogueHint2():
	if(fr):
		dialogue_file = dialogue3Hint2FR
	elif(en):
		dialogue_file = dialogue3Hint2EN
	dialogueRead()

func dialogueMid():
	if(fr):
		dialogue_file = dialogue3MidFR
	elif(en):
		dialogue_file = dialogue3MidEN
	dialogueRead()

func dialogueEnd():
	if(fr):
		dialogue_file = dialogue3EndFR
	elif(en):
		dialogue_file = dialogue3EndEN
	dialogueRead()
