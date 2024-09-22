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

var current_lvl_number : int

func _ready():
	var current_lvl_number = get_tree().current_scene.scene_file_path.to_int()
	Global.bullets_on_level = level_info[current_lvl_number][0]
	Global.orbs_on_level = level_info[current_lvl_number][1]

func restart_level():
	SceneTransition.reload_current_scene()

func next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	if next_level_number < 8:
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		SceneTransition.get_child(2).get_child(0).get_child(0).text = str(next_level_number) + "/7"
		SceneTransition.change_scene(next_level_path)
		Global.bullets_left = level_info[next_level_number][0]
		Global.orbs_left = level_info[next_level_number][1]
	else:
		get_tree().quit()

func get_level_bullets():
	return level_info[current_lvl_number][0]

func get_level_orbs():
	return level_info[current_lvl_number][1]

func _on_area_3d_emit_orbs_cleared():
	
		next_level()
