class_name Character

extends CharacterBody2D

@export var health: int
@export var damage: int
@export var speed: int

@onready var animationPlayer = $AnimationPlayer
@onready var characterSprite = $CharacterSprite

enum State {IDLE, WALK, ATTACK}

var state = State.IDLE

func _process(delta: float) -> void:
	handleInput()
	handleMovement()
	handleAnimation()
	flipSprite()
	move_and_slide()

func handleInput():
	var direction:= Input.get_vector("ui_left","ui_right","ui_up", "ui_down")
	velocity = direction * speed
	if canAttack() and Input.is_action_just_pressed("attack"):
		state = State.ATTACK
	
func handleMovement():
	if canMove():
		if velocity.length() == 0:
			state = State.IDLE
		else:
			state = State.WALK
	else:
		velocity = Vector2.ZERO

func handleAnimation():
	if state == State.IDLE:
		animationPlayer.play("idle")
	elif state == State.WALK:
		animationPlayer.play("walk")
	elif  state == State.ATTACK:
		animationPlayer.play("attack")
		
func flipSprite():
	if velocity.x > 0:
		characterSprite.flip_h = false
	elif velocity.x < 0:
		characterSprite.flip_h = true
		
func canAttack(): 
	return state == State.IDLE or state == State.WALK

func canMove():
	return state == State.IDLE or state == State.WALK
	
func attack_complete():
	state = State.IDLE
