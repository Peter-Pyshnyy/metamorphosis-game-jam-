extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_button_down():
	$"../Label".visible = false
	$"../Label2".visible = false
	$"../Label3".visible = false
	$"../Label4".visible = false
	visible = false
	
	$"../TextureRect".visible = true
	$"../TextureRect2".visible = true
	$"../TextureRect3".visible = true
	$"../TextureRect4".visible = true
