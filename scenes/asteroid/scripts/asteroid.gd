extends CharacterBody2D

signal destroyed()

@export var debris_particles: PackedScene = preload("res://scenes/asteroid/debris_particles.tscn")

var speed: float = 125.0
var dir: Vector2 = Vector2.ZERO
var rotation_speed: float = 25.0

@onready var sprite = $Sprite2D

func _ready() -> void:
	rotation_speed += randf_range(-5, 5)
	velocity = dir * (speed + randf_range(-50, 50))
	var rand_size_factor = randf_range(0.2, 1.0)
	$Sprite2D.scale *= rand_size_factor
	$CollisionShape2D.shape.radius *= rand_size_factor
	$Trail2D.length *= rand_size_factor
	$Trail2D.width *= rand_size_factor

func _physics_process(delta: float) -> void:
	sprite.rotation_degrees += rotation_speed * delta
	
	var collision = move_and_collide(velocity * delta)
	if not collision: return
	
	# We have a collision
	if collision.get_collider().is_in_group("Asteroids"):
		var collider = collision.get_collider()
		# Bounce off the asteroids using the collision normal
		velocity = velocity.bounce(collision.get_normal())
		collider.velocity = collider.velocity.bounce(-collision.get_normal())
	elif collision.get_collider().is_in_group("Player"):
		# Take damage, or die instantly, it's up to you
		collision.get_collider().destroy()

func take_damage(damage: int) -> void:
	# Exercise for the viewer: implement "health" for
	# the asteroirs, and remove health when taking damage
	# when health reaches 0, you destroy the asteroid.
	# to go even further, you can scale the sprite and collision of the
	# asteroid each time, to show that the asteroid is taking damage
	
	# Destroy the asteroid
	destroy()
	
func destroy() -> void:
	Globals.camera.shake(0.3, 25, 15)
	Input.start_joy_vibration(0, 0.5, 0.4, 0.3)
	spawn_debris_particles()
	print("Destroyed")
	emit_signal("destroyed")
	queue_free()
	
func spawn_debris_particles() -> void:
	var instance = debris_particles.instantiate()
	get_tree().get_current_scene().add_child(instance)
	instance.global_position = global_position

func _on_visible_on_screen_notifier_2d_screen_exited():
	destroy()
