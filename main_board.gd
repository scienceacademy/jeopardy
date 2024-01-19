extends MarginContainer

var _mb = load("res://money_box.tscn")
var _h = load("res://header.tscn")
@onready var grid = $GridContainer
var double_jep = true
var final_jep = false
var num_left = 0
var doubles = 2 if double_jep else 1

var categories = []
var questions = []
var filepath1 = "res://trivia8-end1.cfg"
var filepath2 = "res://trivia8-end2.cfg"
var game = filepath2

func _ready():
	load_data(game)
	load_questions()
	$CanvasLayer/Question.hide()
	$CanvasLayer/DD.hide()

func load_data(file):
	var data = ConfigFile.new()
	var err = data.load(file)
	if err != OK:
		get_tree().quit()

	categories = data.get_sections()
	print(categories)
	for cat in categories:
		var qs = []
		var keys = data.get_section_keys(cat)
		for k in keys:
			qs.append(data.get_value(cat, k))
		questions.append(qs)
		prints(cat, qs)
#	var file = FileAccess.open(filepath, FileAccess.READ)
#	var cat = -1
##	for cat in 6:
##		categories.append(file.get_line())
#	while not file.eof_reached():
#		var s = file.get_line()
#		if s[-1] == ":":
#			categories.append(s.left(-1))
#
#	print(categories)

func load_questions():
	for i in 6:
		var h = _h.instantiate()
		grid.add_child(h)
		h.text = categories[i]
	for i in 30:
		var l = _mb.instantiate()
		grid.add_child(l)
		var amt = (1 + i / 6) * 100
		amt = amt * 2 if double_jep else amt
		l.text = "$" + str(amt)
		l.gui_input.connect(_on_clicked.bind(l))
		l.column = i % 6
		l.row = i / 6
		num_left += 1

func _input(ev):
	if ev.is_action_pressed("correct"):
		$Correct.play()
	if ev.is_action_pressed("times_up"):
		$TimesUp.play()
	if ev.is_action_pressed("final"):
		$CanvasLayer.hide()

func _on_clicked(ev, l):
	if ev is InputEventMouseButton and ev.pressed:
#		prints(l.text, l.column, " clicked")
		l.text = ""
		l.gui_input.disconnect(_on_clicked)
		if ev.shift_pressed and doubles > 0:
			doubles -= 1
			$CanvasLayer/DD.show()
			$DailyDouble.play()
#			await get_tree().create_timer(4.0).timeout
#			$CanvasLayer/DD.hide()
		show_question(l.column, l.row)

func show_question(col, row):
	$CanvasLayer/Question/Label.text = questions[col][row]
	$CanvasLayer/Question.show()
	prints(col, row)


func _on_question_gui_input(ev):
	if ev is InputEventMouseButton and ev.double_click:
		$CanvasLayer/Question.hide()
		num_left -= 1
