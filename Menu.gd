extends Control

onready var battle = preload("res://Battle.tscn").instance()

func _on_Next_pressed():
	battle.seperate_score = $Options/SeperateScore.pressed
	battle.seperate_combo = $Options/SeperateCombo.pressed
	
	$Options.hide()

	add_child(battle)
