extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4


var knockback = Vector2.ZERO
var state = CHASE

var velocity = Vector2.ZERO

onready var sprite = $AnimatedSprite

onready var playerDetectionZone = $PlayerDetectionZone


onready var wanderController = $WanderController


enum {
	IDLE,
	WANDER,
	CHASE
}
func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			#print("IDLE STATE")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			sprite.play("idle")
			if wanderController.get_time_left() == 0:
				update_wander()
				
				
		WANDER:
			#print("WANDER STATE")
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
				
				
		CHASE:
			#print("CHASE STATE")
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
#	if softCollision.is_colliding():
#		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)



func accelerate_towards_point(point, delta):
	#print("Accelerate_towards_point : point " + str(point) + str(" delta ") + str(delta))
	var direction = global_position.direction_to(point)
	# [OUTDATED IN P21] Guarda "Make an Action RPG in Godot 3.2 P16" 25:40
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.play("walk")
	sprite.flip_h = velocity.x < 0 
	#print("Enemy velocity: " + str(velocity))

func update_wander():
	#print("Update_wander")
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))


func seek_player():
	#print("seek_player")
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	#print("pick_random_state")
	state_list.shuffle()
	return state_list.pop_front()


#func _on_HurtBox_area_entered(area):
#	stats.health -= area.damage
#	knockback = area.knockback_vector * 120
#	hurtbox.create_hit_effect()
#	hurtbox.start_invincibility(0.4)
#
#
#func _on_Stats_no_health():
#	queue_free()
#	var enemyDeathEffect = EnemyDeathEffect.instance()
#	get_parent().add_child(enemyDeathEffect)
#	enemyDeathEffect.global_position = global_position
#
#
#func _on_HurtBox_invincibility_started():
#	animationPlayer.play("Start")
#
#
#func _on_HurtBox_invincibility_ended():
#	animationPlayer.play("Stop")



func _on_BattleRange_body_entered(body):
	print("BATTLE with " + str(body))
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/custom/Main.tscn")
