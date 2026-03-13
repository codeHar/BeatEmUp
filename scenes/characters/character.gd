extends CharacterBody2D

@export var health: int
@export var damage: int
@export var speed: int


func _process(delta: float) -> void:
	var direction:= Input.get_vector("ui_left","ui_right","ui_up", "ui_down")
	position += direction * speed * delta
