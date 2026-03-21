class_name Character

extends CharacterBody2D

@export var maxHealth: int
@export var damage: int
@export var speed: float
@export var jumpIntensity: float
@export var knockBackIntensity: float

@onready var animationPlayer = $AnimationPlayer
@onready var characterSprite = $CharacterSprite
@onready var damageEmitter = $DamageEmitter
@onready var damageReciever = $DamageReciever

enum State {IDLE, WALK, ATTACK, TAKEOFF, JUMP, LAND, JUMPKICK, HURT}

var animMap = {
	State.IDLE : "idle",
	State.WALK : "walk",
	State.ATTACK : "attack",
	State.TAKEOFF: "takeoff",
	State.JUMP : "jump",
	State.LAND : "land",
	State.JUMPKICK : "jumpKick",
	State.HURT : "hurt"
}

var curHealth := 0
var state = State.IDLE
var height = 0.0
var heightSpeed = 0.0

const GRAVITY = 600.0

func _ready() -> void:
	damageEmitter.area_entered.connect(onEmitDamage.bind())
	damageReciever.damageRecieved.connect(onRecievedDamage.bind())
	curHealth = maxHealth

func _process(delta: float) -> void:
	handleInput()
	handleMovement()
	handleAnimation()
	handleAirTime(delta)
	flipSprite()
	characterSprite.position = Vector2.UP * height
	move_and_slide()

func handleInput():
	pass
	
func handleMovement():
	if canMove():
		if velocity.length() == 0:
			state = State.IDLE
		else:
			state = State.WALK

func handleAnimation():
	if animationPlayer.has_animation(animMap[state]):
		animationPlayer.play(animMap[state])

func handleAirTime(delta: float):
	if state == State.JUMP or state == State.JUMPKICK :
		height += heightSpeed * delta
		if height < 0:
			height = 0
			state = State.LAND
		else:
			heightSpeed -= GRAVITY * delta
		
func flipSprite():
	if velocity.x > 0:
		characterSprite.flip_h = false
		damageEmitter.scale.x = 1
	elif velocity.x < 0:
		characterSprite.flip_h = true
		damageEmitter.scale.x = -1
		
func onTakeoffComplete():
	heightSpeed = jumpIntensity
	state = State.JUMP

func onLandComplete():
	state = State.IDLE

func canAttack():
	return state == State.IDLE or state == State.WALK

func canMove():
	return state == State.IDLE or state == State.WALK

func canJump():
	return state == State.IDLE or state == State.WALK

func canJumpKick():
	return state == State.JUMP

func onActionComplete():
	state = State.IDLE
	
func onEmitDamage(damageReciever: DamageReciever):
	print("emit damage")
	var direction = Vector2.LEFT if damageReciever.global_position.x < global_position.x else Vector2.RIGHT
	damageReciever.damageRecieved.emit(damage, direction)
	print(damageReciever)

func onRecievedDamage(damage:int, direction:Vector2):
	print("hurt")
	curHealth = clamp(curHealth - damage, 0, maxHealth)
	if curHealth <= 0:
		queue_free()
	else:
		velocity = direction * knockBackIntensity
		state = State.HURT
