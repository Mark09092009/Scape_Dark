extends Control


@export var player_node: CharacterBody2D
@export var world_size: Vector2 = Vector2(0.0, 0.0) # Tamanho TOTAL do seu nível (mundo)
@export var map_size: Vector2 = Vector2(632.0, 376.0)    # O tamanho do TextureRect do minimapa


func _process(_delta: float) -> void:
	if player_node == null:
		return

	# 1. Obter a posição do jogador no mundo
	var player_pos_world: Vector2 = player_node.global_position


	# 2. Calcular a proporção de escala
	var scale_ratio: Vector2 = map_size / world_size
	
	# 3. Mapear a posição do mundo para a posição do minimapa
	# Multiplica a posição do Player pela Escala de Conversão
	var minimap_pos: Vector2 = player_pos_world * scale_ratio

	# 4. Aplicar a nova posição
	# Se este script estiver no ícone, a posição é relativa ao Minimap Container
	self.position = minimap_pos
	
	# 5. Manter o ícone dentro do contêiner (Opcional, mas recomendado)
	self.position.x = clampf(self.position.x, 0, map_size.x)
	self.position.y = clampf(self.position.y, 0, map_size.y)
