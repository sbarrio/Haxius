package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxVelocity;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;

class Bullet extends FlxSprite
{

    private var speed:Float;
    private var direction:Int;
    private var damage:Float;

    public function new(X:Float, Y:Float,Speed:Float,Direction:Int,Damage:Float)
    {
        super(X,Y);
        speed = Speed;
        direction = Direction;
        damage = Damage;
        loadGraphic(Reg.BULLET, true, 6, 6, true, "bullet");
    }

    override public function update():Void
    {
        super.update();
        if (direction == FlxObject.LEFT){
            velocity.x = -speed;     
        }
        if (direction == FlxObject.RIGHT){
            velocity.x = speed;     
        }
        if (direction == FlxObject.FLOOR){
            velocity.y = speed;     
        }
        if (direction == FlxObject.CEILING){
            velocity.y = -speed;     
        }
        
    }

    override public function destroy():Void
    {
        super.destroy();
    }

}