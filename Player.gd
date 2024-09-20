#TODO fix body falling through the ground
#IDEAS small shots don't turn you back; hitting the wall turns you back
extends RigidBody3D

var mouse_sensitivity := 0.001
var is_gun := false
var twist_input := 0.0
var pitch_input := 0.0
var jump_strength = 10.0  # Lower jump strength to avoid flying away
var move_speed := 7.0  # Speed for player movement
var is_on_ground := false

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var ground_ray := $GroundRayCast # Raycast to check if the player is grounded
@onready var camera := $TwistPivot/PitchPivot/Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	# Check if the player is on the ground using raycast
	is_on_ground = ground_ray.is_colliding()
	
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
	
	if Input.is_action_pressed("zoom"):
		is_gun = true
	else:
		is_gun = false
		
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	if !is_gun:
		pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
			deg_to_rad(-35), 
			deg_to_rad(35)
		)
	twist_input = 0.0
	pitch_input = 0.0


func _unhandled_input(event : InputEvent):
	if camera.is_zooming and !camera.is_zoomed:
		return
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity

