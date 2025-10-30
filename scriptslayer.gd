extends CharacterBody2D


const SPEED = 150.0
const JUMP_FORCE = -350.0
#Inventário:
const NUM_SLOTS = 3
var inventory: Array[ItemData] = []
var global_inventory: Array = GameData.inventory

@onready var anim = $Anim
@export var popup_node_path: NodePath = "../CanvasLayer/PapelUI"
#Fazedo referência ao Script do UI do inventário
@onready var inventory_ui: InventoryUI = get_node("CanvasInventory/HBoxContainer")
#Abrir porta:
@export var door_node: Node2D

var popup: TextureRect

	
func _ready():
	for i in range(GameData.INVENTORY_SIZE):
		print(GameData.inventory[i])
	
	popup = get_node(popup_node_path)
	if popup == null:
		push_error("PapelUI não encontrado! Verifique o NodePath")
	else:
		popup.visible = false
	popup.connect("gui_input", Callable(self, "_on_gui_input"))
	$Camera2D.make_current()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		anim.flip_h = direction < 0
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if not is_on_floor():
		anim.play("jump")
	elif direction == 0:
		anim.play("idle")
	else: 
		anim.play("run")

	move_and_slide()


func aumentar_luz():
	$PointLight2D.texture_scale += 0.0025
	
	
func pegar_papel():
	popup.visible = true
	set_process(false)
	
	
func _input(event: InputEvent) -> void:
	# Usa o Slot 1
	if event.is_action_pressed("use_slot_1"):
		_use_item_from_slot(0) # Slots de Array começam em 0
	
	# Usa o Slot 2
	if event.is_action_pressed("use_slot_2"):
		_use_item_from_slot(1)

	# Usa o Slot 3
	if event.is_action_pressed("use_slot_3"):
		_use_item_from_slot(2)
		
	# Discarta o item do Slot 1
	if event.is_action_pressed("remove_slot_1"):
		print("Discartando ", GameData.inventory[0].item_name)
		GameData._consume_item(0)
		_consume_item()
		
	# Discarta o item do Slot 2
	if event.is_action_pressed("remove_slot_2"):
		print("Discartando ", GameData.inventory[1].item_name)
		GameData._consume_item(1)
		_consume_item()
		
	# Discarta o item do Slot 3
	if event.is_action_pressed("remove_slot_3"):
		print("Discartando ", GameData.inventory[2].item_name)
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
	var used = GameData._use_item_from_slot(slot_index)
	var activate_anim_use = false
	
	if used == "Bateria":
		aumentar_luz()
		_consume_item()
		activate_anim_use = true
	elif used == "Papel":
		if popup.visible:
			print("Popup sai")
			_consume_item()
			popup.visible = false
			set_process(true)
		else:
			print("Abrindo papel")
			_consume_item()
			pegar_papel()
		activate_anim_use = true
	elif used == "Key":
		if door_node.player_present:
			GameData._consume_item(slot_index)
			door_node._change_scene()
			inventory_ui.update_ui(GameData.inventory)
			activate_anim_use = true
		else:
			print("Não está na hora de usar isso...")
			activate_anim_use = false
	
	if activate_anim_use:
		$Anim.play("use")
		
		
func _consume_item() -> void:
	inventory_ui.update_ui(GameData.inventory)
