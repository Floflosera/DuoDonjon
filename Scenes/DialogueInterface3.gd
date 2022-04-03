extends "res://Scenes/Dialogue.gd"

#En français
const dialogueIntroFR = "res://text/FR/Battle3/DialogBattleIntro.json"
const dialogueHint1FR = "res://text/FR/Battle3/DialogBattleHint1.json"
const dialogueHint2FR = "res://text/FR/Battle3/DialogBattleHint2.json"
const dialogueEndFR = "res://text/FR/Battle3/DialogBattleEnd.json"
const dialogueFallFR = "res://text/FR/Battle3/DialogBattleFall.json"
const dialogueOutspeedFR = "res://text/FR/Battle3/DialogBattleOutspeed.json"

#En anglais
const dialogueIntroEN = "res://text/EN/Battle3/DialogBattleIntro.json"
const dialogueHint1EN = "res://text/EN/Battle3/DialogBattleHint1.json"
const dialogueHint2EN = "res://text/EN/Battle3/DialogBattleHint2.json"
const dialogueEndEN = "res://text/EN/Battle3/DialogBattleEnd.json"
const dialogueFallEN = "res://text/EN/Battle3/DialogBattleFall.json"
const dialogueOutspeedEN = "res://text/EN/Battle3/DialogBattleOutspeed.json"

func dialogueIntro():
	combat.discussionOst.play()
	if(fr):
		dialogue_file = dialogueIntroFR
	elif(en):
		dialogue_file = dialogueIntroEN
	yield(main,"finiTransition")
	dialogueRead()
	yield(self,"dialogueFini")
	combat.discussionOst.stop()
	
	combat.rencontreSE.play()
	yield(combat.rencontreSE,"finished")
	combat.timerActions.set_wait_time(0.5)
	combat.timerActions.start()
	yield(combat.timerActions,"timeout")
	combat.timerActions.set_wait_time(1.0)
	
	emit_signal("dialogueIntroFini")

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

func dialogueFall():
	if(fr):
		dialogue_file = dialogueFallFR
	elif(en):
		dialogue_file = dialogueFallEN
	dialogueRead()

func dialogueOutspeed():
	if(fr):
		dialogue_file = dialogueOutspeedFR
	elif(en):
		dialogue_file = dialogueOutspeedEN
	dialogueRead()
