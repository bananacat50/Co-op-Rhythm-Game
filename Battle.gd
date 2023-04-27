extends Node2D

const POSITION_SPACING = 54
const LEFT_POSITION = 50
const POSITION_GAP_WIDTH = 168

export var songname : String = "ArtificialChariot"
export var seperate_score : bool = true
export var seperate_combo : bool = true

# Declare member variables here. Examples:
var bpm : int # comes from json
var spacing : int = 30
var score = 0
var scoreP1 = 0
var scoreP2 = 0
var combo = 0
var comboP1 = 0
var comboP2 = 0
var ratings = ["MISS", "BAD", "GOOD", "GREAT", "PERFECT"]
var last_frame_latency : float

onready var json_path = "res://songs/" + songname + ".json"
onready var audio_path = "res://ASSETS/audio/" + songname + ".ogg"

onready var NBs = $CanvasLayer/NoteBars
onready var audio_player = $CanvasLayer/AudioStreamPlayer

onready var scoreDisplay = $CanvasLayer/ScoreCenter
onready var scoreP1Display = $CanvasLayer/ScoreP1
onready var scoreP2Display = $CanvasLayer/ScoreP2

onready var comboDisplay = $CanvasLayer/ComboCenter
onready var comboP1Display = $CanvasLayer/ComboP1
onready var comboP2Display = $CanvasLayer/ComboP2

onready var canvasLayer = $CanvasLayer
const note = preload("res://Note.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	last_frame_latency = AudioServer.get_output_latency()
	var json : Dictionary = get_file()
	bpm = json["config"]["bpm"]
	bpm *= json["config"]["division"] / 4
	#spacing = json["config"]["spacing"]
	fill_beats(json)
	NBs.position.y += 400
	set_label_visibilities()
	audio_player.stream = load(audio_path)
	audio_player.play()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var latency_delta = 0
	NBs.position.y += delta * spacing * bpm/60 + latency_delta
	
	for i in ["1", "2", "3", "4", "5", "6", "7", "8"]:
		if Input.is_action_just_pressed(i):
			var sensor = get_node("CanvasLayer/JudgementBar/Sensor" + i)
			var result = sensor.current_state
			if sensor.current_note:
				sensor.current_note.get_node("CollisionShape").disabled = true
			
			process_input(result, i)
	
	last_frame_latency = AudioServer.get_output_latency()
	$Road/Camera2D/AnimationPlayer.playback_speed = (delta * spacing * bpm + latency_delta) / 392.0
		
func add_notes(lanes, beat):
	for i in range(0.0, lanes.size()):
		if lanes[i] == 1:
			var notePosition = Vector2(i*POSITION_SPACING + LEFT_POSITION, -beat*spacing)
			if i > 3:
				notePosition.x += POSITION_GAP_WIDTH
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
	NBs.position.y -= json["config"]["delay"] * spacing / json["config"]["spacing"]
	for beat in json["notes"][0].length():
		result.append([0, 0, 0, 0, 0, 0, 0, 0])
	for beat in range(json["notes"][0].length()-1, 0.0, -1):
		for i in json["notes"].size():
			var index = str2var(json["notes"][i][beat])
			if index != 0:
				result[beat][index - 1] = 1
		add_notes(result[beat], beat)
	return result


func process_input(result, i):
	var rating = preload("res://Rating.tscn").instance()
	rating.text = ratings[result]
	if result == 0:
		change_score(i, -5)
		rating.set("custom_colors/font_color",Color.red)
	elif result == 1:
		rating.set("custom_colors/font_color",Color.orange)
	elif result == 2:
		rating.set("custom_colors/font_color",Color.yellow)
	elif result == 3:
		rating.set("custom_colors/font_color",Color.green)
	else:
		rating.set("custom_colors/font_color",Color.blue)
	canvasLayer.add_child(rating)
	if seperate_combo || seperate_score:
		if str2var(i) < 5:
			rating.get_child(0).play("New Anim 2")
		else:
			rating.get_child(0).play("New Anim 3")
	else:
		rating.get_child(0).play("New Anim")
	change_score(i, result*log(get_combo(i) + 1) + 1)
	if result == 0:
		set_combo(i, 0)
	else:
		set_combo(i, get_combo(i) + 1)

func set_label_visibilities():
	scoreDisplay.visible = not seperate_score
	scoreP1Display.visible = seperate_score
	scoreP2Display.visible = seperate_score

	comboDisplay.visible = not seperate_combo
	comboP1Display.visible = seperate_combo
	comboP2Display.visible = seperate_combo

func change_score(input_string : String, change : int):
	if seperate_score:
		if str2var(input_string) < 5:
			scoreP1 += change
			scoreP1Display.text = "score: " + str(round(scoreP1))
		else:
			scoreP2 += change
			scoreP2Display.text = "score: " + str(round(scoreP2))
	else:
		score += change
		scoreDisplay.text = "score: " + str(round(score))

func get_combo(input_string : String):
	if seperate_combo:
		if str2var(input_string) < 5:
			return comboP1
		else:
			return comboP2
	else:
		return combo

func set_combo(input_string : String, value : int):
	if seperate_combo:
		if str2var(input_string) < 5:
			comboP1 = value
			comboP1Display.text = "combo: " + str(round(comboP1))
		else:
			comboP2 = value
			comboP2Display.text = "combo: " + str(round(comboP2))
	else:
		combo = value
		comboDisplay.text = "combo: " + str(combo)

func _on_MissBar_body_entered(body):
	var i : String = str((body.position.x - LEFT_POSITION) / POSITION_SPACING)
	process_input(0, i)
	body.queue_free()

func _on_AudioStreamPlayer_finished():
	print("finished signal sent")
