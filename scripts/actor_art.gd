extends Control

var is_boss := false

func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(size.x / 130.0, size.y / 150.0))
	if is_boss:
		_draw_boss()
	else:
		_draw_student()

func _draw_student() -> void:
	var ink := Color("263449")
	var skin := Color("e6ab7c")
	var teal := Color("42b8a3")
	draw_circle(Vector2(65, 130), 48, Color(0, 0, 0, 0.18))
	draw_rect(Rect2(41, 87, 49, 41), teal)
	draw_rect(Rect2(48, 122, 15, 13), ink)
	draw_rect(Rect2(72, 122, 15, 13), ink)
	draw_rect(Rect2(37, 24, 59, 56), skin)
	draw_rect(Rect2(32, 17, 69, 19), ink)
	draw_rect(Rect2(32, 30, 11, 21), ink)
	draw_rect(Rect2(45, 49, 14, 5), Color("7d5360"))
	draw_rect(Rect2(72, 49, 14, 5), Color("7d5360"))
	draw_rect(Rect2(47, 56, 7, 5), ink)
	draw_rect(Rect2(77, 56, 7, 5), ink)
	draw_rect(Rect2(58, 70, 25, 3), Color("9c5e55"))
	draw_rect(Rect2(15, 101, 101, 20), Color("29364a"))
	draw_rect(Rect2(22, 98, 87, 6), teal)
	draw_rect(Rect2(51, 103, 29, 12), Color("8be1d2"))
	draw_rect(Rect2(63, 105, 5, 7), Color("f3c969"))

func _draw_boss() -> void:
	var ink := Color("342b3b")
	var red := Color("e15b64")
	draw_circle(Vector2(65, 134), 50, Color(0, 0, 0, 0.2))
	draw_colored_polygon(PackedVector2Array([Vector2(30, 48), Vector2(19, 7), Vector2(54, 31)]), Color("f3c969"))
	draw_colored_polygon(PackedVector2Array([Vector2(79, 31), Vector2(112, 7), Vector2(101, 50)]), Color("f3c969"))
	draw_colored_polygon(PackedVector2Array([Vector2(30, 72), Vector2(7, 124), Vector2(63, 111)]), ink)
	draw_colored_polygon(PackedVector2Array([Vector2(91, 72), Vector2(119, 124), Vector2(62, 111)]), ink)
	draw_rect(Rect2(35, 63, 61, 64), red)
	draw_rect(Rect2(39, 25, 53, 54), Color("bc424f"))
	draw_rect(Rect2(40, 44, 17, 7), Color("fff1d2"))
	draw_rect(Rect2(75, 44, 17, 7), Color("fff1d2"))
	draw_rect(Rect2(47, 45, 8, 5), ink)
	draw_rect(Rect2(76, 45, 8, 5), ink)
	draw_rect(Rect2(53, 63, 23, 5), ink)
	draw_rect(Rect2(57, 64, 4, 4), Color("fff1d2"))
	draw_rect(Rect2(68, 64, 4, 4), Color("fff1d2"))
