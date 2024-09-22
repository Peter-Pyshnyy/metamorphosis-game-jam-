extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_mouse_entered():
	print($"..".position)
	position.y -= 5


func _on_mouse_exited():
	position.y += 5


func _on_button_down():
	SceneTransition.change_scene("res://levels/level_1.tscn")


func _on_button_2_mouse_entered():
	$"../Button2".position.y -= 2


func _on_button_2_mouse_exited():
	$"../Button2".position.y += 2


func _on_button_2_button_down():
	get_tree().quit()
