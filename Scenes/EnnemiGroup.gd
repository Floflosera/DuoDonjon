extends Control

signal selectionne

var ennemis

onready var interfaceGeneral = get_node("../GeneralInterface")

func _process(delta):
	if(Input.is_action_just_released("ui_cancel")):
		emit_signal("selectionne")
