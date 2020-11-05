extends RigidBody

var shoot = false

const speed = 30
const damage = 20

func _ready():
	set_as_toplevel(true)


func _physics_process(_delta):
	if shoot:	
		apply_impulse(transform.basis.z, -transform.basis.z * speed)
		
func _on_Area_body_entered(body):
		if body.is_in_group("Enemy"):
			body.health -= damage
			queue_free()
		else:
			queue_free()
