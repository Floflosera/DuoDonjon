extends "res://Scenes/Dialogue.gd"

#En français
const dialogue5IntroFR = "res://text/FR/Battle5/DialogBattle5Intro.json"
const dialogue5Hint1FR = "res://text/FR/Battle5/DialogBattle5Hint1.json"
const dialogue5Hint2FR = "res://text/FR/Battle5/DialogBattle5Hint2.json"
const dialogue5MidFR = "res://text/FR/Battle5/DialogBattle5Mid.json"
const dialogue5EndFR = "res://text/FR/Battle5/DialogBattle5End.json"

#En anglais
const dialogue5IntroEN = "res://text/EN/Battle5/DialogBattle5Intro.json"
const dialogue5Hint1EN = "res://text/EN/Battle5/DialogBattle5Hint1.json"
const dialogue5Hint2EN = "res://text/EN/Battle5/DialogBattle5Hint2.json"
const dialogue5MidEN = "res://text/EN/Battle5/DialogBattle5Mid.json"
const dialogue5EndEN = "res://text/EN/Battle5/DialogBattle5End.json"

func dialogueIntro():
	if(fr):
		dialogue_file = dialogue5IntroFR
	elif(en):
		dialogue_file = dialogue5IntroEN
	dialogueRead()

func dialogueHint1():
	if(fr):
		dialogue_file = dialogue5Hint1FR
	elif(en):
		dialogue_file = dialogue5Hint1EN
	dialogueRead()

func dialogueHint2():
	if(fr):
		dialogue_file = dialogue5Hint2FR
	elif(en):
		dialogue_file = dialogue5Hint2EN
	dialogueRead()

func dialogueMid():
	if(fr):
		dialogue_file = dialogue5MidFR
	elif(en):
		dialogue_file = dialogue5MidEN
	dialogueRead()

func dialogueEnd():
	if(fr):
		dialogue_file = dialogue5EndFR
	elif(en):
		dialogue_file = dialogue5EndEN
	dialogueRead()
