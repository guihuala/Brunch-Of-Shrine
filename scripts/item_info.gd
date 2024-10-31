extends TextureRect


func set_item_info(item_texture: Texture, value):
	$sprite.texture = item_texture
	set_label(value)


func set_label(value):
	if value != null:
		$Label.text = str(value)
	else:
		$Label.hide()


func play_flash_anim():
	$AnimationPlayer.play("flash")
