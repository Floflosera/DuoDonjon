extends "EnnemiGroup.gd"

onready var ennemi = $Ennemi1_1
onready var ennemig = $Ennemi1_3
onready var ennemid = $Ennemi1_2

func _ready():
	ennemis = [ennemi, ennemig, ennemid]

func _on_Ennemi1_1_butPressed():

	ennemi.ciblePar[interfaceGeneral.kiCible] = true
	emit_signal("selectionne")

func _on_Ennemi1_butPressedF():
	ennemi.ciblePar[1] = true

func _on_Ennemi1_3_butPressed():

	ennemig.ciblePar[interfaceGeneral.kiCible] = true
	emit_signal("selectionne")

func _on_Ennemi1_3_butPressedF():
	ennemig.ciblePar[1] = true

func _on_Ennemi1_2_butPressed():

	ennemid.ciblePar[interfaceGeneral.kiCible] = true
	emit_signal("selectionne")

func _on_Ennemi1_2_butPressedF():
	ennemid.ciblePar[1] = true
