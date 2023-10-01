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
	
		if distance < 90:
			velocity = -direction * speed  # Moverse en dirección opuesta al jugador
		elif distance > 95:
			velocity = direction * speed  # Moverse hacia el jugador
		else:
			velocity = Vector2.ZERO

		move_and_slide()

func is_player_in_detection_area():
	var detection_area = $DetectionArea
	var overlapping_bodies = detection_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.name == "Player":
			return true
	return false
