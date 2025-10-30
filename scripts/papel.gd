extends Area2D

#class_name WorldItem

const ITEM_DATA = preload("res://items/papel_item.tres")
@export var item_data: ItemData = ITEM_DATA
@onready var pego: AudioStreamPlayer = $pego

#Para corrigir o erro de duplicação de item:
var animation_Time = false


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_to_inventory") and not(animation_Time):
		# Tenta adicionar o item de dados (Resource) ao inventário do player
		var added = body.add_to_inventory(item_data)
		animation_Time = true
		if added:
			pego.play()
			$anim.play("collect")
	
	
func _on_anim_animation_finished() -> void:
	queue_free()
	animation_Time = false
