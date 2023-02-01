extends KinematicBody2D

signal destroyed()

export var bullet_scene: PackedScene = preload("res://scenes/bullet/bullet.tscn")
export var speed: float = 30.0
export var rotation_speed: float = 15.0

var thrust: float = 0.0
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	var dir: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	rotation += deg2rad(rotation_speed) * dir * delta
	
	thrust = Input.get_action_strength("thrust")
	velocity = thrust * speed * global_transform.x
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	# There's no collision, we can return
	if not collision: return
	
	if collision.collider.is_in_group("Asteroids"):
		# Take damage, or die instantly, it's up to you
		destroy()

func shoot() -> void:
	var instance = bullet_scene.instance()
	var instance2 = bullet_scene.instance()
	
	# Set the direction
	instance.dir = $BulletPosLeft.global_transform.x
	instance2.dir = $BulletPosRight.global_transform.x
	
	# Add it to the tree
	get_parent().add_child(instance)
	get_parent().add_child(instance2)
	
	# Set the position
	instance.global_position = $BulletPosLeft.global_position
	instance2.global_position = $BulletPosRight.global_position

func destroy() -> void:
	emit_signal("destroyed")
