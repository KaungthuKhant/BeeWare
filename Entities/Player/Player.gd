extends KinematicBody2D

# Player movement speed
export var speed = 150	# speed is pixel per sec so 75 px per sec
var last_direction = Vector2(0, 1)


func animates_player(direction: Vector2):
	if direction != Vector2.ZERO:
		# update last_direction
		# gradually update last_direction to counteract the bounce of the analog stick
		last_direction = 0.5 * last_direction + 0.5 * direction
		
		# Choose walk animation based on movement direction
		var animation = get_animation_direction(last_direction) + "_walk"
		$Sprite.frames.set_animation_speed(animation, 2 + 8 * direction.length())
		# Play the walk animation
		$Sprite.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = get_animation_direction(last_direction) + "_idle"
		$Sprite.frames.set_animation_speed(animation, 2 + 8 * direction.length())
		$Sprite.play(animation)


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

# this function is called during the physics processing step of the mian loop
# code that need to acces a physical body's properties or use a physical body's method
# should be run here
func _physics_process(delta):
	# Get player input
	
	# if player speed is greater than 20, reduce by 0.05 every time they input a key input
	if speed > 40:
		speed -= 0.03
		#print("Current speed: ", speed)
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Apply movement
	var movement = speed * direction * delta
	move_and_collide(movement)
	
	# Animate player based on direction
	animates_player(direction)

