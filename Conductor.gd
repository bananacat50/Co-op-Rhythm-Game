extends AudioStreamPlayer
# The Conductor is responsible for beat timing (vs game.tscn, which is
# responsible for the UI, health variables, etc). This script plays a song
# and simultaneously parses through a json file meant to represent that song's
# melody and/or important notes. The audio stream recording being played
# defines this script's sense of time (vs the game clock, which fluctuates).
# The json scripts use a VERY specific format and I'm not gonna write it all
# here, look at one of the files (in the songs folder) for details.

## it seems that when going from dodge to dodge, the delay happens and it's
## about 2 underscores ???

signal spawn_beat

export var songname : String = "ArtificialChariot"

onready var json_path = "res://songs/" + songname + ".json"
onready var audio_path = "res://ASSETS/audio/" + songname + ".ogg"
var bpm : int
var division : int # beat division of notes in file, ex 8 = eighth notes
var cursor : int # location in the current string that is being parsed
var json : Dictionary # parsed json data
var song_position : float = 0.0 # position in audio stream
var song_position_in_beats : int = 1 # audio stream position, "floored" to beats
var sec_per_beat : float
var beats_before_start = 0
var last_reported_beat : int = 0 # used to check beats against position
var section : int = -1 # total section number, like a rehearsal number
var beats_before_contact : int # time in beats between panel spawn and panel contact
var sent_to_dodge : bool = false
var total_beats : int


func _ready():
	json = get_file()
	bpm = json["config"]["bpm"]
	division = json["config"]["division"]
	beats_before_contact = json["config"]["beats_before_contact"]
	total_beats = json["notes"][0].length()
	bpm *= division/4
	sec_per_beat = 60.0 / bpm
	cursor = 0



	stream = load(audio_path)
	play()
	

func _physics_process(delta):
	if playing:
		song_position = (get_playback_position() + AudioServer.get_time_since_last_mix())
		song_position -= AudioServer.get_output_latency()
		song_position += beats_before_contact * sec_per_beat
		song_position_in_beats = (floor(song_position / sec_per_beat) + beats_before_start)
		
		if last_reported_beat < song_position_in_beats:
			if song_position_in_beats < total_beats:
				process_beat()
			else:
				print("STOP")
				stop()


func process_beat():
	last_reported_beat = song_position_in_beats
	var result = [false, false, false, false, false, false, false, false]
	for i in json["notes"].size():
		var index = str2var(json["notes"][i][song_position_in_beats])
		if index != 0:
			result[index - 1] = true
	emit_signal("spawn_beat", result)


func get_file():
	var f = File.new()
	assert(f.file_exists(json_path), "File path does not exist")
	f.open(json_path, File.READ)
	var text = f.get_as_text()
	
	json = parse_json(text)
	
	return json
