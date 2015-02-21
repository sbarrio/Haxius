package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxVelocity;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;

class Block extends FlxSprite
{
    private static var GRAVITY:Float = 50;

    public function new(X:Float, Y:Float,Health:Float)
    {
        super(X,Y);
        health = Health;
        loadGraphic(Reg.BLOCK, true, 32, 32, true, "block");
    }

    override public function update():Void
    {
        super.update();
        // velocity.y = GRAVITY;        
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function damage(damage:Float){
        health -= damage;
    }

    public function isDestroyed():Bool{
        if (health <= 0){
            return true;
        }
        return false;
    }

}