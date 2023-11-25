extends KinematicBody2D


var player # reference for player node
var label
var count = 0
var rng = RandomNumberGenerator.new()         # rng object. generate random number 

export var speed = 120			# speed for the skeleton
var direction : Vector2			# movement direction for the skeleton
var last_direction = Vector2(0, 1)	# the last direction before stopping to choose the correct idle animation
var bounce_countdown = 0		# when skeleton hit something, it will change direction for a certain 
								# amount of time to go around the obstacle. 


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().root.get_node("Root/Player")		# get the player node from root scene
	rng.randomize()
	label = get_tree().root.get_node("Root/warning")



func _on_Timer_timeout():
	
	var player_relative_position = player.position - position
	#print(player_relative_position.length())
	# if the player is within the range of the skeleton the stop
	
	# ======================================================================
	if player_relative_position.length() <= 210:
		if count == 0:
			count = count + 1
			$AudioStreamPlayer.play()
			get_node("cooldownScream").start()
			
			
	# ======================================================================
	if player_relative_position.length() <= 60:
		direction = Vector2.ZERO
		last_direction = player_relative_position.normalized()
		#print("You Die")
		get_tree().change_scene("res://youDied/youDied.tscn")
		# player is imobilized when the monster touches the player
		player.speed = 0
		#label.visible = true
	# if the player is within 2000 pixel of the skeleton, follow the player
	elif player_relative_position.length() <= 2000 and bounce_countdown == 0:
		direction = player_relative_position.normalized()
	elif bounce_countdown == 0:
		var random_number = rng.randf()
		if random_number < 0.05:
			direction = Vector2.ZERO
		elif random_number < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf()*2*PI)

	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown -1


func _physics_process(delta):
	var movement = direction * speed * delta
	
	var collision = move_and_collide(movement)
	
	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		bounce_countdown = rng.randi_range(2, 5)
		
	var other_animation_playing = false
	
	# Animate skeleton based on direction
	if not other_animation_playing:
		animates_monster(direction)

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"

func animates_monster(direction: Vector2):
	if direction != Vector2.ZERO:
		last_direction = direction
		
		# Choose walk animation based on movement direction
		var animation = get_animation_direction(last_direction) + "_walk"
		
		# Play the walk animation
		$AnimatedSprite.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = get_animation_direction(last_direction) + "_idle"
		$AnimatedSprite.play(animation)


func _on_cooldownScream_timeout():
	count = count - 1
