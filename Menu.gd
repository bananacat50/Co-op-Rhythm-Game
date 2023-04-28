extends Control

onready var battle = preload("res://Battle.tscn").instance()

func _on_Next_pressed():
	battle.seperate_score = $Options/SeperateScore.pressed
	battle.seperate_combo = $Options/SeperateCombo.pressed
	battle.spacing = pow($Options/SpeedSlider.value - 15, 2) + 15
	
	$Options.hide()

	$SongSelect.show()

func _process(delta):
	for child in $SongSelect/MarginContainer/ScrollContainer/VBoxContainer.get_children():
		if child is Button and child.pressed:
			battle.songname = child.name
			$SongSelect.hide()
			$Background.hide()
			add_child(battle)
			battle.get_node("CanvasLayer/AudioStreamPlayer").connect("finished", self, "_on_AudioStreamPlayer_finished")

func _on_AudioStreamPlayer_finished():
	battle.queue_free()
	battle = preload("res://Battle.tscn").instance()
	$Options.show()
	$SongSelect.hide()
	$Background.show()
