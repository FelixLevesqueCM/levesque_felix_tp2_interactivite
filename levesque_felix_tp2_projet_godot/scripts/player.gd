extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

const ROLL_SPEED = 160.0
var rolling = false
var can_roll = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var roll_timer: Timer = $roll_timer
@onready var roll_colldown: Timer = $roll_colldown

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("roll") and is_on_floor() and can_roll:
		rolling = true
		can_roll = false
		set_collision_layer_value(3, false)
		roll_timer.start()
		roll_colldown.start()

	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		elif rolling == true:
			animated_sprite.play("roll")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		if rolling:
			velocity.x = direction * ROLL_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_roll_timer_timeout() -> void:
	rolling = false
	set_collision_layer_value(3, true)


func _on_roll_colldown_timeout() -> void:
	can_roll = true
