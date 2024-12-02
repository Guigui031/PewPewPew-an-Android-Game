extends ColorRect

onready var analog = Global.analog


func _ready():
	$Popup/CheckButton.pressed = analog


func _on_OptionButton_pressed():
	$Popup.visible = not $Popup.visible


func _on_StartButton_pressed():
	Global.analog = analog
	Global.nb_players = 1
	get_tree().change_scene("res://Main/Main.tscn")


func _on_CheckButton_pressed():
	analog = not analog


func _on_StartButton2_pressed():
	Global.analog = analog
	Global.nb_players = 2
	get_tree().change_scene("res://Main/2players_Main.tscn")
