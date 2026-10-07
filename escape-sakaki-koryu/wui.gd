extends CharacterBody3D


const SPEED = 1.0
const SPRINT_SPEED=15
const JUMP_VELOCITY = 4.5

const BOB_FREQ=2.0
const BOB_AMP=0.1
var t_bob=0.0

var dir:Vector2
@onready var cam:Camera3D=$head/Camera3D
var cam_sens=50

var cam_captured:bool=true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
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
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	rotate_cam(delta)
	
	t_bob+=delta*velocity.length()*float(is_on_floor())
	$head.transform.origin=headbob(t_bob)
	move_and_slide()

func headbob(time)->Vector3:
	var pos=Vector3.ZERO
	pos.y=sin(time*BOB_FREQ)*BOB_AMP
	return pos
	
func _input(event:InputEvent):
	if event is InputEventMouseMotion:
		dir=event.relative*0.01
		print(event)

func rotate_cam(delta:float, sens_mod:float=1.0):
	rotation.y-=dir.x*cam_sens*delta
	cam.rotation.x=clamp(cam.rotation.x-dir.y*cam_sens*sens_mod*delta,deg_to_rad(-50),deg_to_rad(50))
	dir=Vector2.ZERO
	
#func _process(delta: float) -> void:
	#get_viewport().warp_mouse(Vector2(get_viewport().get_visible_rect().size.x/2, get_viewport().get_visible_rect().size.y/2))
