extends Control

const ActorArt = preload("res://scripts/actor_art.gd")
var enemy_art: Control
var duel_container: HBoxContainer

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = GameSession.COLORS.paper
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 24)
	for side in ["top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 20)
	add_child(margin)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 12)
	margin.add_child(stack)
	stack.add_child(GameSession.label("最終死線  /  期末報告戰", 30, GameSession.COLORS.ink))
	var stats := HFlowContainer.new()
	stats.alignment = FlowContainer.ALIGNMENT_CENTER
	stats.add_theme_constant_override("h_separation", 18)
	stats.add_theme_constant_override("v_separation", 4)
	stack.add_child(stats)
	var score_label := GameSession.label("分數  0", 24, GameSession.COLORS.ink)
	var hp_label := GameSession.label("理智  100 / 100", 24, GameSession.COLORS.teal)
	var boss_label := GameSession.label("Deadline  180 / 180", 24, GameSession.COLORS.red)
	for widget in [score_label, hp_label, boss_label]:
		stats.add_child(widget)
	var arena_panel := GameSession.panel(GameSession.COLORS.ink)
	arena_panel.custom_minimum_size.y = 190
	arena_panel.size_flags_vertical = Control.SIZE_FILL
	stack.add_child(arena_panel)
	var arena := CenterContainer.new()
	arena.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	arena.size_flags_vertical = Control.SIZE_EXPAND_FILL
	arena_panel.add_child(arena)
	duel_container = HBoxContainer.new()
	duel_container.alignment = BoxContainer.ALIGNMENT_CENTER
	duel_container.add_theme_constant_override("separation", 42)
	arena.add_child(duel_container)
	duel_container.add_child(_character("資通系大四生\n筆電電量 3%", false))
	var enemy_card := _character("大魔王 Deadline\n期末死線", true)
	duel_container.add_child(enemy_card)
	enemy_art = enemy_card.get_child(0) as Control
	var status := GameSession.label("回合 1｜" + GameSession.last_action, 22, GameSession.COLORS.ink)
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stack.add_child(status)
	var actions := HFlowContainer.new()
	actions.alignment = FlowContainer.ALIGNMENT_CENTER
	actions.add_theme_constant_override("h_separation", 12)
	actions.add_theme_constant_override("v_separation", 8)
	stack.add_child(actions)
	for entry in [["攻擊", "attack", GameSession.COLORS.orange], ["修復 Bug", "skill", GameSession.COLORS.teal], ["收集投影片", "item", GameSession.COLORS.yellow]]:
		var b := GameSession.button(entry[0], entry[2])
		b.focus_mode = Control.FOCUS_ALL
		actions.add_child(b)
		var action: String = entry[1]
		b.pressed.connect(func(): _take_turn(action, status, score_label, hp_label, boss_label))
	actions.get_child(0).grab_focus()
	get_viewport().size_changed.connect(_apply_compact_layout)
	_apply_compact_layout()

func _apply_compact_layout() -> void:
	var compact := get_viewport_rect().size.x < 620
	if duel_container:
		duel_container.add_theme_constant_override("separation", 10 if compact else 42)
		for card in duel_container.get_children():
			card.custom_minimum_size.x = 102 if compact else 140
			var figure := card.get_child(0) as Control
			figure.custom_minimum_size = Vector2(92, 105) if compact else Vector2(130, 150)
			var caption := card.get_child(1) as Label
			caption.add_theme_font_size_override("font_size", 14 if compact else 18)
			caption.custom_minimum_size.x = 100 if compact else 140

func _character(caption: String, boss: bool) -> Control:
	var card := VBoxContainer.new()
	card.add_theme_constant_override("separation", 10)
	var figure := ActorArt.new()
	figure.is_boss = boss
	figure.custom_minimum_size = Vector2(130, 150)
	figure.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	card.add_child(figure)
	var text := GameSession.label(caption, 18, GameSession.COLORS.paper)
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card.add_child(text)
	return card

func _take_turn(action: String, status: Label, score_label: Label, hp_label: Label, boss_label: Label) -> void:
	if GameSession.boss_hp <= 0 or GameSession.player_hp <= 0:
		return
	GameSession.turn += 1
	var damage := 18
	var msg := "你發動筆電重擊！"
	if action == "skill":
		damage = 28
		GameSession.bugs_fixed += 1
		GameSession.score += 25
		msg = "Bug 修復完成！額外傷害 + 得分。"
	elif action == "item":
		damage = 8
		GameSession.slides += 1
		GameSession.score += 20
		msg = "找回一頁組員投影片！進度 +1。"
	GameSession.boss_hp = maxi(0, GameSession.boss_hp - damage)
	GameSession.score += damage
	GameSession.play_sfx("hit" if action == "attack" else "collect")
	var flash := create_tween()
	enemy_art.modulate = Color("ffaaaa")
	flash.tween_property(enemy_art, "modulate", Color.WHITE, 0.2)
	var nudge := create_tween()
	enemy_art.position.x += 10
	nudge.tween_property(enemy_art, "position:x", enemy_art.position.x - 10, 0.16)
	if GameSession.boss_hp > 0:
		var hit := 9 + int(GameSession.turn / 3)
		GameSession.player_hp = maxi(0, GameSession.player_hp - hit)
		msg += " Deadline 反擊，理智 -%d。" % hit
		if GameSession.turn % 2 == 0:
			GameSession.player_hp = maxi(0, GameSession.player_hp - 4)
			msg += " 組員失聯趁亂攻擊 -4！"
		if GameSession.turn % 3 == 0:
			GameSession.player_hp = maxi(0, GameSession.player_hp - 5)
			msg += " 教授靈魂拷問追加 -5！"
	GameSession.last_action = msg
	status.text = "回合 %d｜%s" % [GameSession.turn, msg]
	var pulse := create_tween()
	status.scale = Vector2(1.08, 1.08)
	pulse.tween_property(status, "scale", Vector2.ONE, 0.18)
	score_label.text = "分數  %d" % GameSession.score
	hp_label.text = "理智  %d / 100" % GameSession.player_hp
	boss_label.text = "Deadline  %d / 180" % GameSession.boss_hp
	if GameSession.boss_hp == 0:
		GameSession.to_results(true)
	elif GameSession.player_hp == 0:
		GameSession.to_results(false)
