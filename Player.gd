extends CharacterBody2D

const SPEED = 300.0
const SPEED_MULTIPLIER = 1.5

func _ready():
	$moveAnimatedSprite.pause()

func _physics_process(delta):
	var direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var multiplicador = 1.0
	
	if Input.is_key_pressed(KEY_SHIFT):
		multiplicador = SPEED_MULTIPLIER
	
	if direccion.length() > 0:
		$moveAnimatedSprite.play()
		velocity = direccion.normalized() * SPEED * multiplicador
		$moveAnimatedSprite.flip_h = direccion.x < 0
	else:
		$moveAnimatedSprite.stop()
		velocity = Vector2(0, 0)
		
	move_and_slide()
