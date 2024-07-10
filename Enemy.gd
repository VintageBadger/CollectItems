extends CharacterBody2D

@onready var targets = [$"../Target1", $"../Target2", $"../Target3"]
#var targets = [Vector2(212, 77), Vector2(209, 184)]
var target_index = 0
var target 
var end_pos = Vector2(61, 78)

var speed = 100
var acceleration = 7

@onready var navigation_agent : NavigationAgent2D = $Navigation/NavigationAgent2D

func _ready():
	calc_nearest_target()

func calc_nearest_target():
	if targets.is_empty():
		target = end_pos
		return
	var nearest_idx = 0
	var nearest_dist = 10000
	var dist: float = 0
	for idx in targets.size():
		var enemy_pos = global_position
		var target_pos = targets[idx].global_position
		dist = enemy_pos.distance_to(target_pos)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_idx = idx
	target = targets[nearest_idx]
	target_index = nearest_idx
	
func _physics_process(delta):
	var direction = Vector2.ZERO
	direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized() #since we dont care about magnitude 
	
	velocity = velocity.lerp(direction * speed, acceleration * delta) #*delta to be indep of framerate
	
	move_and_slide()
	
func _on_timer_timeout():
	if target == null:
		return
	match typeof(target):
		TYPE_VECTOR2:
			navigation_agent.target_position = target #if Vector2
		TYPE_OBJECT:
			navigation_agent.target_position = target.global_position #this is how we tell navAgent where its goal is
		_:
			print("other type of target : ", typeof(target))


func _on_navigation_agent_2d_target_reached():
	#remove current target from list
	targets.remove_at(target_index)
	
	#find next closestest from the new location
	calc_nearest_target()
	match typeof(target):
		TYPE_VECTOR2:
			navigation_agent.target_position = target #if Vector2
		TYPE_OBJECT:
			navigation_agent.target_position = target.global_position #this is how we tell navAgent where its goal is
		_:
			print("other type of target : ", typeof(target))
	#
	##speed = 1
	#target_index += 1
	#if target_index >= targets.size():
		##target_index = 0 #loop back to first 
		#target = end_pos #return to starting position
	#else:
		##target = targets[target_index]
		#target = targets[target_index].global_position
	#navigation_agent.target_position = target
