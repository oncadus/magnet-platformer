extends KinematicBody2D

# movement shit
export (float) var maxSpd;
export (float) var grav;
export (float) var accel;
export (float) var frict;
export (float) var wallFrict;
export (float) var airRes; # air resistance
export (float) var jumpForce; # heheheh kinda like the game
export (float) var jumpAmmount;
# gravit var(s)
#export (PackedScene) var gravPointScene;

var velocity = Vector2.ZERO;
var magnet = null;
var spd = 0;
var jumpsLeft = 0;
onready var canJump = false;
onready var isPlayer = true;

func _ready():
	maxSpd *= 1000;
	grav *= 100;
	jumpForce *= 1000;
	$Sprite.play("idle");

func _physics_process(delta):
	var inputDir = Input.get_axis("left", "right");
	if magnet != null:
		# velocity = position.direction_to(magnet.position) * (grav * inputDir);
		position += (magnet.position - self.position) / 10;
		if Input.is_action_just_pressed("jump") && !Input.is_action_just_pressed("left") && !Input.is_action_just_pressed("right"):
			magnet = null;
	else:
		# sorta complicated-ish, all you need to know is, if (right button) pressed: move to the right
		# really it could be shorted a shit ton, but i *reallllyyy* wanted the movement to be supa smooth
		if inputDir != 0:
			spd = lerp(spd, maxSpd * inputDir, accel);
			velocity.x = spd * delta;
			$Sprite.play("run");
			$Sprite.flip_h = velocity.x > 0;
			if velocity.x > 0:
				$Sprite/RayCast2D.cast_to.y = -50;
			elif velocity.x < 0:
				$Sprite/RayCast2D.cast_to.y = 50;
		if is_on_floor():
			canJump = true;
			jumpsLeft = 0;
			if inputDir == 0:
				spd = lerp(spd, 0, frict);
				velocity.x = spd * delta;
				$Sprite.play("idle");
		else:
			jumpPause();
			if inputDir == 0:
				spd = lerp(spd, 0, airRes);
				velocity.x = spd * delta;
			if velocity.y < 0:
				$Sprite.play("jump");
			elif velocity.y > 0:
				$Sprite.play("fall");
		if Input.is_action_just_pressed("jump"):
			if canJump == true:
				jumpsLeft += 1;
				velocity.y = -jumpForce * delta;
			if jumpsLeft > jumpAmmount:
				canJump = false;
		
		velocity.y += grav * delta;
	
	velocity = move_and_slide(velocity, Vector2.UP); # DO NOT TOUCH THIS NOBODY WILL EVER TOUCH THIS 
	#LINE OF CODE IS HOLDING EVERYTHING TOGETHER IF YOU DELETE IT LITTERALLY EVERYTHING WILL BREAK AND 
	#YOUR FAMILY WILL BURN AND DIE AND YOURBONES WILL DEFLATE AND YOU DOG WILL DIE AND GOD WILL SMITE 
	# YOU DO NOT DELETE THIS LINE FOR ALL THAT IS HOLY ARK PLS DO NOT DELETE THIS LINE
	
	if $Sprite/RayCast2D.is_colliding() and Input.is_action_just_pressed("jump"):
		pass;

func _on_MagnetField_body_entered(body):
	if body.get_filename() == "res://gravpoint.tscn":
		magnet = body;

func jumpPause():
	yield(get_tree().create_timer(0.2), "timeout");
	jumpsLeft += 1;
