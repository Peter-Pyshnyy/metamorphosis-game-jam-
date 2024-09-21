extends RayCast3D

@onready var beam_mesh := $beamMesh
@onready var end_particles := $beamMesh/end_particle

var on_target := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cast_point
	force_raycast_update()
	
	
	
	if is_colliding():
		if get_collider().is_class("Area3D"):
			Global.is_on_target = true
			Global.target = get_collider()
		else:
			Global.is_on_target = false
		
		cast_point = to_local(get_collision_point())
		
		beam_mesh.visible = true
		beam_mesh.mesh.height = cast_point.y
		beam_mesh.position.y = cast_point.y/2
		
		end_particles.position.y = cast_point.y*0.5
	else:
		beam_mesh.visible = false
