extends "res://Scenes/EnnemiGroup.gd"

onready var ennemi1 = get_node("Ennemi4-1")
onready var ennemi2 = get_node("Ennemi4-2")

func _ready():
	ennemis = [ennemi1, ennemi2]

func _on_Ennemi41_butPressed():
	ennemi1.ciblePar[interfaceGeneral.kiCible] = true
	emit_signal("selectionne")

func _on_Ennemi42_butPressed():
	ennemi2.ciblePar[interfaceGeneral.kiCible] = true
	emit_signal("selectionne")
