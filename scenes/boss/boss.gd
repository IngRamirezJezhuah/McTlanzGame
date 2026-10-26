extends CharacterBody2D
class_name Enemy

const speed = 190

var jugador = null

func _ready():
	jugador = get_tree().get_nodes_in_group("jugador")[0]

func _process(delta: float) -> void:
	follow()
	
func follow():
	if jugador != null:
		velocity = position.direction_to(jugador.position) * speed
		
		move_and_slide()

#func destroid():
	
