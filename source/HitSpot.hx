package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxVelocity;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;

class HitSpot extends FlxSprite
{

    public function new(X:Float, Y:Float)
    {
        super(X,Y);
        makeGraphic(20,20,FlxColor.RED);
        alpha = 0;
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