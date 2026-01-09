extends CharacterBody2D

@export var move_speed := 120

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = direction.normalized() * move_speed if direction != Vector2.ZERO else Vector2.ZERO
	move_and_slide()
