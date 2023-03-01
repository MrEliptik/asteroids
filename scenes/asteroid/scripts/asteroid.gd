extends CharacterBody2D

signal destroyed()

var speed: float = 125.0
var dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	velocity = dir * (speed + randf_range(-50, 50))
	var rand_size_factor = randf_range(0.2, 1.0)
	$Sprite2D.scale *= rand_size_factor
	$CollisionShape2D.shape.radius *= rand_size_factor

func _physics_process(delta: float) -> void:
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
	print("Destroyed")
	emit_signal("destroyed")
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	destroy()
