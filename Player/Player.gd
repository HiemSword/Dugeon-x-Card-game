extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 125
export var FRICTION = 400

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN


onready var sprite = $AnimatedSprite


func _ready():
	pass


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
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	if input_vector != Vector2.ZERO: # Se l'input e diverso da un vettore zero:
		
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) # Sposta il valore da velocita a velocita massima
		print(input_vector)
		sprite.flip_h = velocity.x < 0
		
	else: # Se invece l'input E' un vettore zero (cioè nessun tasto viene premuto)
		print("Zero: " + str(input_vector))
		
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # Sposta il valore da velocita a vettore zero
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK


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
	print("Move to: " + str(velocity))



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

