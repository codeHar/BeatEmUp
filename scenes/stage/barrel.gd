extends StaticBody2D


@onready var damageReciever = $DamageReciever
@onready var sprite = $Sprite2D
@export var knockbackIntensity:= 50

enum State {IDLE, DESTROYED}

var state = State.IDLE
var velocity:= Vector2.ZERO
var height := 0.0
var height_speed := 0.0

const GRAVITY = 600.0

func _ready() -> void:
	damageReciever.damageRecieved.connect(onRecieveDamage.bind())

func _process(delta: float) -> void:
	position += velocity * delta
	sprite.position = Vector2.UP * height
	if state == State.DESTROYED:
		print("VectorUp: ", Vector2.UP)
		print("Height: ", height)
		print("Height: ", height_speed)
		print("SpritePos: ", sprite.position)
	handleAirTime(delta)
	
func onRecieveDamage(damage: int, direction: Vector2):
	if state == State.IDLE:
		sprite.frame = 1
		height_speed = knockbackIntensity * 2
		state = State.DESTROYED
		velocity = direction * knockbackIntensity

func handleAirTime(delta: float):
	if state == State.DESTROYED:
		modulate.a -= delta
		height += height_speed * delta
		if height < 0:
			height = 0
			queue_free()
		else:
			height_speed -= GRAVITY * delta
