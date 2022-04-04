extends "res://Scenes/Dialogue.gd"

onready var lucyDia = get_node("../EnnemiGroup/Ennemi5")

#En français
const dialogueIntroFR = "res://text/FR/Battle5/DialogBattleIntro.json"
const dialogueHint1FR = "res://text/FR/Battle5/DialogBattleHint1.json"
const dialogueHint2FR = "res://text/FR/Battle5/DialogBattleHint2.json"
const dialogueEndFR = "res://text/FR/Battle5/DialogBattleEnd.json"
const dialogueCounterFR = "res://text/FR/Battle5/DialogBattleCounter.json"
const dialogueEffectiveFR = "res://text/FR/Battle5/DialogBattleEffective.json"
const dialogueFallFR = "res://text/FR/Battle5/DialogBattleFall.json"
const dialogueGetRealFR = "res://text/FR/Battle5/DialogBattleGetReal.json"
const dialogueOneWeaponFR = "res://text/FR/Battle5/DialogBattleOneWeapon.json"
const dialogueOutspeedFR = "res://text/FR/Battle5/DialogBattleOutspeed.json"
const dialoguePhase2FR = "res://text/FR/Battle5/DialogBattlePhase2.json"
const dialogueWeaponsFR = "res://text/FR/Battle5/DialogBattleWeapons.json"

#En anglais
const dialogueIntroEN = "res://text/EN/Battle5/DialogBattleIntro.json"
const dialogueHint1EN = "res://text/EN/Battle5/DialogBattleHint1.json"
const dialogueHint2EN = "res://text/EN/Battle5/DialogBattleHint2.json"
const dialogueEndEN = "res://text/EN/Battle5/DialogBattleEnd.json"
const dialogueCounterEN = "res://text/EN/Battle5/DialogBattleCounter.json"
const dialogueEffectiveEN = "res://text/EN/Battle5/DialogBattleEffective.json"
const dialogueFallEN = "res://text/EN/Battle5/DialogBattleFall.json"
const dialogueGetRealEN = "res://text/EN/Battle5/DialogBattleGetReal.json"
const dialogueOneWeaponEN = "res://text/EN/Battle5/DialogBattleOneWeapon.json"
const dialogueOutspeedEN = "res://text/EN/Battle5/DialogBattleOutspeed.json"
const dialoguePhase2EN = "res://text/EN/Battle5/DialogBattlePhase2.json"
const dialogueWeaponsEN = "res://text/EN/Battle5/DialogBattleWeapons.json"

func dialogueIntro():
	combat.discussionOst.play()
	if(fr):
		dialogue_file = dialogueIntroFR
	elif(en):
		dialogue_file = dialogueIntroEN
	lucyDia.changerSpriteDia(2)
	yield(main,"finiTransition")
	dialogueReadL()
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
	dialogueReadL()

func dialogueHint2():
	if(fr):
		dialogue_file = dialogueHint2FR
	elif(en):
		dialogue_file = dialogueHint2EN
	dialogueReadL()

func dialogueEnd():
	combat.discussionOst.play()
	if(fr):
		dialogue_file = dialogueEndFR
	elif(en):
		dialogue_file = dialogueEndEN
	dialogueReadL()
	yield(self,"dialogueFini")
	combat.discussionOst.stop()

func dialogueCounter():
	if(fr):
		dialogue_file = dialogueCounterFR
	elif(en):
		dialogue_file = dialogueCounterEN
	dialogueReadL()

func dialogueEffective():
	if(fr):
		dialogue_file = dialogueEffectiveFR
	elif(en):
		dialogue_file = dialogueEffectiveEN
	dialogueReadL()

func dialogueFall():
	if(fr):
		dialogue_file = dialogueFallFR
	elif(en):
		dialogue_file = dialogueFallEN
	dialogueReadL()

func dialogueGetReal():
	if(fr):
		dialogue_file = dialogueGetRealFR
	elif(en):
		dialogue_file = dialogueGetRealEN
	dialogueReadL()

func dialogueOneWeapon():
	if(fr):
		dialogue_file = dialogueOneWeaponFR
	elif(en):
		dialogue_file = dialogueOneWeaponEN
	dialogueReadL()

func dialogueOutspeed():
	if(fr):
		dialogue_file = dialogueOutspeedFR
	elif(en):
		dialogue_file = dialogueOutspeedEN
	dialogueReadL()

func dialoguePhase2():
	if(fr):
		dialogue_file = dialoguePhase2FR
	elif(en):
		dialogue_file = dialoguePhase2EN
	dialogueReadL()

func dialogueWeapons():
	if(fr):
		dialogue_file = dialogueWeaponsFR
	elif(en):
		dialogue_file = dialogueWeaponsEN
	dialogueReadL()

func dialogueReadL():
	start_dialogueL()
	
	lucyDia.changerSpriteDia(dialogue_spLucy)
	if(dialogue_cadreN == ""):
		boiteDeDiaAnim(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux,dialogue_supOther)
	else:
		narraRead(dialogue_spHarry, dialogue_spFlaux, dialogue_cadreN)
	yield(self, "dialogueSuivant")
	
	while(current < dialogue_keys.size()-1): #tant qu'on n'est pas à la fin du fichier
		next_dialogueL() #on passe on dialogue suivant
		
		lucyDia.changerSpriteDia(dialogue_spLucy)
		if(dialogue_devent != 0):
			if(dialogue_devent == 1):
				get_node("../EnnemiGroup").show()
			elif(dialogue_devent == 2):
				if(get_node("../Barreaux") != null):
					if(get_node("../Barreaux").visible):
						get_node("../Barreaux").hide()
					else:
						get_node("../Barreaux").show()
		if(dialogue_textHarry != "" || dialogue_textFlaux != ""):
			boiteDeDiaAnim(dialogue_textHarry,dialogue_spHarry,dialogue_textFlaux,dialogue_spFlaux,dialogue_supOther)
			yield(self, "dialogueSuivant")
		elif(dialogue_cadreN != ""):
			narraRead(dialogue_spHarry, dialogue_spFlaux, dialogue_cadreN)
			yield(self, "dialogueSuivant")
	
	emit_signal("dialogueFini") #quand cette fonction se termine, émet le signal "dialogueFini"
