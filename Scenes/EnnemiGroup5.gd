extends "res://Scenes/EnnemiGroup.gd"

onready var ennemi = $Ennemi5
onready var ennemib = $Ennemi5B
onready var ennemif = $Ennemi5F

func _ready():
	ennemis = [ennemi, ennemif, ennemib]

func _on_Ennemi5_butPressed():

	ennemi.ciblePar[interfaceGeneral.kiCible] = true
	emit_signal("selectionne")

func _on_Ennemi5_butPressedF():
	ennemi.ciblePar[1] = true

func _on_Ennemi5B_butPressed():

	ennemib.ciblePar[interfaceGeneral.kiCible] = true
	emit_signal("selectionne")

func _on_Ennemi5B_butPressedF():
	ennemib.ciblePar[1] = true

func _on_Ennemi5F_butPressed():

	ennemif.ciblePar[interfaceGeneral.kiCible] = true
	emit_signal("selectionne")

func _on_Ennemi5F_butPressedF():
	ennemif.ciblePar[1] = true
