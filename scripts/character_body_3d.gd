extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var _camera_3d: Camera3D = get_node("Camera3D")
@onready var _view_cast: RayCast3D = get_node("RayCast3D")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_view_cast.enabled = true
	_view_cast.target_position = Vector3.FORWARD * 4
	timer.autostart = false
	timer.one_shot = true
	
	add_child(timer)

var can_analyse: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			can_analyse = true
		else:
			can_analyse = false
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * 0.01)
			_camera_3d.rotate_x(-event.relative.y * 0.01)
			_camera_3d.rotation.x = clamp(_camera_3d.rotation.x, deg_to_rad(-45), deg_to_rad(70))
			_view_cast.rotate_x(-event.relative.y * 0.01)
			_view_cast.rotation.x = clamp(_camera_3d.rotation.x, deg_to_rad(-45), deg_to_rad(70))

@onready var creature_counter = %CreatureCounter

func _physics_process(delta):
# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

		# Get the global position of the player
	var player_position: Vector3 = global_transform.origin
	var dir = velocity
	dir.y = 0
	dir = dir.normalized()
	#_view_cast.look_at(dir * 100, Vector3.UP)
	_view_cast.force_raycast_update()
	if can_analyse and _view_cast.is_colliding():
		var collider = _view_cast.get_collider()
		var groups = collider.get_groups()
		if not analysing and groups.has("creature") and not groups.has("Found"):
			print("Start analysing")
			analysing = true
			timer.timeout.connect(toto.bind(collider))

			timer.start(2.0)
			print(timer.is_stopped())
			print("Let's go")
	else:
		if analysing:
			if not timer.is_stopped():
				print("Stopping analysis")
				analysing = false
				timer.stop()
				timer.timeout.disconnect(toto)

@onready var timer: Timer = Timer.new()

var analysing: bool = false

signal creature_analised

func toto(collider: Object) -> void:
	print("Done")
	emit_signal(&"creature_analised"); 
	collider.add_to_group("Found")
