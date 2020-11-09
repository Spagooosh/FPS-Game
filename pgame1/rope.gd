extends RigidBody


var shoot = false


const SPEED = 0.2

func _ready():
	set_as_toplevel(true)
	
func _physics_process(_delta):
	if shoot:	
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED) 

	yield(get_tree().create_timer(0.00001), "timeout")
	queue_free() 
