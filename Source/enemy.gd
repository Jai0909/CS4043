extends RigidBody2D

func _ready():
	$AnimatedSprite.animation = "Fly"
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() #deleted when leaves the screen





func _on_Mob_body_entered(body):
	var stringAsteroid = "asteroids"
	$AnimatedSprite.animation = "Explosion"
	if (!stringAsteroid in body.name): #checks if collider is not an asteroid. If its not i deletes it 
		body.queue_free()
	yield(get_tree().create_timer(.5), "timeout") #wait time allows the explosion animation to play first
	queue_free() #deletes self
	
