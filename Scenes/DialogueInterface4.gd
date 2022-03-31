extends "res://Scenes/Dialogue.gd"

#En français
const dialogueIntroFR = "res://text/FR/Battle4/DialogBattleIntro.json"
const dialogueHint1FR = "res://text/FR/Battle4/DialogBattleHint1.json"
const dialogueHint2FR = "res://text/FR/Battle4/DialogBattleHint2.json"
const dialogueEndFR = "res://text/FR/Battle4/DialogBattleEnd.json"
const dialogueBlackDefeatFR = "res://text/FR/Battle4/DialogBattleBlackDefeat.json"
const dialogueFlauxCaptureFR = "res://text/FR/Battle4/DialogBattleFlauxCapture.json"
const dialogueFlauxWillOWispFR = "res://text/FR/Battle4/DialogBattleFlauxWillOWisp.json"
const dialogueHarryCaptureFR = "res://text/FR/Battle4/DialogBattleHarryCapture.json"
const dialogueHarryWillOWispFR = "res://text/FR/Battle4/DialogBattleHarryWillOWisp.json"
const dialogueWhiteDefeatFR = "res://text/FR/Battle4/DialogBattleWhiteDefeat.json"

#En anglais
const dialogueIntroEN = "res://text/EN/Battle4/DialogBattleIntro.json"
const dialogueHint1EN = "res://text/EN/Battle4/DialogBattleHint1.json"
const dialogueHint2EN = "res://text/EN/Battle4/DialogBattleHint2.json"
const dialogueEndEN = "res://text/EN/Battle4/DialogBattleEnd.json"
const dialogueBlackDefeatEN = "res://text/EN/Battle4/DialogBattleBlackDefeat.json"
const dialogueFlauxCaptureEN = "res://text/EN/Battle4/DialogBattleFlauxCapture.json"
const dialogueFlauxWillOWispEN = "res://text/EN/Battle4/DialogBattleFlauxWillOWisp.json"
const dialogueHarryCaptureEN = "res://text/EN/Battle4/DialogBattleHarryCapture.json"
const dialogueHarryWillOWispEN = "res://text/EN/Battle4/DialogBattleHarryWillOWisp.json"
const dialogueWhiteDefeatEN = "res://text/EN/Battle4/DialogBattleWhiteDefeat.json"

func dialogueIntro():
	if(fr):
		dialogue_file = dialogueIntroFR
	elif(en):
		dialogue_file = dialogueIntroEN
	HarryDia.changerSpriteDia(2)
	yield(main,"finiTransition")
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

func dialogueBlackDefeat():
	if(fr):
		dialogue_file = dialogueBlackDefeatFR
	elif(en):
		dialogue_file = dialogueBlackDefeatEN
	dialogueRead()

func dialogueFlauxCapture():
	if(fr):
		dialogue_file = dialogueFlauxCaptureFR
	elif(en):
		dialogue_file = dialogueFlauxCaptureEN
	dialogueRead()

func dialogueFlauxWillOWisp():
	if(fr):
		dialogue_file = dialogueFlauxWillOWispFR
	elif(en):
		dialogue_file = dialogueFlauxWillOWispEN
	dialogueRead()

func dialogueHarryCapture():
	if(fr):
		dialogue_file = dialogueHarryCaptureFR
	elif(en):
		dialogue_file = dialogueHarryCaptureEN
	dialogueRead()

func dialogueHarryWillOWisp():
	if(fr):
		dialogue_file = dialogueHarryWillOWispFR
	elif(en):
		dialogue_file = dialogueHarryWillOWispEN
	dialogueRead()

func dialogueWhiteDefeat():
	if(fr):
		dialogue_file = dialogueWhiteDefeatFR
	elif(en):
		dialogue_file = dialogueWhiteDefeatEN
	dialogueRead()
