extends Node2D

# Declare member variables here. Examples:
var time = 0
var bpm = 100
var beat = 2
onready var noteBar = $NoteBar
const note = preload("res://Note.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	noteBar.position.y = noteBar.position.y + delta*100

	time += delta*100
	if (time > bpm*(beat-1)):
		var notePosition = Vector2(((beat^2)*100)%1000, -beat*100)
		noteBar.add_point(notePosition)
		var noteCircle = note.instance()
		noteCircle.position = notePosition
		noteBar.add_child(noteCircle)
		beat = beat + 1
