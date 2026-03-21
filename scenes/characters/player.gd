extends Character
func handleInput():
	var direction:= Input.get_vector("ui_left","ui_right","ui_up", "ui_down")
	velocity = direction * speed
	if canAttack() and Input.is_action_just_pressed("attack"):
		state = State.ATTACK
	if canJump() and Input.is_action_just_pressed("jump"):
		state = State.TAKEOFF
	if canJumpKick() and Input.is_action_just_pressed("jumpKick"):
		state = State.JUMPKICK
