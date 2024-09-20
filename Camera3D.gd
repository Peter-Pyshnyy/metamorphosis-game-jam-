extends Camera3D

var default_fov := 75.0
var default_pos := Vector3(0, 0, 3)
var default_pitch := Vector3(deg_to_rad(-10), 0, 0)
var default_twist := Vector3(0, 0, 0)

var is_zooming := false
var is_zoomed := false
var zoom_speed := 25.
var close_fov := 27.
var close_pos := Vector3(0.75, -0.70, 3)
var close_pitch := Vector3(deg_to_rad(2.5), 0, 0)
var close_twist := Vector3(0, deg_to_rad(5), 0)

@onready var camera := $"."
@onready var pitch := $".."
@onready var twist := $"../.."
@onready var player := $"../../.."

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
		pitch.rotation = pitch.rotation.lerp(pitch.rotation + close_pitch, delta * zoom_speed)
		twist.rotation = twist.rotation.lerp(twist.rotation + close_twist, delta * zoom_speed)
		Engine.time_scale = lerp(1., 0.7, 2)
		
		print(pitch.rotation)
		
		if floor(camera.fov - 0.3) == close_fov:
			Engine.time_scale = 0.025
			body_collision.disabled = true
			body_mesh.visible = false
			gun_mesh.visible = true
			gun_collision.disabled = false
			camera.position = close_pos
			#pitch.rotation = close_pitch
			#twist.rotation = close_twist
			is_zoomed = true
	
	gun_mesh.rotation = twist.rotation + pitch.rotation - close_pitch - close_twist
	
	if !Input.is_action_pressed("zoom") and is_zooming:
		is_zoomed = false
		Engine.time_scale = 1
		camera.fov = lerp(camera.fov, default_fov, delta * zoom_speed)
		camera.position = camera.position.lerp(default_pos, delta * zoom_speed)
		pitch.rotation = pitch.rotation.lerp(default_pitch, delta * zoom_speed)
		twist.rotation = twist.rotation.lerp(twist.rotation - close_twist, delta * zoom_speed)
		
		body_mesh.visible = true
		body_collision.disabled = false
		gun_mesh.visible = false
		gun_collision.disabled = true
		
		if ceil(camera.fov) == default_fov:
			player.linear_velocity.y = -5
			camera.position = default_pos
			pitch.rotation = default_pitch
			twist.rotation = twist.rotation - close_twist
			is_zooming = false
	
	#used to prevent a bug where gun slowly falls down
	if player.linear_velocity.y == 0:
		player.linear_velocity.y = -5
	
