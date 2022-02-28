extends Control

#signal qui permet de savoir si une action a été sélectionnée
signal selectionne

#tableau d'ennemis d'un groupe
var ennemis

#stocke l'interface général dans une variable
onready var interfaceGeneral = get_node("../GeneralInterface")

#permet de quitter le ciblage sans sélectionner de cible
func _process(delta):
	if(Input.is_action_just_released("ui_cancel")):
		#si on appuie sur une touche d'annulation, on envoie le signal de sélection sans cibler
		#ce qui fera boucler le tant que du choix du tour
		emit_signal("selectionne")
