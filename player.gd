extends KinematicBody2D

# movement shit
export (float) var maxSpd;
export (float) var grav;
export (float) var accel;
export (float) var frict;
export (float) var airRes; # air resistance
export (float) var jumpForce; # heheheh kinda like the game
# gravit var(s)
#export (PackedScene) var gravPointScene;

var velocity = Vector2.ZERO;
var magnet = null;
var spd = 0;

func _ready():
	pass;

func _physics_process(delta):
	var inputDir = Input.get_action_strength("right") - Input.get_action_strength("left");
	velocity.y += grav * delta;
	if magnet != null:
		velocity = position.direction_to(magnet.position) * (spd * inputDir);
		if Input.is_action_just_pressed("jump"):
			magnet = null;
	else:
		# sorta complicated-ish, all you need to know is, if (right button) pressed: move to the right
		# really it could be shorted a shit ton, but i *reallllyyy* wanted the movement to be supa smooth
		if inputDir != 0:
			spd = lerp(spd, maxSpd * inputDir, accel);
			velocity.x = spd * delta;
		if is_on_floor():
			if inputDir == 0:
				spd = lerp(spd, 0, frict);
				velocity.x = spd * delta;
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jumpForce * delta;
		else:
			if inputDir == 0:
				spd = lerp(spd, 0, airRes);
				velocity.x = spd * delta;
	
	velocity = move_and_slide(velocity, Vector2.UP); # DO NOT TOUCH THIS NOBODY WILL EVER TOUCH THIS 
	#LINE OF CODE IS HOLDING EVERYTHING TOGETHER IF YOU DELETE IT LITTERALLY EVERYTHING WILL BREAK AND 
	#YOUR FAMILY WILL BURN AND DIE AND YOURBONES WILL DEFLATE AND YOU DOG WILL DIE AND GOD WILL SMITE 
	# YOU DO NOT DELETE THIS LINE FOR ALL THAT IS HOLY ARK PLS DO NOT DELETE THIS LINE

func _on_MagnetField_body_entered(body):
	if body.get_filename() == "res://gravpoint.tscn":
		magnet = body;
