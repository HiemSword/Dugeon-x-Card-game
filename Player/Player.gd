extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 125
export var FRICTION = 400

# vvv - Non ci serve per ora ma se commentato non funziona più niente
enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE #Non serve per ora
var velocity = Vector2.ZERO 
var roll_vector = Vector2.DOWN


onready var sprite = $AnimatedSprite


func _ready():
	sprite.frame = 0


func _physics_process(delta): 
#	match state:
#		MOVE:
#			move_state(delta)
#		ROLL:
#			roll_state()
#		ATTACK:
#			attack_state()
	move_state(delta)
	


func move_state(delta):
	
	var input_vector = Vector2.ZERO
	#Prendi la forza con cui viene premuto il tasto destro e sinistro (nel caso della tastiera è sempre 1)
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#Stessa cosa ma con basso e alto
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() #Normalizali (li approsima)
	
	
	if input_vector != Vector2.ZERO: # Se l'input e diverso da un vettore zero:
		
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) # Sposta il valore da velocita a velocita massima
		
		sprite.play("walk") # riproduci animazione walk
		sprite.flip_h = velocity.x < 0 # inverti lo sprite se andiamo verso destra
		
	else: # Se invece l'input è un vettore zero (cioè nessun tasto viene premuto)
		
		sprite.play("idle") # riproduci animazione idle
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # Sposta il valore da velocita a vettore zero (moltiplicando con delta)
	
	move()
	
#	if Input.is_action_just_pressed("roll"):
#		state = ROLL
#
#	if Input.is_action_just_pressed("attack"):
#		state = ATTACK


#func roll_state():
#	velocity = roll_vector * ROLL_SPEED
#	animationState.travel("Roll")
#	move()
#
#func attack_state():
#	velocity = Vector2.ZERO
#	animationState.travel("Attack")
#
#
#
#func roll_animation_finished():
#	velocity = velocity * 0.8
#	state = MOVE
#
#func attack_animation_finished():
#	state = MOVE
	
func move():
	velocity = move_and_slide(velocity)
	#print("Move to: " + str(velocity)) <-- Uncomment for debugging



#func _on_HurtBox_area_entered(area):
#	stats.health -= area.damage
#	hurtbox.start_invincibility(0.6)
#	hurtbox.create_hit_effect()
#	var playerHurtSound = PlayerHurtSound.instance()
#	get_tree().current_scene.add_child(playerHurtSound)
#
#
#func _on_HurtBox_invincibility_started():
#	blinkAnimationPlayer.play("Start")
#
#
#func _on_HurtBox_invincibility_ended():
#	blinkAnimationPlayer.play("Stop")

