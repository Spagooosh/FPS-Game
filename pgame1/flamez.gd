extends Spatial

var able = true
var flaming = false
var damage = 1.5
onready var fl_box = $MeshInstance/Area
onready var timer = $MeshInstance/Timer
onready var particles = $MeshInstance/Particles
onready var audio = $MeshInstance/AudioStreamPlayer
onready var t2 = $MeshInstance/AudioStreamPlayer/Timer2

func _process(_delta):
	
	if Input.is_action_just_pressed("flame"):
		if able == true:
			if not flaming:
				flaming = true
				if flaming:
					timer.start()
					particles.emitting = true
					audio.play()
					t2.start()
					able = false
			yield(get_tree().create_timer(2.5), "timeout")
			flaming = false
		if flaming == false:
			timer.stop()
			audio.stop()
			t2.stop()
			particles.emitting = false
			able = false
			yield(get_tree().create_timer(15), "timeout")
			able = true
			
func _on_Timer_timeout():
	var enemies = fl_box.get_overlapping_bodies()
	
	for e in enemies:
		if e.is_in_group("Enemy"):
			e.health -= damage
		
func _on_Timer2_timeout():
	audio.play()


