extends KinematicBody2D

const SPEED = 100
var direction_joueur = Vector2()


func _physics_process(delta):
	direction_joueur = trouver_joueur()
	move_and_slide(direction_joueur * SPEED)

func trouver_joueur():
	# prendre le joueur le plus proche
	var position_joueur = get_parent().trouver_joueur_le_plus_proche(position)
	return (position_joueur - position).normalized()
