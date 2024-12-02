extends TouchScreenButton

# credits : https://www.youtube.com/watch?v=uGyEP2LUFPg


var radius = Vector2(shape.radius, shape.radius)
onready var boundary = get_parent().texture.get_size().x / 2
onready var node_name = get_parent().name
var all_joysticks = ["Mouvement", "Shooting"]

var return_accel = 20		# l'acceleration a laquelle le boutton revient au centre
var treshold = 5
var ongoing_drag = -1
# -1 pour false, tout le reste pour vrai et peut être utilisé pour autre chose
# tel que le temps restant à un pouvoir


func _process(delta):
	if ongoing_drag == -1:
		# 							le centre
		var pos_difference = (Vector2(0,0) - radius) - position	
		position += pos_difference * return_accel * delta
		

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var event_dist_from_centre = (event.position - get_parent().global_position).length()
		
		if (event_dist_from_centre <= boundary * global_scale.x or event.get_index() == ongoing_drag):
			if ongoing_drag == -1:
				if !check_pas_double_index(event):
					return
				
			# global_position = event.position  --> change rien (+ centrage en fct du scale)
			set_global_position(event.position - radius*global_scale)
			
			if get_button_pos().length() > boundary:
				# pas besoin de multiplier par scale car pas position global
				set_position(get_button_pos().normalized() * boundary - radius)
				# position ramené à (+/-1,+/-1) * radius du holder - radius du button pour centrer
			
			ongoing_drag = event.get_index()
			
		
			
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1
			
			
func get_button_pos():
	return position + radius
	
func get_ongoig_drag():
	return ongoing_drag


func get_value(analog):
	if analog:
		return get_button_pos() / Vector2(boundary, boundary)
	if get_button_pos().length() > treshold:
		return get_button_pos().normalized()
	return Vector2(0,0)
	
			

func check_pas_double_index(event):
	for nom in all_joysticks:
		if !node_name.begins_with(nom):
			if event.get_index() == get_parent().get_parent().get_node("%sJoystick"%nom).get_node(name).get_ongoig_drag():
				return false
	return true

