extends CharacterBody2D


func _on_detection_area_body_entered(body):
	if body.name == 'Player':
		print("¡El jugador ha entrado en el área de detección del enemigo!")


func _on_detection_area_body_exited(body):
	if body.name == 'Player':
		print("¡El jugador ha salido en el área de detección del enemigo!")
