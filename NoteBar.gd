extends Node2D

# Declare member variables here. Examples:
var time = 0
var bpm = 100
var beat = 1
var lastBeat = 0
var line

export var songname : String = "battle"

onready var json_path = "res://songs/" + songname + ".json"
onready var audio_path = "res://ASSETS/audio/" + songname + ".ogg"

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
	var json : Dictionary = get_file()
	fill_beats(json)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	NB1.position.y = NB1.position.y + delta*600
	NB2.position.y = NB2.position.y + delta*600
	NB3.position.y = NB3.position.y + delta*600
	NB4.position.y = NB4.position.y + delta*600
	NB5.position.y = NB5.position.y + delta*600
	NB6.position.y = NB6.position.y + delta*600
	NB7.position.y = NB7.position.y + delta*600
	NB8.position.y = NB8.position.y + delta*600

	process_input()
	
		
func add_notes(lanes, beat):
	for i in range(0, lanes.size()):
		if lanes[i] == 1:
			var notePosition = Vector2(i*100 + 125, -beat*100)
			var noteCircle = note.instance()
			noteCircle.position = notePosition
			if i == 0:
				NB1.add_child(noteCircle)
				NB1.add_point(notePosition)
				if not lanes[1]:
					NB2.add_point(notePosition)
					if not lanes[2] and not lanes[3]:
						NB3.add_point(notePosition)
						NB4.add_point(notePosition)
			elif i == 1:
				NB2.add_child(noteCircle)
				NB2.add_point(notePosition)
				if not lanes[0]:
					NB1.add_point(notePosition)
				if not lanes[2] and not lanes[3]:
					NB3.add_point(notePosition)
					NB4.add_point(notePosition)
			elif i == 2:
				NB3.add_child(noteCircle)
				NB3.add_point(notePosition)
				if not lanes[3]:
					NB4.add_point(notePosition)
				if not lanes[0] && not lanes[1]:
					NB1.add_point(notePosition)
					NB2.add_point(notePosition)
			elif i == 3:
				NB4.add_child(noteCircle)
				NB4.add_point(notePosition)
				if not lanes[2]:
					NB3.add_point(notePosition)
					if not lanes[0] and not lanes[1]:
						NB1.add_point(notePosition)
						NB2.add_point(notePosition)
			elif i == 4:
				NB5.add_child(noteCircle)
				NB5.add_point(notePosition)
				if not lanes[5]:
					NB6.add_point(notePosition)
					if not lanes[6] and not lanes[7]:
						NB7.add_point(notePosition)
						NB8.add_point(notePosition)
			elif i == 5:
				NB6.add_child(noteCircle)
				NB6.add_point(notePosition)
				if not lanes[4]:
					NB5.add_point(notePosition)
				if not lanes[6] and not lanes[7]:
					NB7.add_point(notePosition)
					NB8.add_point(notePosition)
			elif i == 6:
				NB7.add_child(noteCircle)
				NB7.add_point(notePosition)
				if not lanes[7]:
					NB8.add_point(notePosition)
				if not lanes[4] and not lanes[5]:
					NB5.add_point(notePosition)
					NB6.add_point(notePosition)
			elif i == 7:
				NB8.add_child(noteCircle)
				NB8.add_point(notePosition)
				if not lanes[6]:
					NB7.add_point(notePosition)
					if not lanes[4] and not lanes[5]:
						NB5.add_point(notePosition)
						NB6.add_point(notePosition)
			
func get_file():
	var f = File.new()
	assert(f.file_exists(json_path), "File path does not exist")
	f.open(json_path, File.READ)
	return parse_json(f.get_as_text())


func fill_beats(json : Dictionary):
	var result = []
	for beat in json["notes"][0].length():
		result.append([0, 0, 0, 0, 0, 0, 0, 0])
		for i in json["notes"].size():
			var index = str2var(json["notes"][i][beat])
			if index != 0:
				result[beat][index - 1] = 1
		add_notes(result[beat], beat)
	return result


func process_input():
	for i in ["1", "2", "3", "4", "5", "6", "7", "8"]:
		if Input.is_action_just_pressed(i):
			print(get_node("Sensor" + i).current_state)
