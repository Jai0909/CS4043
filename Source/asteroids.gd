extends KinematicBody2D

var velocity =  Vector2()
var screenSize
var extents


func _ready():
	randomize()
	velocity = Vector2(rand_range(30, 100), 0).rotated(rand_range(0, 2*PI)) #chooses random velocity
	screenSize = get_viewport_rect().size #gets screen size
	extents = get_node("sprite").get_texture().get_size() #gets asteroids texture size
	
func _physics_process(delta):
	move_and_slide(velocity, Vector2(0, 0)) #moves the asteroid based on the random properties above
	if position.x > screenSize.x + (extents.x - 300): #the rest of this code constantly compares the position of the asteroid and once off screen, it is teleported to the other side.
		position.x = (-extents.x + 300)
	if position.x < (-extents.x + 300):
		position.x = screenSize.x + (extents.x - 300)
	if position.y > screenSize.y + (extents.y -250):
		position.y = (-extents.y + 250)
	if position.y < (-extents.y + 250):
		position.y = screenSize.y + (extents.y - 250)
	
