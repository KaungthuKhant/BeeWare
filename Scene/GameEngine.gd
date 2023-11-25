extends Node

var player_is_alive = true

var buildingVisited = []
# ==============================================
# var allBuildings = ["Birdsong", "Andrew", "Library", "Copley", "Easter"]
# var buildingWithPuzzlePieces = random[allBuilding, 3]

# above 2 lines replace this following line of code
var buildingWithPuzzlePiecesTotal = ["Birdsong", "Andrew", "Library", "Copley", "Estes", "Brock_Science", "Fox"]
var UnsafeTerritory = ["Danger1", "Danger2", "Danger3", "Danger4"]
var buildingWithPuzzlePieces = []
# Called when the node enters the scene tree for the first time.
func _ready():
	$ohNo.visible = false
	var chosenBuildingID  = []
	randomize()
	while len(buildingWithPuzzlePieces) < 5:
		var i = randi()%7+1
		var there = false
		for a in chosenBuildingID:
			if a == i:
				there = true
		if not there:
			buildingWithPuzzlePieces.append(buildingWithPuzzlePiecesTotal[i-1])
			chosenBuildingID.append(i)
	$warning.visible = false
	$PuzzleLocationInfo/ColorRect/VBoxContainer/B1.text = buildingWithPuzzlePieces[0]
	$PuzzleLocationInfo/ColorRect/VBoxContainer/B2.text = buildingWithPuzzlePieces[1]
	$PuzzleLocationInfo/ColorRect/VBoxContainer/B3.text = buildingWithPuzzlePieces[2]
	$PuzzleLocationInfo/ColorRect/VBoxContainer/B4.text = buildingWithPuzzlePieces[3]
	$PuzzleLocationInfo/ColorRect/VBoxContainer/B5.text = buildingWithPuzzlePieces[4]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Area2D_area_entered(area):
	# we could replace this process with a dictionary 
	var visited = false
	# check to see if the building that the player just entered is the already visited
	for b in buildingVisited:
		if b == area.name:
			visited = true
			
	if not visited:
		# again, we can use set for this to make things faster
		for b in range(len(buildingWithPuzzlePieces)):
			if buildingWithPuzzlePieces[b] == area.name:
				buildingVisited.append(area.name)
				buildingWithPuzzlePieces[b] += "  *"
				$Player.speed += 20
		$PuzzleLocationInfo/ColorRect/VBoxContainer/B1.text = buildingWithPuzzlePieces[0]
		$PuzzleLocationInfo/ColorRect/VBoxContainer/B2.text = buildingWithPuzzlePieces[1]
		$PuzzleLocationInfo/ColorRect/VBoxContainer/B3.text = buildingWithPuzzlePieces[2]
		$PuzzleLocationInfo/ColorRect/VBoxContainer/B4.text = buildingWithPuzzlePieces[3]
		$PuzzleLocationInfo/ColorRect/VBoxContainer/B5.text = buildingWithPuzzlePieces[4]
				
						
		for b in buildingWithPuzzlePieces:
			if b == area.name:
				# ============================================================================================
				# This is where you send it to the mini game
				# ============================================================================================
				var winMiniGame = false
				if b == "Bridsong":
					# send to mini game
					# pause the game 
					# if player win, set winMinigame to true, else do nothing
					pass
				elif b == "Andrew":
					# send to mini game
					pass
				
				# ============================================================================================	
				# Update the puzzle pieces count
				# ============================================================================================
				if winMiniGame:
					buildingVisited.append(area.name)
					pass
	$CanvasLayer/PuzzlePieces/PuzzleCount.text = str(len(buildingVisited)) + "/5"
	# ============================================================================================
	# This is where you win the game when you collect all puzzle pices
	# ============================================================================================
	if len(buildingVisited) == 5:
		print("You win")
		get_tree().change_scene("res://youWin/youWin.tscn")
	
	if area.name == "SafeZone":
		$warning.visible = false
		$Skeleton.speed = 120

func _on_Area2D_area_exited(area):
	if area.name == "SafeZone":
		print("Exited")
		$warning.visible = true
		$Skeleton.speed = 275


func _on_Timer_timeout():
	
	var closeness = $Player.position - $Skeleton.position
	if closeness.length() <= 210:
		$ohNo.visible = true
	else:
		$ohNo.visible = false
