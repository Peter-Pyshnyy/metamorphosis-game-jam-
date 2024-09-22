extends Node

@export var animation_tree : AnimationTree
@export var player : CharacterBody3D
@onready var spider := $"../spider"

var tween : Tween


func _on_player_emit_is_moving(state : int):
	print("HELo")
	if tween:
		tween.kill()
	
	var AT = spider.get_child(2)
	tween = create_tween()
	tween.tween_property(animation_tree, AT.get_path(), state, 0.25)
