extends CharacterBody2D

#@export var target : Node2D
#var targets = [$"../Target1", $"../Target2"]
var targets = [Vector2(212, 77), Vector2(209, 184)]
var target_index = 0
var target = targets[target_index]
var end_pos = Vector2(61, 78)

var speed = 100
var acceleration = 7

@onready var navigation_agent : NavigationAgent2D = $Navigation/NavigationAgent2D

func _physics_process(delta):
	#target = get_node(targets[target_index])
	var direction = Vector2.ZERO
	direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized() #since we dont care about magnitude 
	
	velocity = velocity.lerp(direction * speed, acceleration * delta) #*delta to be indep of framerate
	
	move_and_slide()
	
func _on_timer_timeout():
	#target = get_node(targets[target_index])
	#target = targets[target_index]
	if target == null:
		return
	navigation_agent.target_position = target #if Vector2
	#navigation_agent.target_position = target.global_position #this is how we tell navAgent where its goal is
	


func _on_navigation_agent_2d_target_reached():
	#speed = 1
	target_index += 1
	if target_index >= targets.size():
		#target_index = 0 #loop back to first 
		target = end_pos #return to starting position
	else:
		target = targets[target_index]
	navigation_agent.target_position = target
