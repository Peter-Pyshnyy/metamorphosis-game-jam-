extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body == $MeshInstance3D/sb3d_eye:
		return
	else:
		print(body.name)
		eye_die()

func eye_die():
	print("I am die")
	queue_free()
