extends Area2D

var player_present = false

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		player_present = true
	else:
		player_present = false
		
func _change_scene():
	Global.score_total = Global.score + 10 * (Global.time_world01 + Global.time_world02 + Global.time_world03 + Global.time_world04 + Global.time_world05)
	print(Global.score_total)
	get_tree().change_scene_to_file("res://scenes/victury.tscn")
