extends CharacterBody2D

signal destroyed()

@export var bullet_scene: PackedScene = preload("res://scenes/bullet/bullet.tscn")
@export var speed: float = 30.0
@export var rotation_speed: float = 15.0
@export var accel: float = 5.0
@export var friction: float = 1.0
@export var rotation_smooth_speed: float = 15.0

@onready var thrust_particles: GPUParticles2D = $ThrustParticles
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var thrust: float = 0.0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	var dir: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	rotation += deg_to_rad(rotation_speed) * dir * delta
	
	thrust = Input.get_action_strength("thrust")
	if thrust > 0.0:
		Globals.camera.zoom_out()
		velocity = lerp(velocity, thrust * speed * global_transform.x, accel * delta)
		thrust_particles.emitting = true
	else:
		Globals.camera.zoom_in()
		velocity = lerp(velocity, Vector2.ZERO, friction * delta)
		thrust_particles.emitting = false
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	# There's no collision, we can return
	if not collision: return

func shoot() -> void:
	animation_player.play("shoot")
	Input.start_joy_vibration(0, 0.5, 0.15, 0.1)
	Globals.camera.shake(0.15, 20, 10)
	
	var instance = bullet_scene.instantiate()
	var instance2 = bullet_scene.instantiate()
	
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
