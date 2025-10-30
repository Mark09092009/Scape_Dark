extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.score += 100
		print("bateu1")
		body.velocity.y = body.JUMP_FORCE + 150
		owner.texture.play("dano")
		owner.direction = 0.0
		await get_tree().create_timer(0.5).timeout
		owner.queue_free()
