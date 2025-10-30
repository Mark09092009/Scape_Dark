extends Control

func _ready() -> void:
	# 1. Cria o CenterContainer
	var center = CenterContainer.new()
	
	var bg = $BackGround
	if bg:
		bg.anchor_left = 0
		bg.anchor_top = 0
		bg.anchor_right = 1
		bg.anchor_bottom = 1
		bg.offset_left = 0
		bg.offset_top = 0
		bg.offset_right = 0
		bg.offset_bottom = 0

	# 2. Configura as âncoras para que o CenterContainer preencha
	#    todo o espaço do seu nó pai (TelaInicial)
	#    PRESET_FULL_RECT = âncoras para preencher o retângulo completo
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# 3. Adiciona o CenterContainer à TelaInicial
	add_child(center)

	# 4. Remove o VBoxContainer do seu pai (TelaInicial)
	var vbox = $VBoxContainer
	remove_child(vbox)
	
	# 5. Adiciona o VBoxContainer ao CenterContainer, centralizando-o
	center.add_child(vbox)


func _on_start_bttn_pressed() -> void:
	# Presumindo que 'GameData' é um Singleton (Autoload) acessível globalmente
	Global.score = 0
	Global.life = 3
	get_tree().change_scene_to_file("res://levels/World_1.tscn")
	for i in range(3):
		# Certifique-se de que GameData.inventory existe e é uma estrutura que pode ser modificada
		GameData.inventory[i] = null 

func _on_quit_bttn_pressed() -> void:
	get_tree().quit()
