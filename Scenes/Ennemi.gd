extends "res://Scenes/Combattant.gd"

signal butPressed

onready var selection = $Selection

onready var ciblePar = [false,false]

func _ready():
	spriteAnim = self
	ennemi = true

func clearCible():
	ciblePar[0] = false
	ciblePar[1] = false

