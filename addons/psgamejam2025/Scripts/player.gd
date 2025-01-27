extends Node3D

@onready var front_ray := $RayForward
@onready var back_ray := $RayBack
@onready var right_ray := $RayRight
@onready var left_ray := $RayLeft

const MOVE_SPEED = 0.3
var tween

func _physics_process(delta: float) -> void:
	if tween is Tween:
		if tween.is_running():
			return
	if Input.is_key_label_pressed(KEY_W) and not front_ray.is_colliding(): 
		tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.FORWARD * 2), MOVE_SPEED)
	if Input.is_key_label_pressed(KEY_S) and not back_ray.is_colliding():
		tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.BACK * 2), MOVE_SPEED)
	if Input.is_key_label_pressed(KEY_A):
		tween = create_tween()
		tween.tween_property(self, "transform", transform.rotated_local(Vector3.UP, PI/2), MOVE_SPEED)
	if Input.is_key_label_pressed(KEY_D):
		tween = create_tween()
		tween.tween_property(self, "transform", transform.rotated_local(Vector3.UP, -PI/2), MOVE_SPEED)
	if Input.is_key_label_pressed(KEY_Q) and not left_ray.is_colliding():
		tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.LEFT * 2), MOVE_SPEED)
	if Input.is_key_label_pressed(KEY_E) and not right_ray.is_colliding():
		tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.RIGHT * 2), MOVE_SPEED)

	
