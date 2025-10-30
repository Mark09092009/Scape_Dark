extends Control

# Variáveis de nó configuradas para serem carregadas quando o nó entra na árvore
@onready var time_counter: Label = $container/time_container/time_counter as Label
@onready var score_counter: Label = $container/score_container/score_counter as Label
@onready var life_counter: Label = $container/life_container/life_counter as Label
@onready var clock_timer: Timer = $clock_timer

# Variáveis para rastrear o tempo atual de contagem regressiva
var minutes: int = 0
var seconds: int = 0

# Variáveis de tempo padrão configuráveis no Inspector do Godot
@export_range(0, 15) var defaunt_minutes := 1
@export_range(0, 59) var defaunt_seconds := 30 # Mudei para 30 para teste, mas você pode deixar 1

# Chamado quando o nó entra na árvore de cena pela primeira vez.
func _ready() -> void:
	# 1. Inicializa as variáveis de tempo com os valores padrão
	minutes = defaunt_minutes
	seconds = defaunt_seconds
	
	# 2. Configura os contadores iniciais
	_update_hud()
	
	# 3. Inicia o Timer (assumindo que ele está configurado para 1 segundo e "Autostart" está desativado)
	time_counter.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
	clock_timer.start()

# Chamado a cada frame. 'delta' é o tempo decorrido desde o frame anterior.
func _process(_delta: float) -> void:
	# Apenas atualiza o score e a vida, pois eles podem mudar a qualquer momento.
	# **O CÓDIGO DO TIMER FOI REMOVIDO DAQUI para evitar o reset constante.**
	_update_hud_score_life()
	
	Global.seconds_before = (minutes*60) + seconds

# Função auxiliar para atualizar todos os elementos da HUD
func _update_hud() -> void:
	_update_hud_score_life()
	# A função de tempo agora é chamada apenas aqui e no timeout do timer
	time_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)

# Função auxiliar para atualizar apenas Score e Life
func _update_hud_score_life() -> void:
	score_counter.text = str("%06d" % Global.score)
	life_counter.text = str("%01d" % Global.life)

# Chamado quando o clock_timer atinge o tempo limite (timeout).
func _on_clock_timer_timeout() -> void:
	# Verifica se o tempo acabou (00:00)
	if minutes == 0 and seconds == 0:
		clock_timer.stop()
		print("Tempo esgotado! Game Over (ou lógica de fim de tempo)")
		GameData.clear_inventory()
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		return

	# Lógica principal da contagem regressiva
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 59 # Volta para 59 segundos no novo minuto
	elif seconds == 15 and minutes == 0:
		seconds -= 1
		time_counter.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0))
	else:
		seconds -= 1
		
	# Atualiza o contador de tempo após o cálculo
	time_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)

# A função 'reset_clock_timer()' foi removida porque não deve ser chamada a cada frame.
# A inicialização ocorre apenas em '_ready()'.
