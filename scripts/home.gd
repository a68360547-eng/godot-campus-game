extends Control

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = GameSession.COLORS.ink
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var stack := VBoxContainer.new()
	stack.alignment = BoxContainer.ALIGNMENT_CENTER
	stack.add_theme_constant_override("separation", 12)
	center.add_child(stack)
	for entry in [["資通系期末生存戰 · TURN-BASED RPG", 16, GameSession.COLORS.teal], ["最終死線", 58, GameSession.COLORS.paper]]:
		var label := GameSession.label(entry[0], entry[1], entry[2])
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		stack.add_child(label)
	stack.add_child(_hero())
	var intro := GameSession.label("期末報告只剩一週。帶上快沒電的筆電，\n和組員一起打倒大魔王 Deadline！", 24, GameSession.COLORS.paper)
	intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stack.add_child(intro)
	var start := GameSession.button("開始挑戰")
	start.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	start.focus_mode = Control.FOCUS_ALL
	start.pressed.connect(_start)
	stack.add_child(start)
	start.grab_focus()
	for message in ["滑鼠點選行動｜方向鍵選擇、Enter 確認｜手機直接觸控", "資通四勤 121271013林信安"]:
		var label := GameSession.label(message, 18, GameSession.COLORS.yellow)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		stack.add_child(label)

func _start() -> void:
	GameSession.begin_run()
	GameSession.play_sfx("collect")
	GameSession.to_battle()

func _hero() -> Control:
	var box := Control.new()
	box.custom_minimum_size = Vector2(280, 80)
	box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	for spec in [["e6ab7c", Vector2(111, 18), Vector2(58, 50)], ["263449", Vector2(107, 12), Vector2(66, 15)], ["42b8a3", Vector2(81, 69), Vector2(118, 8)]]:
		var shape := ColorRect.new()
		shape.color = Color(spec[0])
		shape.position = spec[1]
		shape.size = spec[2]
		box.add_child(shape)
	for x in [122, 148]:
		var eye := ColorRect.new()
		eye.color = GameSession.COLORS.ink
		eye.position = Vector2(x, 39)
		eye.size = Vector2(8, 4)
		box.add_child(eye)
	return box
