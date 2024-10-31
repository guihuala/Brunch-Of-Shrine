extends Sprite2D

@export var shrink_time: float = 5.0  # 泡沫缩小所需的总时间（秒）
@export var start_scale: float = 3.0  # 泡沫初始大小

func _ready():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(self, "scale", Vector2.ZERO, shrink_time).from(Vector2.ONE * start_scale)
	
	tween.tween_callback(queue_free)
