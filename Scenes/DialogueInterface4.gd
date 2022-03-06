extends "res://Scenes/Dialogue.gd"

#En français
const dialogue4IntroFR = "res://text/FR/Battle4/DialogBattle4Intro.json"
const dialogue4Hint1FR = "res://text/FR/Battle4/DialogBattle4Hint1.json"
const dialogue4Hint2FR = "res://text/FR/Battle4/DialogBattle4Hint2.json"
const dialogue4MidFR = "res://text/FR/Battle4/DialogBattle4Mid.json"
const dialogue4EndFR = "res://text/FR/Battle4/DialogBattle4End.json"

#En anglais
const dialogue4IntroEN = "res://text/EN/Battle4/DialogBattle4Intro.json"
const dialogue4Hint1EN = "res://text/EN/Battle4/DialogBattle4Hint1.json"
const dialogue4Hint2EN = "res://text/EN/Battle4/DialogBattle4Hint2.json"
const dialogue4MidEN = "res://text/EN/Battle4/DialogBattle4Mid.json"
const dialogue4EndEN = "res://text/EN/Battle4/DialogBattle4End.json"

func dialogueIntro():
	if(fr):
		dialogue_file = dialogue4IntroFR
	elif(en):
		dialogue_file = dialogue4IntroEN
	dialogueRead()

func dialogueHint1():
	if(fr):
		dialogue_file = dialogue4Hint1FR
	elif(en):
		dialogue_file = dialogue4Hint1EN
	dialogueRead()

func dialogueHint2():
	if(fr):
		dialogue_file = dialogue4Hint2FR
	elif(en):
		dialogue_file = dialogue4Hint2EN
	dialogueRead()

func dialogueMid():
	if(fr):
		dialogue_file = dialogue4MidFR
	elif(en):
		dialogue_file = dialogue4MidEN
	dialogueRead()

func dialogueEnd():
	if(fr):
		dialogue_file = dialogue4EndFR
	elif(en):
		dialogue_file = dialogue4EndEN
	dialogueRead()
