extends Node

class_name GlobalGameData

var inventory: Array[ItemData] = []
const INVENTORY_SIZE = 3


func _ready():
	for i in range(INVENTORY_SIZE):
		inventory.append(null)


func update_inventory(item: ItemData) -> bool:
	for i in range(INVENTORY_SIZE):
		if inventory[i] == null:
			# Encontrou um slot vazio, armazena a REFERÊNCIA do recurso ItemData
			inventory[i] = item
			return true
	print("Inventário cheio! Não foi possível adicionar ", item.item_name)
	return false
	
	
func _use_item_from_slot(slot_index: int):
	if slot_index < 0 or slot_index >= INVENTORY_SIZE:
		push_error("Índice de slot inválido: ", slot_index)
		return ["", null]
		
	var item_to_use: ItemData = inventory[slot_index]
	
	if item_to_use == null:
		print("Slot ", slot_index + 1, " está vazio.")
		return ["", null]
		
	if item_to_use.item_name == "Papel":
		return ["Papel", item_to_use.effect]
	elif item_to_use.item_name == "Bateria":
		print("Usando bateria")
		_consume_item(slot_index)
		return ["Bateria", null]
	elif item_to_use.item_name == "Key":
		return ["Key",null]
	else:
		print("O item no Slot ", slot_index + 1, " não tem uma ação de uso definida.")
		return ["", null]
		
		
func _consume_item(slot_index: int) -> void:
	# Define o slot como vazio (null)
	inventory[slot_index] = null
	
# Exemplo de como implementar no seu script GameData.gd:


func clear_inventory():
	for i in range(inventory.size()):
		inventory[i] = null

	
