extends CharacterBody2D

const SPEED = 300.0
const SPEED_MULTIPLIER = 1.5
const FLIP_ANIMATION_SPEED = 15.0
const STAMINA_DEPLETION_RATE = 2  # Tasa de disminución de la stamina por frame

var target_scale = Vector2(1, 1)
var current_scale = Vector2(1, 1)

var maxHealth : int = 10
var health : int = maxHealth

var maxStamina : int = 10
var stamina : float = maxStamina  # Usamos float para permitir valores decimales para la stamina

var healthLabel : Label
var staminaLabel : Label

func _ready():
	$moveAnimatedSprite.pause()
	# Obtén las referencias a las etiquetas en la escena
	healthLabel = $HealthLabel
	staminaLabel = $StaminaLabel
	
	# Actualiza los valores iniciales de las etiquetas
	updateHealthLabel()
	updateStaminaLabel()

func _physics_process(delta):
	var direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var multiplicador = 1.0
	
	if Input.is_key_pressed(KEY_SHIFT) and stamina > 0 and direccion:
		multiplicador = SPEED_MULTIPLIER
		stamina -= STAMINA_DEPLETION_RATE * delta  # Reduce la stamina mientras corres
		if stamina < 0:
			stamina = 0
	else:
		# Recupera la stamina cuando no estás corriendo
		stamina += STAMINA_DEPLETION_RATE * delta
		if stamina > maxStamina:
			stamina = maxStamina
	
	if stamina < 0:
		stamina = 0
	
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

	# Actualiza las etiquetas en cada frame
	updateHealthLabel()
	updateStaminaLabel()

func updateHealthLabel():
	# Actualiza el texto de la etiqueta de vida
	healthLabel.text = "Health: " + str(health) + "/" + str(maxHealth)

func updateStaminaLabel():
	# Actualiza el texto de la etiqueta de stamina
	staminaLabel.text = "Stamina: " + str(round(stamina)) + "/" + str(maxStamina)
