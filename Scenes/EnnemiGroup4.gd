extends "res://Scenes/EnnemiGroup.gd"

onready var ennemi1 = $Ennemi4_1
onready var ennemi2 = $Ennemi4_2

func _ready():
	ennemis = [ennemi1, ennemi2]

func _on_Ennemi4_1_butPressed():
	ennemi1.ciblePar[interfaceGeneral.kiCible] = true
	emit_signal("selectionne")

func _on_Ennemi4_2_butPressed():
	ennemi2.ciblePar[interfaceGeneral.kiCible] = true
	emit_signal("selectionne")
