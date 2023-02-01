extends Node2D

export var asteroid_scene: PackedScene = preload("res://scenes/asteroid/asteroid.tscn")

onready var spawn_pos: Node2D = $SpawnPositions

func _ready() -> void:
	randomize()
	spawn_asteroids(5)
	
func spawn_asteroids(amount: int) -> void:
	for i in range(amount):
		var instance = asteroid_scene.instance()
		# Connect the destroyed signal
		instance.connect("destroyed", self, "on_asteroid_destroyed")
		
		# Get a random position
		var selected = spawn_pos.get_child(randi()%spawn_pos.get_child_count())
		var random_pos: Vector2 = selected.global_position
		
		# Compute the direction the asteroid will take
		var center: Vector2 = get_viewport_rect().size / 2.0
		var dir: Vector2 = (center - random_pos).normalized()
		dir = dir.rotated(deg2rad(rand_range(-40.0, 40.0)))
		instance.dir = dir
		
		# Addind the instance to the tree
		add_child(instance)
		# Changing the position, once the node is in the tree
		instance.global_position = random_pos

func on_asteroid_destroyed() -> void:
	spawn_asteroids(1)

func _on_Player_destroyed() -> void:
	get_tree().reload_current_scene()
