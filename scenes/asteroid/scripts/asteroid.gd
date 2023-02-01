extends KinematicBody2D

signal destroyed()

var speed: float = 125.0
var velocity: Vector2 = Vector2.ZERO
var dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	velocity = dir * (speed + rand_range(-50, 50))
	var rand_size_factor = rand_range(0.2, 1.0)
	$Sprite.scale *= rand_size_factor
	$CollisionShape2D.shape.radius *= rand_size_factor

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if not collision: return
	
	# We have a collision
	if collision.collider.is_in_group("Asteroids"):
		var collider = collision.collider
		# Bounce off the asteroids using the collision normal
		velocity = velocity.bounce(collision.normal)
		collider.velocity = collider.velocity.bounce(-collision.normal)

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

func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
	destroy()
