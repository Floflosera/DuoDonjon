extends "res://Scenes/EnnemiGroup.gd"

onready var ennemi = $Ennemi3

func _ready():
	ennemis = [ennemi]

#fonction qui s'active quand un bouton de "ennemi3" est pressé
func _on_Ennemi3_butPressed():
	#l'ennemi devient cibler par le personne qui cible actuellement dans generalInterface
	ennemi.ciblePar[interfaceGeneral.kiCible] = true
	#et on envoie le signal "selectionne" pour passer à la suite dans la fonction choixTour
	emit_signal("selectionne")
