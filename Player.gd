#TODO bullet count, remaining orbs count
#IDEAS fixed N of shots per lvl
extends RigidBody3D

var mouse_sensitivity := 0.001
var shot := false
var twist_input := 0.0
var pitch_input := 0.0
var jump_strength = 15.0  # Lower jump strength to avoid flying away
var move_speed := 4.5  # Speed for player movement
var is_on_ground := false

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var ground_ray := $GroundRayCast # Raycast to check if the player is grounded
@onready var camera := $TwistPivot/PitchPivot/SpringArm3D/Camera3D
@onready var gun_mesh := $gun_mesh
@onready var animation := $body_collision/spider.get_child(1)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.is_gun = false
	animation.speed_scale = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	# Check if the player is on the ground using raycast
	is_on_ground = ground_ray.is_colliding()
	
	if Input.is_action_just_pressed("look_back"):
		$TwistPivot/back_cam.current = true
	
	if Input.is_action_just_released("look_back"):
		$TwistPivot/PitchPivot/SpringArm3D/Camera3D.current = true
	
	#block movement when gun
	if !Global.is_gun:
		# If on ground, allow movement, else limit air controll
		if is_on_ground:
			# Calculate movement direction based on player rotation
			var move_direction = twist_pivot.basis * input.normalized()* move_speed
			linear_velocity.x = move_direction.x
			linear_velocity.z = move_direction.z
		else:
			# controll while in air
			apply_central_force(twist_pivot.basis * input * 150 * move_speed * delta)
		
		
	# Handle jumping: only allow jump when on the ground
	if is_on_ground and Input.is_action_pressed("move_jump"):
		linear_velocity.y = jump_strength  # Apply upward velocity
	
	if Global.is_gun:
		if Input.is_action_just_pressed("shoot"):
			shot = true
			Global.bullets_left -= 1
			if(Global.is_on_target):
				Global.target.eye_die()
					
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	if !Global.is_gun:
		pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
			deg_to_rad(-35), 
			deg_to_rad(35)
		)
	
	if Input.is_action_just_pressed("zoom") and Global.bullets_left > 0:
		animation.speed_scale = 3
		animation.play("zoom")
	elif Input.is_action_just_released("zoom") and Global.bullets_left > 0:
		animation.speed_scale = -3
		animation.play("zoom")
	elif !camera.is_zooming:
		if Input.is_action_pressed("move_animation"):
			animation.speed_scale = 1
			animation.play("walk")
		elif Input.is_action_just_released("move_animation"):
			animation.speed_scale = 0
			#animation.play("idle")

	var target_rotation = twist_pivot.rotation.y + deg_to_rad(-90)
	var current_rotation = $body_collision.rotation.y

	$body_collision.rotation.y = lerp_angle(current_rotation, target_rotation, delta * 15)
	
	twist_input = 0.0
	pitch_input = 0.0

func reset_animation():
	animation.play("idle")

func _unhandled_input(event : InputEvent):
	if camera.is_zooming and !Global.is_gun:
		return
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity
