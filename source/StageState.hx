package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;

class StageState extends FlxState
{


	//bullets
	public var playerBullets:FlxTypedGroup<Bullet>;

	//enemies
	public var enemies:FlxTypedGroup<Enemy>;
	public var enemyBullets:FlxTypedGroup<Bullet>;

	//boss
	public var BOSS_HEALTH:Float = 500;
	public var boss:Boss = null;

	//blocks
	public var blocks:FlxTypedGroup<Block>;

	//screen
	public static var SCR_WIDTH = 640;
	public static var SCR_HEIGHT = 480;
	public var screenPositionX:Float = 0;
	public var screenSpeed:Float = 1;
	public var scroll:Bool = true;

	//player
	public var player:Player;

	//score
	public var score:Float;
	public var scoreText:FlxText;

	//bg
	public var bg:FlxSprite;

	//stage
	private var stage:TiledStage;
	var levelName:String = "stage";
	// var levelName:String = "bossTest";

	//music
	var musicTimer:FlxTimer;

	var gameOver:Bool = false;
	var stageCompleted:Bool = false;

	override public function create():Void
	{
		super.create();

		bg = new FlxSprite(0,0);
		bg.loadGraphic(Reg.BG,false,640,480);
		add(bg);

		stage = new TiledStage("assets/data/stage/" + levelName + ".tmx");

		//adds stage tiles
		add(stage.scenarioTiles);

		blocks = new FlxTypedGroup<Block>();
		add(blocks);

		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);

		enemyBullets = new FlxTypedGroup<Bullet>();
		add(enemyBullets);

		enemies = new FlxTypedGroup<Enemy>();
		add(enemies);

		player = new Player(100,100,playerBullets);
		add(player);

		//loads stage objects
		stage.loadObjects(this);

		//score
		score = 0;
		scoreText = new FlxText(10,10,200,"SCORE: " + score,20,false);
		add(scoreText);

		FlxG.camera.scroll = new FlxPoint(0,0);

		scroll = true;

		//starts playing music
		FlxG.sound.playMusic(Reg.MUSIC1,1,false);
		//sets up timer so when music1 is done we start playing music2
		musicTimer = new FlxTimer(31.0, playMusic2);

		//DEBUG
		FlxG.debugger.visible = false;
	}
	
	private function playMusic2(Timer:FlxTimer):Void{
		musicTimer.cancel();
		FlxG.sound.playMusic(Reg.MUSIC2,1,true);
	}

	private function playBossMusic():Void{
		FlxG.sound.playMusic(Reg.MUSIC3,1,true);
	}



	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();

		if (boss != null){
			boss.update();
		}

		if (gameOver || stageCompleted){
			if (FlxG.keys.pressed.SPACE){
				FlxG.sound.destroy(true);
				FlxG.switchState(new TitleState());
			}
		}

		//everything on screen must move at screen speed
		var newScroll = FlxG.camera.scroll;
		if (scroll){
			if (newScroll.x + SCR_WIDTH >= stage.fullWidth){
				scroll = false;
			}else{
				newScroll.x += screenSpeed;
				FlxG.camera.scroll = newScroll;
				player.x += screenSpeed;
				bg.x +=screenSpeed;
				scoreText.x +=screenSpeed;
			}			
		}

		//creates boss when player reaches stage's end
		if (boss == null && !scroll && !gameOver && !stageCompleted){
			playBossMusic();
			boss = new Boss(newScroll.x,newScroll.x + 400,200,BOSS_HEALTH,enemyBullets);
			add(boss);
		}

		//updates enemies
		//if enemy is inside bounds and not yet activated we turn it on
		for (e in enemies){
			if (!e.active && isInsideOfBounds(e)){
				e.active = true;
			}else{
				e.active = false;
			}
		}

		//updates player
			//inside of bounds
		if (player.x > newScroll.x + SCR_WIDTH-32){
			player.x = newScroll.x + SCR_WIDTH-32;	
		}
		if (player.x < newScroll.x){
			player.x = newScroll.x;
		}
		if (player.y > newScroll.y + SCR_HEIGHT-32){
			player.y = newScroll.y + SCR_HEIGHT-32;	
		}
		if (player.y < newScroll.y){
			player.y = newScroll.y;
		}

		//collides blocks with stage
		FlxG.overlap(stage.scenarioTiles,blocks,null,FlxObject.separate);

		//collides bullets with blocks
		FlxG.overlap(playerBullets,blocks,null,overlapped);

		//collides blocks with blocks
		FlxG.overlap(blocks,blocks,null,FlxObject.separate);

		//collides player with stage
		FlxG.overlap(stage.scenarioTiles, player, null, FlxObject.separate);

		//collides playerBullets with scenario
		FlxG.collide(stage.scenarioTiles,playerBullets,null);

		//collides playerBullets with enemies
		FlxG.overlap(playerBullets,enemies,null,overlapped);


		//updates boss
		if (boss != null){
			FlxG.overlap(playerBullets,boss,null,overlapped);	
			FlxG.overlap(boss,player,null,overlapped);
		}

		//player bullet update
		for (pb in playerBullets){
			//position
			pb.x += screenSpeed;

			//destroyed?
			if (pb.isTouching(FlxObject.ANY) || (pb.x > (newScroll.x + SCR_WIDTH))){
				playerBullets.remove(pb);
				pb.destroy();
			}
		}

		//enemy bullet update
		for (eb in enemyBullets){

			//destroyed?
			if (eb.isTouching(FlxObject.ANY) || (eb.x < newScroll.x)){
				enemyBullets.remove(eb);
				eb.destroy();
			}
		}

		//player collision
		if (player.alive){
			FlxG.overlap(blocks,player,null,overlapped);
			FlxG.overlap(enemies,player,null,overlapped);
			FlxG.overlap(enemyBullets,player,null,overlapped);

			if (player.isTouching(FlxObject.ANY)){
				player.killPlayer();
				GameOver();
			}
		}
	}	

	private function overlapped(Sprite1:FlxObject, Sprite2:FlxObject):Bool
	{
		var sprite1ClassName:String = Type.getClassName(Type.getClass(Sprite1));
		var sprite2ClassName:String = Type.getClassName(Type.getClass(Sprite2));

		if (sprite1ClassName == "Bullet" && sprite2ClassName == "Enemy"){
			var b: Dynamic = cast(Sprite1,Bullet);
			var e: Dynamic = cast(Sprite2,Enemy);

			//damages enemy
			e.damage(b.damage);
			FlxG.sound.play(Reg.SND_BULLET_HIT);
			if (e.isDead()){
				enemies.remove(e);
				Sprite2.destroy();
				score +=10;
				scoreText.text = "SCORE: " + score;

				//creates explosion at enemy position
				var e = new Explosion(e.x,e.y,50);
				add(e);
			}

			//destroys bullet
			playerBullets.remove(b);
			Sprite1.destroy();

			return true;
		}

		if (sprite1ClassName == "Bullet" && sprite2ClassName == "Block"){
			var bullet: Dynamic = cast(Sprite1,Bullet);
			var block: Dynamic = cast(Sprite2,Block);

			//damages enemy
			block.damage(bullet.damage);
			FlxG.sound.play(Reg.SND_BULLET_HIT2);
			if (block.isDestroyed()){
				blocks.remove(block);
				block.destroy();
				FlxG.sound.play(Reg.SND_BLOCK_DESTROYED);

				//creates explosion at block position
				var e = new Explosion(block.x,block.y,50);
				add(e);
			}

			//destroys bullet
			playerBullets.remove(bullet);
			bullet.destroy();

			return true;
		}

		if ((sprite1ClassName == "Enemy" || sprite1ClassName == "Block" || sprite1ClassName == "BossBody" || sprite1ClassName == "Bullet") && sprite2ClassName == "Player"){
			
			if (player.alive){
				player.killPlayer();	
				GameOver();
			}

			return true;
		}

		if (sprite1ClassName == "Bullet" && sprite2ClassName == "BossBody"){
			var bullet: Dynamic = cast(Sprite1,Bullet);
			//destroys bullet
			playerBullets.remove(bullet);
			bullet.destroy();
		}

		if (sprite1ClassName == "Bullet" && sprite2ClassName == "HitSpot"){
			var bullet: Dynamic = cast(Sprite1,Bullet);
			boss.damage(bullet.damage);
			FlxFlicker.flicker(boss.body,0.2,0.04,true,false,null,null);
			FlxG.sound.play(Reg.SND_BULLET_HIT);
			//destroys bullet
			playerBullets.remove(bullet);
			bullet.destroy();
			if (boss.isDead()){
				//creates explosions at boss position
				var e = new Explosion(boss.body.x,boss.body.y,50);
				add(e);
				e = new Explosion(boss.body.x+150,boss.body.y,50);
				add(e);
				e = new Explosion(boss.body.x,boss.body.y+150,50);
				add(e);
				e = new Explosion(boss.body.x+150,boss.body.y+150,50);
				add(e);
				e = new Explosion(boss.body.x+75,boss.body.y+75,50);
				add(e);
				boss.destroy();
				boss = null;
				//draw explosions where boss was
				FlxG.sound.play(Reg.SND_EXPLOSION);
				stageCompletedFun();
			}
		}

		return false;
	}

	private function GameOver():Void{
		gameOver = true;
		var newScroll = FlxG.camera.scroll;
		var gameOverText = new FlxText(newScroll.x + 210,180,300,"GAME OVER",35);
		add(gameOverText);
		var pressSpaceText = new FlxText(newScroll.x + 250,270,200,"Press SPACE",20);
		add(pressSpaceText);
		scroll = false;
	}

	private function stageCompletedFun(){
		stageCompleted = true;
		var newScroll = FlxG.camera.scroll;
		var stageCompletedText = new FlxText(newScroll.x + 150,180,400,"STAGE COMPLETED!",30);
		add(stageCompletedText);
		var pressSpaceText = new FlxText(newScroll.x + 220,270,200,"Press SPACE",20);
		add(pressSpaceText);
	}

	private function isInsideOfBounds(sprite:FlxSprite):Bool{
		var newScroll = FlxG.camera.scroll;

		if (sprite.x > newScroll.x + SCR_WIDTH+32){
			return false;
		}
		if (sprite.x < newScroll.x-32){
			return false;
		}
		if (sprite.y + sprite.height > newScroll.y + SCR_HEIGHT){
			return false;
		}
		if (sprite.y < newScroll.y){
			return false;
		}
		return true;
	}



}