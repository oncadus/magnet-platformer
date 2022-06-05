extends Node2D

func _process(delta):
	if $Audio/BGM.playing == false:
		$Audio/BGM.playing = true;
