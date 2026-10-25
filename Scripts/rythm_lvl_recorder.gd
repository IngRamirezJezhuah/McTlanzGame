extends RigidBody2D
var xpos = 0.0
var mysprite = Sprite2D
var pressed = false
var pos = 0.0;
var key_l = 0.0;
var key_r = 0.0;
var key_u = 0.0;
var key_d = 0.0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func loop_value(value:float, minv:float, maxv:float):
	var dist = (maxv - minv)+1
	if (value > maxv): value -= dist
	if (value < minv): value += dist
	return value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	key_l = 1.0 if Input.is_key_pressed(KEY_LEFT) else 0.0
	key_r = 1.0 if Input.is_key_pressed(KEY_RIGHT) else 0.0
	
	if (key_r - key_l != 0):
		if (!pressed):
			pos += key_r-key_l
			pressed = true
		pass
	else:
		pressed = false
		
	pos = loop_value(pos, -1.0, 1.0)
	
	xpos = lerp(xpos, pos*100, 0.2)
	position.x = xpos
	pass
