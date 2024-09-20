extends Camera3D

var default_fov := 75.0
var default_pos := Vector3(0, 0, 3)
var default_pitch := Vector3(deg_to_rad(-10), 0, 0)

var is_zooming := false
var is_zoomed := false
var zoom_speed := 25.
var close_fov := 27.
var close_pos := Vector3(0.55, -0.75, 3)
var close_pitch := Vector3(deg_to_rad(2.5), 0, 0)

@onready var camera := $"."
@onready var pitch := $".."
@onready var twist := $"../.."

@onready var body_mesh := $"../../../body_mesh"
@onready var body_collision := $"../../../body_collision"
@onready var gun_mesh := $"../../../gun_mesh"
@onready var gun_collision := $"../../../gun_collision"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("zoom") and !is_zoomed:
		is_zooming = true
		camera.fov = lerp(camera.fov, close_fov, delta * zoom_speed)
		camera.position = camera.position.lerp(close_pos, delta * zoom_speed)
		pitch.rotation = pitch.rotation.lerp(close_pitch, delta * zoom_speed)
		
		body_mesh.visible = false
		body_collision.disabled = true
		gun_mesh.visible = true
		gun_collision.disabled = false
		
		if floor(camera.fov - 0.3) == close_fov:
			camera.position = close_pos
			pitch.rotation = close_pitch
			is_zoomed = true
	
	if !Input.is_action_pressed("zoom") and is_zooming:
		is_zoomed = false
		camera.fov = lerp(camera.fov, default_fov, delta * zoom_speed)
		camera.position = camera.position.lerp(default_pos, delta * zoom_speed)
		pitch.rotation = pitch.rotation.lerp(default_pitch, delta * zoom_speed)
		
		body_mesh.visible = true
		body_collision.disabled = false
		gun_mesh.visible = false
		gun_collision.disabled = true
		
		if ceil(camera.fov) == default_fov:
			camera.position = default_pos
			pitch.rotation = default_pitch
			is_zooming = false
		
	
