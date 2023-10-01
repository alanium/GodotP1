extends CharacterBody2D

var speed = 100

func _on_detection_area_body_entered(body):
	if body.name == 'Player':
		pass

func _on_detection_area_body_exited(body):
	if body.name == 'Player':
		pass

func _process(delta):
	if is_player_in_detection_area():
		var player = get_node("/root/World/Player")
		var direction = (player.global_position - global_position).normalized() 
		var distance = global_position.distance_to(player.global_position)
		
		# Si la distancia entre el enemigo y el jugador es menor que cierto valor, alejar al enemigo del jugador
		if distance < 85:  # Ajusta este valor según lo que funcione mejor para tu juego
			velocity = -direction * speed  # Moverse en dirección opuesta al jugador
		else:
			velocity = direction * speed  # Moverse hacia el jugador

		move_and_slide()

func is_player_in_detection_area():
	var detection_area = $DetectionArea
	var overlapping_bodies = detection_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.name == "Player":
			return true
	return false
