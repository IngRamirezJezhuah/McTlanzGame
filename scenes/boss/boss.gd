extends CharacterBody2D

# ===================
# Clase y variables
# ===================
class_name Enemy

@export var speed: float = 190.0
@export var rango_deteccion: float = 400.0
@export var rango_ataque: float = 140.0
@export var daño_x_ataque: float = 10.0
@export var espera_ataque: float = 1.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var jugador: Node2D = null
var tiempo_ataque: float = 0.0

# ===================
# funcion inicial
# ===================
func _ready():
	jugador = get_tree().get_first_node_in_group("jugador") as Node2D
	if jugador == null:
		# log de depuracion por que no sepo
		push_warning("Boss: no se encontro nodo en el grupo jugador")

# ===================
#   funcion de ataque
# ===================
func atacar() -> void:
	if tiempo_ataque > 0.0:
		return
	tiempo_ataque = espera_ataque
	
	if jugador.has_method("recibir_daño"):
		jugador.recibir_daño(daño_x_ataque, global_position)
		
	print("Boss ataca: usa:", jugador,has_method("recibir_daño"))
	_parpadear()

# ===================
# funcion parpadear
# ===================
func _parpadear() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1.0, 0.4, 0.4), 0.08)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.15)

# ===================
# fisicas edl boss
# ===================
func _physics_process(delta: float) -> void:
	tiempo_ataque = maxf(tiempo_ataque - delta, 0.0)
	
	if jugador == null:
		return
	var distancia = global_position.distance_to(jugador.global_position)
	
	if distancia > rango_deteccion:
		velocity = Vector2.ZERO
	elif distancia > rango_ataque:
		var direccion = global_position.direction_to(jugador.global_position)
		velocity = direccion * speed
		if direccion.x != 0.0:
			sprite.flip_h = direccion.x < 0.0
		else:
			velocity = Vector2.ZERO
			atacar()
		move_and_slide()
