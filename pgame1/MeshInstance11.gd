extends MeshInstance

var gravity = 2.7
var capncrunch = Vector3()
var air_time = 0.0
var BONUS_GRAVITY = 2.0
func _physics_process(delta):
		
	if is_on_floor():
		air_time = 0.0
	else:
			air_time += delta
			
	capncrunch.y -= (gravity * gravity * air_time * BONUS_GRAVITY) * delta


	if not is_on_floor():
		capncrunch.y -= gravity * delta
	
	move_and_slide(capncrunch, Vector3.UP)
