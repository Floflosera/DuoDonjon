extends "res://Scenes/EnnemiGroup.gd"

onready var ennemi = $Ennemi2

func _ready():
	ennemis = [ennemi]

func _on_Ennemi2_butPressed():
	ennemi.ciblePar[interfaceGeneral.kiCible] = true
	emit_signal("selectionne")
