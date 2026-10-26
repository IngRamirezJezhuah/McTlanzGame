extends CharacterBody2D

# Variables
var direction = Vector2()
var rapidez = 400
var velocidad = Vector2()
@onready var animation = $AnimatedSprite2D
# Funciones

func _ready() -> void:
	pass
	#animation.play("correr")
	#Mysprite =self.get_node("AnimatedSprides2D")

func get_input():
	#movimiento vectorial
	var input_direcction = Input.get_vector("left","rigth", "up", "down")
	velocity = input_direcction * rapidez
	# movimiento vertical
	#var inp = Input.get_axis("left","rigth")
func _physics_process(delta):
	get_input()
	move_and_slide()
	
	
	#Mysprite.get_frame("correr")

	


	
