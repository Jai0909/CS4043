extends Node

export (PackedScene) var Mob
export var gameOver = false
var score = 0 #score counter counts amount of seconds alive
var roundNumber = 1 #used to display the round number btween rounds
var seconds #second counter used both for displaying time and the final score
var mob_speed = 500 #initial mob speed at the start of the game
var special = false #this boolean acts as a flag that allows or blocks the special ability from being used
var cooldown = false #this boolean controls whether the special ability is off cooldown and can be used again
export var gameEnd = false #this boolean used by the program to tell if its the time between rounds. Where the player should be safe
onready var timer = get_node("Timer")
onready	var playerNode = get_node("Player")
onready	var hudNode = get_node("HUD")

func _ready():
	$cooldown.animation = "empty" #sets the ability icon to nothing so it appears empty
	$gameOverBackground.hide() #hides the gameover screen
	$infoScreen.hide() #hides info screen
	$gameMusic.play() #starts the music track
	$roundLabel.hide() #hides the text that appears to tell you what round you are on
	playerNode.connect("gameOverSignal", self, "gameOverMethod") #connects a signal from player
	hudNode.connect("infoSignal", self, "showInfo") #connects signal "infoSignal" from the HUD scene
	gameOver = true #keeps anything from spawning before the game actually starts

func new_game():
	gameOver = false #allows spawning and shooting
	$cooldown.animation = "cooldown" 
	$cooldown.stop() #automatically discables the animation for the ability icon
	$cooldown.frame = 0 #sets the ability icon to the ready position signalling to the player that the ability is availabe to use
	gameEnd = false #enables mobspawning
	seconds = 60 #sets timer to 60 seconds
	$titleCard.hide() #hides everything related to the titleCard node 
	$roundLabel.hide() #hides the text regarding which round it is
	$MobTimer.start() #enables mob timer which in turn enable mob spawning
	timer.set_wait_time(1) #timer waits one second per tick
	timer.start() #timer starts
	
func showInfo():
	$infoScreen.show() #shows the info screen for the player

func _process(delta):
	if (special) && !gameOver:	 #special ability spawning
		$laser.play() #plays laser sound
		var bullet := preload("res://Bullet.tscn").instance() #preloads bullets scene
		bullet.global_position = Global.player.global_position + Vector2(35, 0).rotated(Global.player.rotation) #matches new bullets position to be slightly ahead of the players
		bullet.rotation = $Player.bullet_dir #sets bullet rotation to players
		add_child(bullet) #spawns new bullet
		bullet.fire()
	if Input.is_action_just_pressed("ui_select") && !gameOver: # regular shot
		$laser.play()
		var bullet := preload("res://Bullet.tscn").instance() #same as before
		bullet.global_position = Global.player.global_position + Vector2(35, 0).rotated(Global.player.rotation)
		bullet.rotation = $Player.bullet_dir
		add_child(bullet)
		bullet.fire()
	if Input.is_action_just_pressed("special") && !gameOver && !cooldown: 
		cooldown = true #sets cooldown to true
		special = true #enables special attack to start firing
		yield(get_tree().create_timer(1), "timeout") #waits one seconds
		special = false #stops special attack from firing
		$cooldown.frame = 1 #these 2 lines set and start the special attack icon's cooldown animation to inform that player that they have used their ability and must wait to use it again.
		$cooldown.play()
		yield(get_tree().create_timer(7), "timeout") #waits 7 seconds
		$cooldown.stop()
		$cooldown.frame = 0 #displays the special attack as ready again
		cooldown = false #enable the special attack to be used again
	
func _on_MobTimer_timeout(): #spawns mob randomly
	if(!gameEnd && !gameOver):
		$MobPath/MobSpawnLocation.offset = randi()
		var mob = Mob.instance()
		add_child(mob)
		var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
		mob.position = $MobPath/MobSpawnLocation.position
		direction += rand_range(-PI / 4, PI / 4)
		mob.rotation = direction
		mob.linear_velocity = Vector2(mob_speed, 0)
		mob.linear_velocity = mob.linear_velocity.rotated(direction)


func TimerTimeout():
	if(seconds >= 0):
		$Panel/TimeDisplay.text = str(seconds) #displays and updates the timer to the top right of the screen
	seconds = seconds - 1 #counts down
	if(seconds == -1):
		gameEnd = true #enables the flag for the time inbetween round
		roundNumber = roundNumber + 1 #increments round number
		postRound() #calls postRound method
		$roundLabel.text = "Round: " + str(roundNumber) #updates round number
		$roundLabel.show() #displays round number

func difficultyIncrease():
	mob_speed = mob_speed + 100 #increases mob speed
	new_game() #starts new Round

func postRound():
	yield(get_tree().create_timer(5), "timeout") #waits 5 seconds
	difficultyIncrease() #calls method diffcultyIncrease
		
func gameOverMethod(): #Method called when player dies
	gameOver=true #disables everything
	timer.stop() #stops timer
	$gameMusic.stop()
	var endScoreInt = 60 - seconds + (roundNumber * 60 - 60) - 1 #calculates player's final score
	$DeathExplosionSound.play()
	yield(get_tree().create_timer(3), "timeout") #waits 3 seconds to allow the player to register that they#ve just died
	$gameOverBackground.show() #displays game over image
	$gameOverTrack.play()
	$gameOverBackground/endScore.text = "You survived for " + str(endScoreInt) + " seconds" #updates score in the text node
	$cooldown.animation = "empty" #makes the special attack icon invisible
	yield(get_tree().create_timer(3), "timeout") #waits 3 seconds to allow the player to read their score
	get_tree().reload_current_scene() #resets and sends player back to the home screen
