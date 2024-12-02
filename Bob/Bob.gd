extends KinematicBody2D

var velocity = Vector2(0,0)
var HP = 2
var number = 1
const SPEED = 150
onready var parent_node = get_parent().get_parent().get_parent()
#onready var HP_container_path = get_parent().get_parent().get_parent().get_node("HPContainer")
#var full_hearth_texture = load("res://.import/full_heart.png-a78094567eb8de889592dc0050702833.stex")
#var empty_hearth_texture = load("res://.import/empty_heart.png-4a19e2548df129d7a6f89472aa5425ad.stex")
var analog = Global.analog
var allow_shooting = true
var joystick_value = Vector2.ZERO
signal perd_une_vie
signal need_joystick_input

# main logical loop for KinematicBody2D
func _physics_process(delta):
	emit_signal("need_joystick_input", number)
	print(joystick_value)
#	velocity = move_and_slide(joystick_value * SPEED)
	move_and_slide(joystick_value * SPEED)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if "Zombie" in collision.collider.name:
			collision.collider.queue_free()
			HP -= 1
			emit_signal("perd_une_vie", number, HP)
#			if HP > 0:
#
#				HP_container_path.get_node("Life%s"%(HP+1)).texture = empty_hearth_texture
#			if HP == 0:
#				get_tree().change_scene("res://Menus/StartMenu.tscn")
	
	# fct qui amène une valeur vers une valeur target selon un %
#	velocity.x = lerp(velocity.x, 0, 0.2)
#	velocity.y = lerp(velocity.y, 0, 0.2)
#
#	if abs(velocity.x) < 0.1:
#		velocity.x = 0
#	if abs(velocity.y) < 0.1:
#		velocity.y = 0

func change_joystick_value(new_value):
	joystick_value = new_value
	print(new_value)
	print(joystick_value)

func _on_ShootingTimer_timeout():
	allow_shooting = true
