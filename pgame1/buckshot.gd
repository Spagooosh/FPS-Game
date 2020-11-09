extends RigidBody

onready var coll = $CollisionShape
var shoot = false

const SPEED = 7

func _ready():
	set_as_toplevel(true)
	
func _physics_process(delta):
	if shoot:	
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED) 
		
		
		
	
