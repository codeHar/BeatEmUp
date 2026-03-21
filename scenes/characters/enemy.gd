extends Character

@export var player:Character

func _ready() -> void:
	super()
	speed = randi_range(10,18)

func handleInput():
	if player != null and canMove():
		var direction = (player.position - position).normalized()
		velocity = direction * speed
