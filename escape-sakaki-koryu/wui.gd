extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5

var dir:Vector2
@onready var cam:Camera3D=$head/Camera3D
var cam_sens=50

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	rotate_cam(delta)
	move_and_slide()
	
func _input(event:InputEvent):
	if event is InputEventMouseMotion:dir=event.relative*0.01

func rotate_cam(delta:float, sens_mod:float=1.0):
	var input=Input.get_vector("look_left", "look_right", "look_up", "look_down")
	dir+=input
	rotation.y-=dir.x*cam_sens*delta
	cam.rotation.x=clamp(cam.rotation.x-dir.y*cam_sens*sens_mod*delta,-1.5,1.5)
	dir=Vector2.ZERO
