extends Node2D

@export var height_color_gradient : Gradient
@export var start_layer = 0
@export var number_of_layers = 4
@export var scale_increment_per_layer = 0.1

func _ready():
	if height_color_gradient == null:
		height_color_gradient = Gradient.new()
	generate_layers()

func generate_layers():
	var layers = []
	for cur_layer_ind in range(number_of_layers):
		layers.append(generate_layer(cur_layer_ind + start_layer))
	for layer in layers:
		add_child(layer)

func get_color_for_layer(layer_ind: int, max_layer: int):
	var color_sample_pos = layer_ind / (max_layer-1.0)
	return height_color_gradient.sample(color_sample_pos)

func generate_layer(cur_layer_ind: int):
	var cur_scale = 1.0 + (1+cur_layer_ind) * scale_increment_per_layer
	var cur_color = get_color_for_layer(cur_layer_ind, number_of_layers)
	
	var new_layer = CanvasLayer.new()
	new_layer.name = "CanvasLayer%s" % (cur_layer_ind)
	new_layer.follow_viewport_enabled = true
	new_layer.follow_viewport_scale = cur_scale
	new_layer.layer = cur_layer_ind
	
	var dup = duplicate(8)
	dup.modulate = cur_color
	new_layer.add_child(dup)
	return new_layer
