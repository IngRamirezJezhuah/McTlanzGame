extends Node

#Esta shit solo funciona a 60 cuadros de momento ._.

#############################
### Variables & constants ###
#############################
var listing = [0];					#La lista de macros. Se meten a un JSON.
var pressing = false;				#Este es para la tecla que graba macros. Es una mexicanada, si lees el código lo entenderás.
var gb1fpressed = false;			#Mexicanada pero para el que vuelve un frame.
var gf1fpressed = false;			#Este es el de arriba pero en vez de volver avanza.
var start_pause_pressed = false;	#Este creo que se explica solo XD
var timer = 0.0;					#Es el tiempo transcurrido entre el inicio de la canción y el tiempo actual.
var last_recorded = 0;				#Este es para mostrar la última macro grabada
var running = false;				#Aquí verifico si el script corre. Es para reproducción y pausa.
var printed = true;					#Este es para imprimir en consola. Solo se imprime el json si hay pausa.
const MAXTIMES = 10;				#La cantidad de veces máxima que se puede esperar a reproducir una canción al avanzar o retroceder por frame.
var wait_2_times = MAXTIMES;		#La cantidad de vueltas del loop de juego antes de parar una canción por frame.
var step = 0;						#La macro actual que vas a añadir.
var MAXWAIT = 60					#La espera máxima para repetir la ida y vuelta por frame.
var waiter = MAXWAIT;				#La espera para repetir ida y vuelta blah blah blah...
var last_step = step;				#Este es para saber dónde te quedaste en pasos.
var moving_slider = true;
var level_name = "test";
#Only on ready
@onready var bgmslid = $bgmslider;	#Mención honorífica a la etiqueta que muestra información útil.
@onready var lab_ref = $macro_display;	#Mención honorífica a la etiqueta que muestra información útil.
@onready var mus_ref = $bgm;			#Mención honorífica al nodo de reproducción musical. Es más complejo de lo que se detalla en mi script,
@onready var get_nam = $LineEdit;			#Mención honorífica al nodo de reproducción musical. Es más complejo de lo que se detalla en mi script,
# recomiendo consultar la sección de sonidos de godot porque la configuración de sonido es medio rara.

##########################
### Useless start btw. ###
##########################
func _ready() -> void:
	bgmslid.max_value = mus_ref.stream.get_length()*100;
	get_nam.text = level_name;
	pass
	
#######################################
### Guardado <arcáico> de archivos. ###
#######################################
func save_json():
	#Lo copié y lo pegué del manual. No se rompió entonces chido.
	var json_string = JSON.stringify(listing)
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			print(data_received) # Prints the array.
			var savedfile = FileAccess.open("res://Saves/%s.json" % level_name, FileAccess.WRITE)
			savedfile.store_line(json_string)
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

#######################################################
### El ciclo de juego (o al menos el de este nodo). ###
#######################################################
func _process(_delta: float) -> void:
	#Dato curioso: Delta es una distancia: el tiempo transcurrido entre el frame actual con respecto al anterior.
	#Se puede usar para hacer que el juego corra en una papa de manera consistente. OJO: consistente no significa
	#estable.
	
	var tempo_key = Input.is_key_pressed(KEY_CTRL) || Input.is_key_pressed(KEY_SHIFT); 	#La tecla para grabar
	var start_pause = Input.is_key_pressed(KEY_SPACE);									#La tecla para pausar
	var go_back_1_frame = Input.is_key_pressed(KEY_LEFT);								#La tecla del viajero en el tiempo
	var go_towards_1_frame = Input.is_key_pressed(KEY_RIGHT);							#Marty, tenemos que volver al futuro.

	level_name = get_nam.text
	
	if (start_pause):					#Si se presiona la tecla de pausa
		if (!start_pause_pressed): 		#y si no había sido presionada antes
			running = !running;			#entonces haz que el programa corra o se pause inversamente.
			start_pause_pressed = true;	#Recuerda marcar que ya se presionó esta tecla
	else:								#Si sueltas la tecla
		start_pause_pressed = false		#La tecla ya no está pulsada.
		
	if (waiter == 0):		#Si la espera concluyó...
		gb1fpressed = false	#...quita los límites para ir al pasado
		gf1fpressed = false	#y al futuro
		
	if (go_back_1_frame):		#Si presionas ir atrás un frame
		if (wait_2_times > 0):	#y la espera es mayor a cero
			wait_2_times-=1;	#resta a la espera un frame
		if (wait_2_times == 0):	#pero si es 0
			mus_ref.stop();		#detén la música.
			
		if (waiter > 0):
			waiter-=1;
			if (wait_2_times == 0):
				wait_2_times = MAXTIMES
			
		if (!gb1fpressed):
			timer -= 1;
			bgmslid.value = timer;
			if (timer < 0):
				timer = 0;
			mus_ref.play(timer/100);
			if (len(listing) != 0):
				step = clamp(step, 0.0, len(listing)-1)
				if (timer < listing[step]):
					step -= 1;
			gb1fpressed = true;
		
	else:
		if (!go_towards_1_frame):
			wait_2_times = MAXTIMES;
			waiter = MAXWAIT
		gb1fpressed = false;
		
	if (go_towards_1_frame):
		if (wait_2_times > 0):
			wait_2_times-=1;
		if (wait_2_times == 0):
			mus_ref.stop();
			
		if (waiter > 0):
			waiter-=1;
			if (wait_2_times == 0):
				wait_2_times = MAXTIMES
		
		if (!gf1fpressed):
			timer += 1;
			bgmslid.value = timer;
			mus_ref.play(timer/100);
			if (len(listing) != 0):
				step = clamp(step, 0.0, len(listing)-1)
				if (timer == listing[clamp(step+1, 0.0, len(listing)-1)]):
					step += 1;
			gf1fpressed = true;
	else:
		if (!go_back_1_frame):
			wait_2_times = MAXTIMES;
			waiter = MAXWAIT
		gf1fpressed = false;
		
	if (running):
		
		if (len(listing) == 0):
			listing = [0.0];
			step = 0;
		
		if (step < len(listing)-1):
			if (timer == listing[clamp(step+1, 0, len(listing)-1)]):
				step+=1;
		
		timer+=1;
		printed = false;
		if (!mus_ref.playing):
			mus_ref.play(timer/100);
			
		bgmslid.value = timer;
	else:
		if bgmslid.value_changed:
			timer = bgmslid.value;
			
		if (!printed):
			save_json()
			printed = true
		if (!go_back_1_frame && !go_towards_1_frame):
			mus_ref.stop()
	
	if (tempo_key):
		if (!pressing):
			if (timer != listing[step]):
				listing.append(timer)
				step += 1;
				last_recorded = timer;
				pressing = true;
			else:
				listing[step+1] = timer
	else:
		pressing = false;
	
	#Aquí solo es información DEBUG resumida. Más simple, ¿no?
	lab_ref.text = "State: %s\nCurrent time: %s\nCurrent step: %s\nLastObtained: %s" % ["Playing" if running else "Stopped", timer, step, last_recorded];
