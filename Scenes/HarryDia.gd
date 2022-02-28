extends Node

#Permet de modifier le texte de sa boite de dialogue par le contenu de la variable "text"
func modifDia(text):
	$Background/Menu/VBoxContainer/MarginContainer/Dialogue.set_text(text)
