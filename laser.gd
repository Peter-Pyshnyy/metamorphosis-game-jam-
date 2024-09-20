extends RayCast3D

@onready var beam_mesh := $beamMesh
@onready var end_particles := $beamMesh/end_particle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("here")
	
	var cast_point
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
		beam_mesh.visible = true
		beam_mesh.mesh.height = cast_point.y
		beam_mesh.position.y = cast_point.y/2
		
		end_particles.position.y = cast_point.y*0.5
	else:
		beam_mesh.visible = false
