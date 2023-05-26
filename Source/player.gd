extends KinematicBody2D


export (int) var speed = 300
export (float) var rotation_speed = 4
var velocity = Vector2()
var rotation_dir = 0
var bullet_dir : float
var gameOver = false
var gameStart = false
signal gameOverSignal

func _ready():
	gameOver = false #enables player movement
	Global.player = self #sets global player to this node
	
	
func get_input():
	
	rotation_dir = 0
	velocity = Vector2()
	if Input.is_action_pressed('right') && !gameOver:
		rotation_dir += 1.5 #turns right when right is pressed or held
		
	if Input.is_action_pressed('left') && !gameOver:
		rotation_dir -= 1.5 #turns left when left is pressed or held
	
	if Input.is_action_pressed('up') && !gameOver:
		velocity = Vector2(speed, 0).rotated(rotation) #forward thrust when up is pressed
	else:
		velocity = Vector2(0,0) #otherwise stand still
	

		

		
func _physics_process(delta):
	var screen_size = get_viewport_rect().size #gets screensize
	get_input() #gets input
	rotation += rotation_dir * rotation_speed * delta #updates rotation
	bullet_dir = rotation #sets bullet rotation to the players
	move_and_slide(velocity, Vector2(0, 0), false, 4, 0.785, false) #updates positions 
	position.x = clamp(position.x, 0, screen_size.x) #these two lines do not allow the player to leave the screen borders
	position.y = clamp(position.y, 0, screen_size.y)
	for index in get_slide_count(): #this group of code detects collision with hostile objects and declares game over
		var collision = get_slide_collision(index)
		var stringAsteroid = "asteroids"
		if collision.collider is RigidBody2D || stringAsteroid in collision.collider.name && !gameOver:
			gameOver=true
			gameOver()

func gameOver(): #game over method explodes the players ship disables everything else and emits signal to main scene.
	$PlayerAnimation.animation = "PlayerExplosion"
	gameStart = false
	emit_signal("gameOverSignal")


