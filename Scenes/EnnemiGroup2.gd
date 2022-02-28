extends "res://Scenes/EnnemiGroup.gd"

#stocke les ennemis du combats dans des variables
onready var ennemi = $Ennemi2

#puis met ces ennemis dans le tableau ennemis
func _ready():
	ennemis = [ennemi]

#fonction qui s'active quand un bouton de "ennemi2" est pressé
func _on_Ennemi2_butPressed():
	#l'ennemi devient cibler par le personne qui cible actuellement dans generalInterface
	ennemi.ciblePar[interfaceGeneral.kiCible] = true
	#et on envoie le signal "selectionne" pour passer à la suite dans la fonction choixTour
	emit_signal("selectionne")
