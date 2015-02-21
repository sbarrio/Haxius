package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxVelocity;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;

class BossBody extends FlxSprite
{

    public function new(X:Float, Y:Float)
    {
        super(X,Y);
        loadGraphic(Reg.BOSS,true,150,150);
    }

    override public function update():Void
    {
        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

}