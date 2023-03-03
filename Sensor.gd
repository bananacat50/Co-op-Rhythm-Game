extends Node2D

enum STATE {MISS, BAD, GOOD, GREAT, PERFECT}

var current_state = STATE.MISS
var current_note


func _on_Bad_body_entered(body:Node):
	current_state = STATE.BAD
	current_note = body
	
func _on_Good_body_entered(body:Node):
	current_state = STATE.GOOD

func _on_Great_body_entered(body:Node):
	current_state = STATE.GREAT

func _on_Perfect_body_entered(body:Node):
	current_state = STATE.PERFECT

func _on_Perfect_body_exited(body:Node):
	current_state = STATE.GREAT

func _on_Great_body_exited(body:Node):
	current_state = STATE.GOOD

func _on_Good_body_exited(body:Node):
	current_state = STATE.BAD

func _on_Bad_body_exited(body:Node):
	current_state = STATE.MISS
	current_note = null
