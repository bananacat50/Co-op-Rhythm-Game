extends Sprite


func _physics_process(delta):
	for i in 8:
		if Input.is_action_pressed(str(i+1)):
			get_node(str(i+1)).modulate = Color(0.5, 0.5, 0.5)
		else:
			get_node(str(i+1)).modulate = Color(1, 1, 1)
