extends Control

signal selectionne

var ennemis

onready var interfaceGeneral = get_node("../GeneralInterface")

func invisibleButton():
	for e in ennemis:
		e.selection.visible = false

func visibleButton():
	for e in ennemis:
		e.selection.visible = true
