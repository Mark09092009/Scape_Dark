extends HBoxContainer
class_name InventoryUI

# Array para guardar a REFERÊNCIA visual de cada slot
@onready var slot_uis: Array[TextureRect] = [
	$"Box1/IconItem",
	$"Box2/IconItem",
	$"Box3/IconItem",
]


func update_ui(player_inventory: Array) -> void:
	 # Garantir que o inventário do player tem o mesmo tamanho que a UI
	if player_inventory.size() != slot_uis.size():
		push_error("Inventário do Player não corresponde ao número de slots da UI!")
		return
		
	for i in range(slot_uis.size()):
		var item_data = player_inventory[i]
		var slot_ui = slot_uis[i]
		
		if item_data != null:
			slot_ui.texture = item_data.texture
		else:
			slot_ui.texture = null
