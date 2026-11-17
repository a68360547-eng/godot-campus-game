extends Node

var score := 0
var turn := 0
var player_hp := 100
var boss_hp := 180
var slides := 0
var bugs_fixed := 0
var result_won := false
var last_action := ""

const COLORS := {"ink": Color("17243a"), "paper": Color("f4efe5"), "card": Color("fffaf0"), "orange": Color("ff8b4a"), "teal": Color("42b8a3"), "red": Color("e15b64"), "yellow": Color("f3c969"), "muted": Color("aeb8c8"), "white": Color("ffffff")}

func begin_run() -> void:
	score = 0
	turn = 0
	player_hp = 100
	boss_hp = 180
	slides = 0
	bugs_fixed = 0
	last_action = "期末報告只剩一週，Deadline 出現了！"

func to_home() -> void:
	get_tree().change_scene_to_file("res://scenes/home.tscn")

func to_battle() -> void:
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func to_results(won: bool) -> void:
	result_won = won
	get_tree().change_scene_to_file("res://scenes/results.tscn")

func label(text: String, size: int = 20, color: Color = Color.WHITE) -> Label:
	var node := Label.new()
	node.text = text
	node.add_theme_font_size_override("font_size", size)
	node.add_theme_color_override("font_color", color)
	return node

func button(text: String, color: Color = COLORS.orange) -> Button:
	var node := Button.new()
	node.text = text
	node.custom_minimum_size = Vector2(160, 100)
	node.add_theme_font_size_override("font_size", 24)
	node.add_theme_color_override("font_color", COLORS.ink)
	var normal := StyleBoxFlat.new()
	normal.bg_color = color
	for corner in ["top_left", "top_right", "bottom_left", "bottom_right"]:
		normal.set("corner_radius_" + corner, 12)
	normal.content_margin_left = 16
	normal.content_margin_right = 16
	node.add_theme_stylebox_override("normal", normal)
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = color.lightened(0.12)
	node.add_theme_stylebox_override("hover", hover)
	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = color.darkened(0.1)
	node.add_theme_stylebox_override("pressed", pressed)
	return node

func panel(color: Color = COLORS.card, radius: int = 18) -> PanelContainer:
	var node := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = color
	for corner in ["top_left", "top_right", "bottom_left", "bottom_right"]:
		style.set("corner_radius_" + corner, radius)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	node.add_theme_stylebox_override("panel", style)
	return node

func play_sfx(kind: String) -> void:
	var frequency := 440.0 if kind == "hit" else 660.0
	var duration := 0.13
	var rate := 22050
	var bytes := PackedByteArray()
	bytes.resize(int(rate * duration) * 2)
	for i in range(int(rate * duration)):
		var envelope := 1.0 - float(i) / float(rate * duration)
		var sample := int(sin(TAU * frequency * float(i) / rate) * envelope * 10000.0)
		bytes.encode_s16(i * 2, sample)
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = rate
	stream.stereo = false
	stream.data = bytes
	var player := AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()
