extends Node2D

const bulletSpeed = 1200 #bullet speed
var bulletVelocity = Vector2()
var initialPosition = Vector2()
var initialized = false

func _ready():
	pass
	
	
func fire():
	initialized = true #used as a flag to determine whether a bullet has been fired
	bulletVelocity = Vector2(bulletSpeed, 0).rotated(Global.player.rotation) #sets bullet velocity
	
func _process(delta):
	if (initialized):
		var screen_size = get_viewport_rect().size #gets screen size
		position += bulletVelocity * delta #updates position
		if (position.x > screen_size.x || position.x < 0 || position.y > screen_size.y || position.y < 0): #checks if out of bounds and deletes the bullet
			queue_free()
		




