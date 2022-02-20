extends HBoxContainer

#Rien de spécialement nouveau ici, on peut changer le label du personnage et son sprite en fonction du paramètre

onready var spriteAnim = get_node("HarryPortrait/VBoxContainer/Cadre/HarrySprite")

#Permet de modifier le texte de sa boite de dialogue par le contenu de la variable "text"
func modifDia(text):
	$HarryMenu/Background/Menu/VBoxContainer/MarginContainer/Dialogue.set_text(text)

#Change le sprite en fonction du nombre entré en paramètre
func changerSprite(n):
	match n:
		0:
			spriteAnim.play("Neutre")
		1:
			spriteAnim.play("Content")
		2:
			spriteAnim.play("Enerve")
		3:
			spriteAnim.play("Triste")
		4:
			spriteAnim.play("Inquiet")
		5:
			spriteAnim.play("Fatigue")
		6:
			spriteAnim.play("Blesse")
		7:
			spriteAnim.play("KO")
