extends Camera3D

var default_fov := 75.0
var default_pos := Vector3.ZERO
var default_pitch := Vector3(deg_to_rad(-10), 0, 0)
var default_twist := Vector3(0, 0, 0)

var is_zooming := false
var zoom_speed := 25.
var close_fov := 27.
var close_pos := Vector3(0.75, -0.70, 0)
var close_pitch := Vector3(deg_to_rad(2.5), 0, 0)
var close_twist := Vector3(0, deg_to_rad(5), 0)
var TO = false
var rot_speed := 16.

@onready var camera := $"."
@onready var spring_arm := $".."
@onready var pitch := $"../.."
@onready var twist := $"../../.."
@onready var player := $"../../../.."

@onready var spider := $"../../../../body_collision/spider"
@onready var body_collision := $"../../../../body_collision"
@onready var gun_mesh := $"../../../../gun_mesh"
@onready var gun_collision := $"../../../../gun_collision"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("zoom") and !Global.is_gun and !TO:
		is_zooming = true
		camera.fov = lerp(camera.fov, close_fov, delta * zoom_speed)
		spring_arm.position = spring_arm.position.lerp(close_pos, delta * zoom_speed)
		pitch.rotation = pitch.rotation.lerp(pitch.rotation + close_pitch, delta * zoom_speed)
		twist.rotation = twist.rotation.lerp(twist.rotation + close_twist, delta * zoom_speed)
		Engine.time_scale = lerp(1., 0.7, 2)
		
		if floor(camera.fov - 0.3) == close_fov:
			Engine.time_scale = 0.05
			player.lock_rotation = false
			var rng = RandomNumberGenerator.new() 
			player.angular_velocity = Vector3(rng.randf_range(-1,1),
			rng.randf_range(-1,1),
			rng.randf_range(-1,1)
			)
			player.physics_material_override.bounce = 0.5
			player.mass = 0.1
			#player.lock_rotation = false
			body_collision.disabled = true
			spider.visible = false
			gun_mesh.visible = true
			gun_collision.disabled = false
			spring_arm.position = close_pos
			#pitch.rotation = close_pitch
			#twist.rotation = close_twist
			Global.is_gun = true
	
	if !TO:
		gun_mesh.rotation = twist.rotation + pitch.rotation - close_pitch - close_twist
		gun_collision.rotation = gun_mesh.rotation
	
	#spin gun after shot around X
	if TO:
		rot_speed = lerp(rot_speed, 0., 1.5*delta)
		gun_mesh.rotate_object_local(Vector3(1, 0, 0), rot_speed*delta)
		gun_collision.rotate_object_local(Vector3(1, 0, 0), rot_speed*delta)
		
	
	#after shot
	if player.shot and Global.is_gun:
		if !TO:
			TO = true
			#timer start
			rot_speed = 16
			player.lock_rotation = true
			Engine.time_scale = 1
			
			player.apply_central_impulse(gun_mesh.transform.basis.z * 7)
			camera.fov = default_fov
			spring_arm.position = default_pos
			twist.rotation = twist.rotation - close_twist
			pitch.rotation = Vector3.ZERO
			await get_tree().create_timer(2).timeout
		else:
			return
		#timer end
		#player.lock_rotation = true
		player.rotation = Vector3.ZERO
		TO = false
		player.shot = false
		twist.rotation = player.rotation + default_twist
		pitch.rotation = player.rotation + default_pitch
		unzoom(delta)
		Global.is_gun = false
		player.position.y += 0.5 
	elif !Input.is_action_pressed("zoom") and is_zooming:
		unzoom(delta)
		
	
	#prevent player from falling through the ground and rotating
	if Input.is_action_just_released("zoom") and Global.is_gun:
		player.lock_rotation = true
		player.rotation = Vector3.ZERO
		Global.is_gun = false
		player.position.y += 1 
	
	#used to prevent a bug where gun slowly falls down
	if player.linear_velocity.y == 0:
		player.linear_velocity.y = -5

func unzoom(delta):
	Engine.time_scale = 1
	player.physics_material_override.bounce = 0
	player.mass = 1
	player.lock_rotation = true
	camera.fov = lerp(camera.fov, default_fov, delta * zoom_speed)
	spring_arm.position = spring_arm.position.lerp(default_pos, delta * zoom_speed)
	pitch.rotation = pitch.rotation.lerp(default_pitch, delta * zoom_speed)
	twist.rotation = twist.rotation.lerp(twist.rotation - close_twist, delta * zoom_speed)
	
	spider.visible = true
	body_collision.disabled = false
	gun_mesh.visible = false
	gun_collision.disabled = true
	
	if ceil(camera.fov) == default_fov:
		player.linear_velocity.y = -5
		spring_arm.position = default_pos
		pitch.rotation = default_pitch
		twist.rotation = twist.rotation - close_twist
		is_zooming = false
