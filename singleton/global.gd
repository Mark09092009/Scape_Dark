extends Node

var destination_level: String = ""

var score := 0
var life := 3
var seconds_before := 0

# Variável para rastrear o MUNDO ATUAL (necessário para a lógica de morte)
var current_world: int = 0 

var time_world01 = 0
var time_world02 = 0
var time_world03 = 0
var time_world04 = 0
var time_world05 = 0

var score_total = 0

# --- NOVO: FUNÇÃO CHAMADA AO MORRER ---
func handle_player_death() -> void:
	# 1. Reduz a vida (opcional, dependendo de onde você controla isso)
	life -= 1
	
	# 2. Se a vida zerou, inicia o Game Over
	if life <= 0:
		# ZERA o tempo da fase atual para que não conte no bônus!
		reset_current_world_time()
		
		# Chama a função final que irá calcular o score total com o tempo zerado
		go_to_game_over_screen()
	else:
		# Se ainda há vidas, apenas recarrega a cena ou reinicia o jogador
		pass # Adicione aqui sua lógica de respawn

# --- FUNÇÃO PRINCIPAL PARA ZERAR O TEMPO ---
func reset_current_world_time() -> void:
	match current_world:
		1:
			time_world01 = 0
			print("Tempo do Mundo 1 zerado devido à morte.")
		2:
			time_world02 = 0
			print("Tempo do Mundo 2 zerado devido à morte.")
		3:
			time_world03 = 0
			print("Tempo do Mundo 3 zerado devido à morte.")
		4:
			time_world04 = 0
			print("Tempo do Mundo 4 zerado devido à morte.")
		5:
			time_world05 = 0
			print("Tempo do Mundo 5 zerado devido à morte.")
		_:
			# Se a variável current_world não foi definida corretamente
			print("Aviso: Variável 'current_world' indefinida.")

# --- FUNÇÃO DE FIM DE JOGO (Onde o Score Total é calculado) ---
func go_to_game_over_screen() -> void:
	# Fórmula: Score Base + 10 * (Soma dos tempos restantes)
	# Como o tempo do mundo atual foi zerado antes, ele não será contado.
	score_total = score + 10 * (time_world01 + time_world02 + time_world03 + time_world04 + time_world05)
	print("---------------------------------")
	print("PONTUAÇÃO FINAL CALCULADA:")
	print("Score Base: ", score)
	print("Bônus de Tempo Restante (excluindo fase da morte): ", score_total - score)
	print("Score Total: ", score_total)
	print("---------------------------------")
	
	# Troca para a cena de Game Over
	get_tree().change_scene_to_file("res://scenes/game_over_scene.tscn") # Use o caminho correto!
