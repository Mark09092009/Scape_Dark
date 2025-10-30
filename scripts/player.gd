extends CharacterBody2D

class_name Player

var is_taking_damage: bool = false


const SPEED = 150.0
const JUMP_FORCE = -350.0
const FRICTION = 600.0
#Inventário:
const NUM_SLOTS = 3
var inventory: Array[ItemData] = []
var global_inventory: Array = GameData.inventory

@onready var anim = $Anim
@export var popup_node_path: NodePath = "../MiniMapUI/MiniMap_Container"
#Fazedo referência ao Script do UI do inventário
@onready var inventory_ui: InventoryUI = get_node("CanvasInventory/HBoxContainer")
#Abrir porta:
@export var door_node: Node2D
@onready var jump:= $jump as AudioStreamPlayer
@onready var ande:= $ande as AudioStreamPlayer 
@onready var usar_item: AudioStreamPlayer = $usarItem
@onready var dano: AudioStreamPlayer = $dano
@onready var morte: AudioStreamPlayer = $morte

var direction := 0


var popup: TextureRect
 
	
func _ready():
	for i in range(GameData.INVENTORY_SIZE):
		print(GameData.inventory[i])
	
	popup = get_node(popup_node_path)
	if popup == null:
		push_error("PapelUI não encontrado! Verifique o NodePath")
	else:
		popup.visible = false
	var result = popup.connect("gui_input", Callable(self, "_on_gui_input"))
	if result != OK:
		# Se 'result' não for 0 (OK), algo deu errado (ex: sinal inexistente)
		push_error("ERRO: Falha ao conectar o sinal 'gui_input'. Erro: " + error_string(result))
	else:
		# Se for OK, a conexão foi registrada
		print("SUCESSO: Sinal 'gui_input' conectado.")
			
func _physics_process(delta: float) -> void:
	if is_taking_damage:
		return  # não processa movimento nem pulo enquanto está tomando dano

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump.play()
		velocity.y = JUMP_FORCE

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		anim.flip_h = direction < 0.0

	if direction:
		velocity.x = direction * SPEED # Aceleração
	else:
		# Desaceleração com FRICTION para deslize
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
	if not is_on_floor():
		anim.play("jump")
		if ande.playing:
			ande.stop()
	elif direction == 0.0:
		anim.play("idle")
		# NOVO: Para o som de correr quando o jogador para
		if ande.playing:
			ande.stop()
	else:
		anim.play("run")
		# NOVO: Toca o som de correr
		# Verifica se o som é um LOOP (é importante que o som seja configurado para loop)
		if not ande.playing:
			ande.play()

	move_and_slide()


func aumentar_luz():
	$PointLight2D.texture_scale += 0.0050
	
	
func abrir_papel(texture_map: Texture2D):
	popup.visible = true
	popup.get_node("back_ground").load_texture(texture_map)
	set_process(false)
	
	
func _input(event: InputEvent) -> void:
	# Usa o Slot 1
	if event.is_action_pressed("use_slot_1"):
		usar_item.play()
		_use_item_from_slot(0) # Slots de Array começam em 0
	
	# Usa o Slot 2
	if event.is_action_pressed("use_slot_2"):
		usar_item.play()
		_use_item_from_slot(1)

	# Usa o Slot 3
	if event.is_action_pressed("use_slot_3"):
		usar_item.play()
		_use_item_from_slot(2)
		
	if event.is_action_pressed("remove_slot_1"):
		# NOVA VERIFICAÇÃO: Garante que o slot não está vazio (não é null)
		if GameData.inventory[0] != null:
			if GameData.inventory[0].item_name == "Key":
				print("Não pode descartar a Key")
			else:
				print("Discartando ", GameData.inventory[0].item_name)
				if GameData.inventory[0].item_name == "Papel":
					popup.visible = false
				GameData._consume_item(0)
				_consume_item()
		# ELSE opcional: Não faz nada se o slot estiver vazio
		
	# Discarta o item do Slot 2
	if event.is_action_pressed("remove_slot_2"):
	 # NOVA VERIFICAÇÃO
		if GameData.inventory[1] != null:
			if GameData.inventory[1].item_name == "Key":
				print("Não pode descartar a Key")
			else:
				print("Discartando ", GameData.inventory[1].item_name)
				if GameData.inventory[1].item_name == "Papel":
					popup.visible = false
				GameData._consume_item(1)
				_consume_item()
			 
	# Discarta o item do Slot 3
	if event.is_action_pressed("remove_slot_3"):
	 # NOVA VERIFICAÇÃO
		if GameData.inventory[2] != null:
			if GameData.inventory[2].item_name == "Key":
				print("Não pode descartar a Key")
			else:
				print("Discartando ", GameData.inventory[2].item_name)
				if GameData.inventory[2].item_name == "Papel":
					popup.visible = false
				GameData._consume_item(2)
				_consume_item()
		
	# -->NÃO APAGAR, MUITO IMPORTANTE NO FUTURO!!<--
	# Importante: Marcar o evento como tratado para evitar que outras coisas
	# (como menus) o capturem, se necessário.
	#if event.is_action_pressed("use_slot_1") or \
	#	event.is_action_pressed("use_slot_2") or \
	#	event.is_action_pressed("use_slot_3"):
	#	event.set_input_as_handled()
	# -->ATÉ AQUI!!<--


func add_to_inventory(item: ItemData) -> bool:
	var successfully_added = GameData.update_inventory(item)
	if successfully_added:
		inventory_ui.update_ui(GameData.inventory)
	return successfully_added
	
	
func _use_item_from_slot(slot_index: int) -> void:
	var item_used  = GameData._use_item_from_slot(slot_index)
	var activate_anim_use = false
	
	if item_used[0] == "Bateria":
		aumentar_luz()
		_consume_item()
		activate_anim_use = true
	elif item_used[0] == "Papel":
		if popup.visible:
			print("Popup sai")
			_consume_item()
			popup.visible = false
			set_process(true)
		else:
			print("Abrindo papel")
			_consume_item()
			abrir_papel(item_used[1])
		activate_anim_use = true
	elif item_used[0] == "Key":
		if door_node.player_present:
			# 1. Consome a chave (removendo-a)
			GameData._consume_item(slot_index)
			
			# 2. NOVO: Reseta o restante do inventário antes de mudar de cena
			GameData.clear_inventory()
			
			inventory_ui.update_ui(GameData.inventory)
			door_node._change_scene()
			activate_anim_use = true
		else:
			print("Não está na hora de usar isso...")
			activate_anim_use = false
	
	if activate_anim_use:
		$Anim.play("use")
		
		
func _consume_item() -> void:
	inventory_ui.update_ui(GameData.inventory)

@onready var Remote_transform := $Remote as RemoteTransform2D

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("inimigos") and not is_taking_damage:
		if Global.life <= 1:
			morte.play()
			print("Player morreu!")
			Global.life -= 1
			direction = 0
			anim.play("dano")
			is_taking_damage = true  # 🔒 trava o player
			velocity.y = -300
			GameData.clear_inventory()

			# Espera a animação "dano" terminar ou 2.7 segundos, o que vier primeiro
			await get_tree().create_timer(3.2).timeout
			Global.score_total = Global.score + 10 * (Global.time_world01 + Global.time_world02 + Global.time_world03 + Global.time_world04 + Global.time_world05)
			print(Global.score_total)
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")
			queue_free()

		else:
			dano.play()
			Global.life -= 1
			print(-1)
			anim.play("dano")
			is_taking_damage = true  # 🔒 trava o player
			velocity.y = -300

			# Espera um tempo enquanto está "atordoado"
			await get_tree().create_timer(0.25).timeout
			is_taking_damage = false  # 🔓 libera o controle de novo


			
			
		
func follow_camera(camera: Camera2D):
	if Remote_transform:
		var camera_path = camera.get_path()
		Remote_transform.remote_path = camera_path
	else:
		print("RemoteTransform2D não encontrado!")
