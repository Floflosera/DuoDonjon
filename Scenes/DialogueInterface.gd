extends MarginContainer

#Signal qui permet d'alerter de la fin d'un dialogue
signal dialogueFini

#Stockage du bouton de confirmation dans une variable
onready var confirmation = get_node("HBoxContainer/FlauxDia/FlauxMenu/Background/Menu/VBoxContainer/Confirm")

#Fonction pour créer une boite de texte pour Harry, Flaux, mettre leur émotion
func boiteDeDia(textHarry,spHarry,textFlaux,spFlaux):
	$HBoxContainer/HarryDia.modifDia(textHarry)
	$HBoxContainer/HarryDia.changerSprite(spHarry)
	$HBoxContainer/FlauxDia.modifDia(textFlaux)
	$HBoxContainer/FlauxDia.changerSprite(spFlaux)
	confirmation.grab_focus()
	

#Vide les boites initiales
func _ready():
	$HBoxContainer/HarryDia.modifDia("")
	$HBoxContainer/FlauxDia.modifDia("")

#Dialogue pour tester
func dialogueTest():
	boiteDeDia("Ça fonctionne ?",0,"",0)
	yield(confirmation, "pressed")
	boiteDeDia("",0,"Nan c'est pas poss... Quoi !?",0)
	yield(confirmation, "pressed")
	boiteDeDia("Faut croire.",0,"",0)
	yield(confirmation, "pressed")
	boiteDeDia("",0,"Trop bien !",1)
	yield(confirmation, "pressed")
	boiteDeDia("",0,"Wa j'ai même des réactions !",1)
	yield(confirmation, "pressed")
	boiteDeDia("",0,"Hmm...",2)
	yield(confirmation, "pressed")
	boiteDeDia("",0,"Hmmm...",3)
	yield(confirmation, "pressed")
	boiteDeDia("Il manque encore l'animation des textes...",3,"",4)
	yield(confirmation, "pressed")
	boiteDeDia("Mais c'est un bon début.",1,"",5)
	yield(confirmation, "pressed")
	boiteDeDia("Arrête Flaux.",2,"D'accord...",3)
	yield(confirmation, "pressed")
	emit_signal("dialogueFini")

func dialogueTest2():
	boiteDeDia("",1,"C'est fou que ça marche !",1)
	yield(confirmation, "pressed")
	boiteDeDia("Ouais c'est pas mal.",1,"",1)
	yield(confirmation, "pressed")
	emit_signal("dialogueFini")
