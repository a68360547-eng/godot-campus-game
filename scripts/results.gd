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
	stack.add_theme_constant_override("separation", 18)
	center.add_child(stack)
	var title := GameSession.label("報告完成！Deadline 被擊敗" if GameSession.result_won else "理智歸零…報告超時", 34, GameSession.COLORS.yellow if GameSession.result_won else GameSession.COLORS.red)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.custom_minimum_size.x = 280
	stack.add_child(title)
	var score := GameSession.label("總分  %d\n戰鬥回合  %d\n修復 Bug  %d　｜　投影片  %d" % [GameSession.score, GameSession.turn, GameSession.bugs_fixed, GameSession.slides], 23, GameSession.COLORS.paper)
	score.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stack.add_child(score)
	var retry := GameSession.button("再玩一次")
	retry.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	retry.focus_mode = Control.FOCUS_ALL
	retry.pressed.connect(_retry)
	stack.add_child(retry)
	var home := GameSession.button("回到首頁", GameSession.COLORS.teal)
	home.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	home.focus_mode = Control.FOCUS_ALL
	home.pressed.connect(GameSession.to_home)
	stack.add_child(home)
	retry.grab_focus()

func _retry() -> void:
	GameSession.begin_run()
	GameSession.to_battle()
