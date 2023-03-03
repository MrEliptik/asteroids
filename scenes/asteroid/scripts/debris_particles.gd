extends GPUParticles2D

func _ready():
	$Timer.start(lifetime)
	emitting = true
	$ExplosionParticles.emitting = true
	
func _on_timer_timeout():
	queue_free()
