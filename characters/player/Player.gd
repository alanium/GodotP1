extends CharacterBody2D

const SPEED = 300.0
const SPEED_MULTIPLIER = 1.5
const FLIP_ANIMATION_SPEED = 15.0 

var target_scale = Vector2(1, 1)
var current_scale = Vector2(1, 1)

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
		
		if direccion.x < 0:
			target_scale.x = -1
		else:
			target_scale.x = 1
	else:
		$moveAnimatedSprite.stop()
		velocity = Vector2(0, 0)
		
	current_scale.x = lerp(current_scale.x, target_scale.x, FLIP_ANIMATION_SPEED * delta)
	$moveAnimatedSprite.scale.x = current_scale.x
		
	move_and_slide()
