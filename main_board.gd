extends MarginContainer

var _mb = load("res://money_box.tscn")
var _h = load("res://header.tscn")
@onready var grid = $GridContainer
var double_jep = false
var final_jep = false
var num_left = 0
var doubles = 2 if double_jep else 1

#var categories = ["A", B", "C", "D", "E", "F"]
#var questions = [
#	["a1", "a2", "a3", "a4", "a5"],
#	["b1", "b2", "b3", "b4", "b5"],
#	["c1", "c2", "c3", "c4", "c5"],
#	["d1", "d2", "d3", "d4", "d5"],
#	["e1", "e2", "e3", "e4", "e5"],
#	["f1", "f2", "f3", "f4", "f5"],
#]

var categories = []
var questions = []
var filepath1 = "res://trivia8-1.cfg"
var filepath2 = "res://trivia8-2.cfg"
var filepath3 = "res://trivia7-1.cfg"
var game = filepath3
#var categories = ["Creative Development", "Data", "Algorithms & Programming", "Computing & Networks", "Impact of Computing", "Misc"]
#var questions = [
#	[
#		"A mistake in code that violates the rules of the programming language",
#		"A set of 8 bits",
#		"The system of one byte numbers assigned to each character on the US keyboard",
#		"Allows a solution to a large problem to be based on solutions to smaller problems by creating procedures/functions.",
#		"A group of functions that may be used to assist in creating new programs"
#	],
#	[
#		"This error results when the number of bits is not enough to hold a number",
#		"The error that results when the number of bits is not enough to represent the number accurately",
#		"Compressing data in a way that throws some data away",
#		"Compressing data in a way that preserves all data and allows full recovery",
#		"Data about data, such as a camera storing the location of a photo"
#	],
#	[
#		"The order of code, one line after another",
#		"A Boolean condition to determine which of two paths to take, aka if-then",
#		"Using a looping control structure to repeat a sequence of operations on a set of data",
#		"A search algorithm also known as 'divide and conquer'",
#		"A problem so logically difficult, we can't ever create an algorithm that would be able to find an answer"
#	],
#	[
#		"An identifier assigned to each device on the internet, allowing it to communicate with other devices",
#		"Encoding information using fewer bits than the original representation",
#		"The communication protocol used on the Internet to send packets of data between computers",
#		"The hierarchical, decentralized naming system for computers connected to the Internet",
#		"A cryptographic system that uses pairs of keys: public keys distributed widely, and private keys, kept secret"
#	],
#	[
#		"The idea that some communities / populations have less access to computing than others",
#		"Asking lots of users online to help with something, such as funding a project or contributing data",
#		"An attempt to obtain sensitive information by posing as a trustworthy entity in an electronic communication", 
#		"Any software used to disrupt operations, gather sensitive information, or gain unauthorized access",
#		"An alternative to copyright that allows people to declare how they want their artistic creations to be shared, remixed, and used"
#	],
#	[
#		"The principle that internet service providers should enable access without favoring or blocking particular sources", 
#		"The maximum amount of data that can be sent in a period of time over a network connection", 
#		"A small amount of text stored in the browser that tracks information about a user visiting a website", 
#		"A 'rule' used to guide an algorithm", 
#		"The protocol used for transmitting web pages over the internet"
#	],
#]

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
	for cat in categories:
		var qs = []
		var keys = data.get_section_keys(cat)
		for k in keys:
			qs.append(data.get_value(cat, k))
		questions.append(qs)
		print(questions)
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
