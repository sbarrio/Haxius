package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxVelocity;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;

class Explosion extends FlxSprite
{
    private var ttl:Float;

    public function new(X:Float, Y:Float, TTL:Float)
    {
        super(X,Y);
        ttl = TTL;
        loadGraphic(Reg.EXPLOSION, true, 32, 32, true, "explosion");
        animation.add("explode", [2,1,0], 3, false);
        animation.play("explode");
        FlxG.sound.play(Reg.SND_EXPLOSION);
    }

    override public function update():Void
    {
        super.update();
        ttl--;
        if (ttl <= 0){
            destroy();
        }
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}