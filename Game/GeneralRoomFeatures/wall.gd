extends Node2D

func _on_bullet_body_entered(body):
	if body.is_in_group("Bullet"):
		body.queue_free()
