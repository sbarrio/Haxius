package;

import flixel.util.FlxSave;


class Reg
{
	//Sprites
	public static inline var BG:String = "assets/images/sprite/bg.png";
	public static inline var PLAYER:String = "assets/images/sprite/player.png";
	public static inline var BOSS:String = "assets/images/sprite/boss.png";
	public static inline var BULLET:String = "assets/images/sprite/blue_bullet.png";
	public static inline var ENEMY:String = "assets/images/sprite/enemy.png";
	public static inline var BLOCK:String = "assets/images/sprite/block.png";
	public static inline var EXPLOSION:String = "assets/images/sprite/explosion.png";
	public static inline var TITLE_LOGO = "assets/images/sprite/haxius_logo_big.png";

	//Sounds
	public static inline var SND_EXPLOSION:String = "assets/sounds/fx/explosion.wav";	
	public static inline var SND_PLAYER_EXPLODES:String = "assets/sounds/fx/player_explodes.wav";	
	public static inline var SND_BULLET_HIT:String = "assets/sounds/fx/bullet_hit.wav";
	public static inline var SND_BULLET_HIT2:String = "assets/sounds/fx/bullet_hit2.wav";		
	public static inline var SND_BULLET_FIRE:String = "assets/sounds/fx/bullet_fire.wav";
	public static inline var SND_BLOCK_DESTROYED:String = "assets/sounds/fx/block_destroyed.wav";

	//Music
	public static inline var MUSIC_START:String = "assets/music/start.wav";
	public static inline var MUSIC1:String = "assets/music/beg.wav";
	public static inline var MUSIC2:String = "assets/music/stage1.wav";
	public static inline var MUSIC3:String = "assets/music/boss.wav";

	public static inline var PATH_TILESHEETS:String = "assets/images/map/";

	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
}