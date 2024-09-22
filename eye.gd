extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

signal emit_orbs_cleared

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	eye_die()

func eye_die():
	print("I am die")
	Global.orbs_left -= 1
	queue_free()
	if Global.orbs_left < 1:
		emit_signal("emit_orbs_cleared")

