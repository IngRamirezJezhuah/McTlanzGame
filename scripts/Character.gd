extends CharacterBody2D

# Variables
var direction = Vector2()
var rapidez = 400
var velocidad = Vector2()
var Mysprite = AnimatedSprite2D.new()

# Funciones

func _ready() -> void:
	pass
	#Mysprite =self.get_node("AnimatedSprides2D")

func get_input():
	var input_direcction = (Input.get_vector("left","rigth", "up", "down"))
	velocity = input_direcction * rapidez
	#var mov = (Input.get_axis("left","rigth")) * 4
	#position.x = mov
	#
func _physics_process(delta):
	get_input()
	move_and_slide()
	#Mysprite.get_frame("correr")

	


	
