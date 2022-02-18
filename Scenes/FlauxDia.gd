extends HBoxContainer

onready var spriteAnim = get_node("FlauxPortrait/VBoxContainer/Cadre/FlauxSprite")

func modifDia(text):
	$FlauxMenu/Background/Menu/VBoxContainer/MarginContainer/Dialogue.set_text(text)

#Change le sprite en fonction du nombre entré en paramètre
func changerSprite(n):
	match n:
		0:
			spriteAnim.play("Neutre")
		1:
			spriteAnim.play("Contente")
		2:
			spriteAnim.play("Enervee")
		3:
			spriteAnim.play("Triste")
		4:
			spriteAnim.play("Inquiete")
		5:
			spriteAnim.play("Fatiguee")
		6:
			spriteAnim.play("Blessee")
		7:
			spriteAnim.play("KO")
