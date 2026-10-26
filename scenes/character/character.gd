extends CharacterBody2D

@export var animation: AnimatedSprite2D
var _speed: float = 100.0
var _jump_speed = -200.0

func _physics_process(delta):
	#gravity
	velocity += get_gravity() * delta
	
	#lateral movement 
	if Input.is_action_pressed("rigth"):
		animation.flip_h = false
		velocity.x = _speed
	elif Input.is_action_pressed("left"):
		animation.flip_h = true
		velocity.x = -_speed
	else:
		velocity.x = 0
	
	#Horizontal movement 
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y =_jump_speed
		
	#animation
	if !is_on_floor():
		animation.play("jump")
	elif velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")
	
	
	move_and_slide()
