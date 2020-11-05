extends Spatial


onready var b_decal = preload("res://Assets/BulletHole.tscn")

func _ready():
	$Pause.hide()

func _process(_delta):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
