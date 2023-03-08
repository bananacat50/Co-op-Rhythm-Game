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

onready var NBs = $NoteBars
const note = preload("res://Note.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var json : Dictionary = get_file()
	fill_beats(json)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	NBs.position.y = NBs.position.y + delta*100
	
	process_input()
		
func add_notes(lanes, beat):
	for i in range(0.0, lanes.size()):
		if lanes[i] == 1:
#			print(i)
			var notePosition = Vector2(i*100 + 125, -beat*100)
			var noteCircle = note.instance()
			noteCircle.position = notePosition
			NBs.get_child(i).add_child(noteCircle)
			NBs.get_child(i).add_point(notePosition)
			if not lanes[i + i%2*-2+1]:
				NBs.get_child(i + i%2*-2+1).add_point(notePosition)
				if not lanes[i + i/2%2*-4+i%2*-1+2] and not lanes[i + i/2%2*-4+i%2*-1+3]:
					NBs.get_child(i + i/2%2*-4+i%2*-1+2).add_point(notePosition)
					NBs.get_child(i + i/2%2*-4+i%2*-1+3).add_point(notePosition)
			
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
