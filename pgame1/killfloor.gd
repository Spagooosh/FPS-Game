extends CollisionShape

onready var raycast = $RayCast
	
func _physics_process(delta):	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			get_tree().reload_current_scene()
	
