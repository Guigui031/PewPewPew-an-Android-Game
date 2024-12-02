extends Node2D

onready var bob = preload("res://Bob/Bob.tscn")
onready var bullet = preload("res://Bob/Bullet.tscn")
onready var zombie = preload("res://Enemies/Zombie.tscn")
onready var parent_node = get_parent().get_parent()
#onready var shooting_joystick = get_parent().get_parent().get_node("ShootingJoystick/JoystickButton")
var empty_hearth_texture = load("res://.import/empty_heart.png-4a19e2548df129d7a6f89472aa5425ad.stex")

var rng = RandomNumberGenerator.new()
var players = []
var total_zombies_spawn = 0
onready var dist_max = 576

func _ready():
	for pl in Global.nb_players:
		var new_bob = bob.instance()
		players.append(new_bob)
		new_bob.number = pl	+ 1

func _process(delta):
#	if Input.is_action_just_pressed("shoot"):
	for player in players:
		if player.allow_shooting:
			var value_shooting_joystick = parent_node.get_node("Player%s" % player.number).get_node("ShootingJoystick/JoystickButton").get_value(false)
			if value_shooting_joystick:
				var new_bullet = bullet.instance()
				add_child(new_bullet)
				#	plus tard, la direction du joystick
	#			new_bullet.on_creation(joueur.position, value_shooting_joystick)
				new_bullet.on_creation(player.position, value_shooting_joystick)
				player.allow_shooting = false
				player.get_node("ShootingTimer").start()

func _physics_process(delta):
	for player in players:
#		player.manual_physic_process(parent_node.get_node("Player%s" % player.number).get_node("MouvementJoystick/JoystickButton"))
#		player.manual_physic_process(parent_node.get_node("Player%s" % player.number).get_node("MouvementJoystick/JoystickButton"), delta)
		pass

func trouver_joueur_le_plus_proche(pos_zombie):
#	var dist = dist_max - pos_zombie.x
#	for player in players:
#		dist = min(dist, pos_zombie.x - player.position.x)
	var dist = pos_zombie - players[0].position
	for player in players:
		if dist == pos_zombie - player.position: 
			return player.position
		

func _on_SpawnTimer_timeout():
	var new_zombie = zombie.instance()
	add_child(new_zombie)
#	new_zombie.position = Vector2(get_viewport_rect().size.x/2, 64)
	rng.randomize()
	var my_random_number = rng.randi_range(1, 4)
	new_zombie.position = get_node("SpawnPositions/EnemySpawn%s" % my_random_number).position
	total_zombies_spawn += 1
	if total_zombies_spawn % 10:
		$SpawnTimer.wait_time *= 0.9

func _on_Bob_perd_une_vie(pl_nb, HP):
	if HP > 0:		
		parent_node.get_node("Player%s" % pl_nb).get_node("HPContainer").get_node("Life%s"%(HP+1)).texture = empty_hearth_texture
	if HP == 0:
		get_tree().change_scene("res://Menus/StartMenu.tscn")


func _on_Bob_need_joystick_input(pl_nb):
	var joystick_value = parent_node.get_node("Player%s" % pl_nb).get_node("MouvementJoystick/JoystickButton").get_value(false)
	players[pl_nb-1].change_joystick_value(joystick_value)
	print(joystick_value)
