extends Control

func _ready() -> void:
	# 1. Cria o CenterContainer
	var center = CenterContainer.new()
	
	var bg = $ColorRect
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
	#    todo o espaço do seu nó pai (Victury)
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# 3. Adiciona o CenterContainer como filho de Victury.
	#    É crucial que ele seja adicionado ANTES do VBoxContainer ser movido,
	#    e idealmente depois de elementos de fundo (ColorRect, anim).
	#    Você pode usar add_child(center) se quiser que ele fique por cima
	#    do ColorRect e anim.
	add_child(center) 

	# 4. Remove o VBoxContainer do seu pai (Victury)
	var vbox = $VBoxContainer
	remove_child(vbox)
	
	# 5. Adiciona o VBoxContainer ao CenterContainer, centralizando-o na tela.
	center.add_child(vbox)


func _on_restart_bttn_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/World_1.tscn")
	for i in range(3):
		GameData.inventory[i] = null
	
	
func _on_quit_bttn_pressed() -> void:
	get_tree().quit()
