extends Area2D

var damage: int = 0
var speed: float = 900.0
var velocity: Vector2 = Vector2.ZERO
var dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	velocity = dir * speed
	rotation = dir.angle()

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	
func _on_Bullet_body_entered(body: Node) -> void:
	body.take_damage(damage)
	queue_free()

func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
	queue_free()
