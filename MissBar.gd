extends Area2D


func _on_MissBar_body_entered(body):
	body.queue_free()

