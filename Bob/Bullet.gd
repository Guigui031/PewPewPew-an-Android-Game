extends KinematicBody2D


var direction = Vector2(0,-1)
var velocity = Vector2(0,0)
const SPEED = 150


func on_creation(start_pos, dir):
	position = start_pos
	direction = dir		# vector2 de la direction
	velocity += direction * SPEED
	print("lol")


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		if "Zombie" in collision.collider.name:
			collision.collider.queue_free()
		queue_free()
