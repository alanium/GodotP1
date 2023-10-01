extends CharacterBody2D

const SPEED = 300.0
const SPEED_MULTIPLIER = 3
const FLIP_ANIMATION_SPEED = 15.0
const STAMINA_DEPLETION_RATE = 10  # Tasa de disminución de la stamina por frame

var target_scale = Vector2(1, 1)
var current_scale = Vector2(1, 1)

var maxHealth : int = 10
var health : int = maxHealth

var maxStamina : int = 10
var stamina : float = maxStamina  # Usamos float para permitir valores decimales para la stamina

var healthLabel : Label
var staminaLabel : Label

var isRecharging : bool = false
var rechargeTimer : float = 3.0
var rechargeCooldownTimer: float = 0.0


func _ready():
	$moveAnimatedSprite.pause()
	# Obtén las referencias a las etiquetas en la escena
	healthLabel = $HealthLabel
	staminaLabel = $StaminaLabel
	
	# Actualiza los valores iniciales de las etiquetas
	updateHealthLabel()
	updateStaminaLabel()

func _physics_process(delta):
	# Restante del temporizador de recarga
	if rechargeCooldownTimer > 0.0:
		rechargeCooldownTimer -= delta
		if rechargeCooldownTimer <= 0.0:
			isRecharging = true

	var direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var multiplicador = 1.0
	
	if Input.is_key_pressed(KEY_SHIFT) and direccion:
		rechargeCooldownTimer = rechargeTimer	

	if Input.is_key_pressed(KEY_SHIFT) and stamina > 0 and direccion:
		multiplicador = SPEED_MULTIPLIER
		stamina -= STAMINA_DEPLETION_RATE * delta  # Reduce la stamina mientras corres
		if stamina < 0:
			stamina = 0
		# Reinicia el temporizador de recarga
		rechargeCooldownTimer = rechargeTimer
	elif isRecharging:
		# Recupera la stamina cuando no estás corriendo y el temporizador ha terminado
		stamina += STAMINA_DEPLETION_RATE * delta
		if stamina > maxStamina:
			stamina = maxStamina
			isRecharging = false  # Detiene la recarga cuando la stamina está llena
	
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
	


