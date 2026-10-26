extends CharacterBody2D

# ===============
#   Vairables
# ===============

@export var animation: AnimatedSprite2D 
var _speed: float = 100.0
var _jump_speed = -200.0

@export var salud_max: float = 100
@export var tiempo_invulnerabilidad: float = 0.5
@export var fuerza_caida: float = 250.0

var salud: float
var _tiempo_invulnerable: float = 0.0
var _tiempo_de_caida: float = 0.0
var _velocidad_de_caida: Vector2 = Vector2.ZERO


# ================== 
#     Funciones
# ==================

func _ready() -> void:
	salud = salud_max
	

# =======================
# parpadear si te pegan
# =======================
func _parpadear() -> void:
	var tween = create_tween()
	tween.tween_property(animation, "modulate", Color(1.0, 0.3, 0.3), 0.08)
	tween.tween_property(animation, "modulate", Color.WHITE, 0.2)

# =======================
# 		morir
# =======================
func _morir() -> void:
	set_physics_process(false)
	queue_free()
		

# =======================
# 	  recibir daño
# =======================
func recibir_daño(cantidad:float, desde: Vector2)-> void:
	if _tiempo_invulnerable > 0.0:
		return
	salud = maxf(salud - cantidad, 0.0)
	_tiempo_invulnerable = tiempo_invulnerabilidad
	# direccion del vrgazo
	var direccion = desde.direction_to(global_position)
	if direccion == Vector2.ZERO:
		direccion = Vector2.RIGHT
	_velocidad_de_caida = direccion * fuerza_caida
	_tiempo_de_caida = 0.2
		
	_parpadear()
		
	if salud <= 0.0:
		_morir()
	

func _physics_process(delta):
	# =====================
	#      gravity
	# =====================
	velocity += get_gravity() * delta
	# ====================
	#   movimiento lateral
	# ====================
	if _tiempo_de_caida > 0.0:
		_tiempo_de_caida -= delta
		velocity.x = _velocidad_de_caida.x
	elif Input.is_action_pressed("rigth"):
		animation.flip_h = false
		velocity.x = _speed
	elif Input.is_action_pressed("left"):
		animation.flip_h = true
		velocity.x = -_speed
	else:
		velocity.x = 0
	# ============================
	# Movimiento en Horizontal 
	# ============================
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y =_jump_speed
	
	# =============================
	# apartado de invulnerabilidad
	# =============================
	if _tiempo_invulnerable > 0.0:
		_tiempo_invulnerable -= delta
	
	# =======================
	#  apartado de animacion
	# =======================
	if !is_on_floor():
		animation.play("jump")
	elif velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")
	
	
	move_and_slide()
