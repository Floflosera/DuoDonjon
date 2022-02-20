extends AnimatedSprite

#Statistiques de l'ennemi
export var pvmax = 500
export var pv = 500
export var defense = 2
export var vitesse = 3

var choixSkill #là où sera stocké son choix de skill
onready var priorite = false #pas sûr que l'ennemi puisse faire une attaque prioritaire mais la fonction vérifie ça
