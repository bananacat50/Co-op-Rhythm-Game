extends Node2D

# Declare member variables here. Examples:
var time = 0
var bpm = 100
var beat = 1
var lastBeat = 0
var line
onready var NB1 = $NoteBar
onready var NB2 = $NoteBar2
onready var NB3 = $NoteBar3
onready var NB4 = $NoteBar4
onready var NB5 = $NoteBar5
onready var NB6 = $NoteBar6
onready var NB7 = $NoteBar7
onready var NB8 = $NoteBar8
const note = preload("res://Note.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	NB1.position.y = NB1.position.y + delta*100
	NB2.position.y = NB2.position.y + delta*100
	NB3.position.y = NB3.position.y + delta*100
	NB4.position.y = NB4.position.y + delta*100
	NB5.position.y = NB5.position.y + delta*100
	NB6.position.y = NB6.position.y + delta*100
	NB7.position.y = NB7.position.y + delta*100
	NB8.position.y = NB8.position.y + delta*100

	time += delta*100
	if (time > bpm*(beat-1)):
		var notes = Array()
		for _i in range(1,9):
			randomize()
			notes.append(randi()%2)
		addNotes(notes, beat)
		beat = beat + 1
		
func addNotes(lanes, beat):
	wire4(lanes, beat)
			
func wire4(lanes, beat):
	
	for i in range(0, lanes.size()):
		if lanes[i] == 1:
			var notePosition = Vector2(i*100 + 125 + rand_range(0, 50), -beat*100)
			var noteCircle = note.instance()
			noteCircle.position = notePosition
			if i == 0:
				NB1.add_child(noteCircle)
				NB1.add_point(notePosition)
				if lanes[1] == 0:
					NB2.add_point(notePosition)
					if lanes[2] == 0 && lanes[3] == 0:
						NB3.add_point(notePosition)
						NB4.add_point(notePosition)
			elif i == 1:
				NB2.add_child(noteCircle)
				NB2.add_point(notePosition)
				if lanes[0] == 0:
					NB1.add_point(notePosition)
				if lanes[2] == 0 && lanes[3] == 0:
					NB3.add_point(notePosition)
					NB4.add_point(notePosition)
			elif i == 2:
				NB3.add_child(noteCircle)
				NB3.add_point(notePosition)
				if lanes[3] == 0:
					NB4.add_point(notePosition)
				if lanes[0] == 0 && lanes[1] == 0:
					NB1.add_point(notePosition)
					NB2.add_point(notePosition)
			elif i == 3:
				NB4.add_child(noteCircle)
				NB4.add_point(notePosition)
				if lanes[2] == 0:
					NB3.add_point(notePosition)
					if lanes[0] == 0 && lanes[1] == 0:
						NB1.add_point(notePosition)
						NB2.add_point(notePosition)
			elif i == 4:
				NB5.add_child(noteCircle)
				NB5.add_point(notePosition)
				if lanes[5] == 0:
					NB6.add_point(notePosition)
					if lanes[6] == 0 && lanes[7] == 0:
						NB7.add_point(notePosition)
						NB8.add_point(notePosition)
			elif i == 5:
				NB6.add_child(noteCircle)
				NB6.add_point(notePosition)
				if lanes[4] == 0:
					NB5.add_point(notePosition)
				if lanes[6] == 0 && lanes[7] == 0:
					NB7.add_point(notePosition)
					NB8.add_point(notePosition)
			elif i == 6:
				NB7.add_child(noteCircle)
				NB7.add_point(notePosition)
				if lanes[7] == 0:
					NB8.add_point(notePosition)
				if lanes[4] == 0 && lanes[5] == 0:
					NB5.add_point(notePosition)
					NB6.add_point(notePosition)
			elif i == 7:
				NB8.add_child(noteCircle)
				NB8.add_point(notePosition)
				if lanes[6] == 0:
					NB7.add_point(notePosition)
					if lanes[4] == 0 && lanes[5] == 0:
						NB5.add_point(notePosition)
						NB6.add_point(notePosition)
