extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

signal emit_orbs_cleared
signal emit_orb_dead
signal emit_the_end

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if Global.current_lvl == 8:
		emit_signal("emit_the_end")
		queue_free()
	else:
		eye_die()

func eye_die():
	Global.orbs_left -= 1
	emit_signal("emit_orb_dead")
	queue_free()
	if Global.orbs_left < 1:
		emit_signal("emit_orbs_cleared")
