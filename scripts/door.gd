extends Area2D

var player_present = false

@export var next_level: String = ''
@export var numb_world = 0

func _ready() -> void:
	# Conecta o sinal de ENTRADA
	self.body_entered.connect(_on_body_entered)
	# NOVO: Conecta o sinal de SAÍDA
	self.body_exited.connect(_on_body_exited)
	

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		player_present = true
	# REMOVENDO o 'else: player_present = false' daqui
	# Isso garante que player_present SÓ seja false quando o corpo SAIR,
	# não quando outro corpo (não o Player) entrar.
		
# NOVO: Função que é chamada quando um corpo SAI da colisão
func _on_body_exited(body: Node2D):
	# Verifica se o corpo que saiu é o Player
	if body.name == "Player":
		player_present = false # O Player não está mais presente
		
func _change_scene():
	Global.score += 300
	if numb_world == 1:
		Global.time_world01 = Global.seconds_before
	elif numb_world == 2:
		Global.time_world02 = Global.seconds_before
	elif numb_world == 3:
		Global.time_world03 = Global.seconds_before
	else:
		Global.time_world04 = Global.seconds_before
		
	get_tree().call_deferred("change_scene_to_file", next_level)
