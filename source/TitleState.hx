package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.text.FlxText;
import flixel.effects.FlxFlicker;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;

class TitleState extends FlxState
{

	private var _emitter:FlxEmitter;
	private var _whitePixel:FlxParticle;
	private var text:FlxText;
	private var spacePressed:Bool;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		spacePressed = false;

		//star emmiter
		_emitter = new FlxEmitter(320, 200, 300);
		_emitter.setXSpeed(-300, 300);
		_emitter.setYSpeed( -100, 100);
		add(_emitter);

		for (i in 0...(Std.int(_emitter.maxSize / 2))) 
		{
			_whitePixel = new FlxParticle();
			_whitePixel.makeGraphic(2, 2, FlxColor.WHITE);
			// Make sure the particle doesn't show up at (0, 0)
			_whitePixel.visible = false; 
			_emitter.add(_whitePixel);
			_whitePixel = new FlxParticle();
			_whitePixel.makeGraphic(1, 1, FlxColor.WHITE);
			_whitePixel.visible = false;
			_emitter.add(_whitePixel);
		}

		_emitter.start(false, 10, .01);

		var title = new FlxSprite(10,90);
		title.loadGraphic(Reg.TITLE_LOGO,true,616,131);
		add(title);

		text = new FlxText(180,300,400,"Press SPACE to play!",20,false);
		add(text);

		var auth = new FlxText(260,430,300,"sbarrio 2015",14,false);
		add(auth);

		FlxFlicker.flicker(text, 0, 0.5, false, false, null, null);
	}
	

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
		if (FlxG.keys.justPressed.SPACE && !spacePressed){
			spacePressed = true;
			FlxFlicker.stopFlickering(text);
			FlxG.sound.play(Reg.MUSIC_START,1,false,false,musicFinishedPlaying);
		}
	}	

	private function musicFinishedPlaying():Void{
		FlxG.switchState(new StageState());
	}
}