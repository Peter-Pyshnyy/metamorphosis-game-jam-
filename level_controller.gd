extends Node

const FILE_BEGIN = "res://levels/level_"

var level_info = {
	1 : [0, 1],
	2 : [1, 1],
	3 : [2, 2],
	4 : [1, 2],
	5 : [2, 3],
	6 : [1, 1],
	7 : [1, 3]
}

func _ready():
	var current_lvl = get_tree().current_scene.scene_file_path.to_int()
	Global.bullets_left = level_info[current_lvl][0]
	Global.orbs_left = level_info[current_lvl][1]

func restart_level():
	SceneTransition.reload_current_scene()

func next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	if next_level_number < 8:
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		SceneTransition.get_child(0).text = str(next_level_number) + "/7"
		SceneTransition.change_scene(next_level_path)
		Global.bullets_left = level_info[next_level_number][0]
		Global.orbs_left = level_info[next_level_number][1]
	else:
		print("FINITP")


func _on_area_3d_emit_orbs_cleared():
	
		next_level()
