extends Camera3D

var default_fov := 75.0
var default_pos := Vector3(0, 0, 3)
var default_pitch := Vector3(deg_to_rad(-10), 0, 0)

var is_zooming := false
var is_zoomed := false
var zoom_speed := 30.
var close_fov := 20.0
var close_pos := Vector3(0.35, 0, 3)
var close_pitch := Vector3(deg_to_rad(2.5), 0, 0)

@onready var camera := $"."
@onready var pitch := $".."
@onready var twist := $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#TODO: lock cam movement while zooming
	if Input.is_action_pressed("zoom") and !is_zoomed:
		is_zooming = true
		camera.fov = lerp(camera.fov, close_fov, delta * zoom_speed)
		camera.position = camera.position.lerp(close_pos, delta * zoom_speed)
		pitch.rotation = pitch.rotation.lerp(close_pitch, delta * zoom_speed)
		
		if floor(camera.fov) == close_fov:
			camera.position = close_pos
			pitch.rotation = close_pitch
			is_zoomed = true
	
	if !Input.is_action_pressed("zoom") and is_zooming:
		is_zoomed = false
		camera.fov = lerp(camera.fov, default_fov, delta * zoom_speed)
		camera.position = camera.position.lerp(default_pos, delta * zoom_speed)
		pitch.rotation = pitch.rotation.lerp(default_pitch, delta * zoom_speed)
		
		print(pitch.rotation)
		
		if ceil(camera.fov) == default_fov:
			camera.position = default_pos
			pitch.rotation = default_pitch
			is_zooming = false
		
	
