extends Label

@export var drift_radius: float = 4.0
@export var drift_speed: float = 1.0

var base_position: Vector2
var drift_angle := 0.0

func _ready():
	base_position = position

func _process(delta):
	drift_angle += drift_speed * delta
	var offset = Vector2(
		sin(drift_angle * 1.3),
		cos(drift_angle * 1.7)
	) * drift_radius
	position = base_position + offset
