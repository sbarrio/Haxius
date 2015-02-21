package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxVelocity;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;

class Enemy extends FlxSprite
{
 
    private static var ENEMY_SPEED:Float = 250;
    private static var ROTATION_SPEED:Float = 20;

    public function new(X:Float, Y:Float,Health:Float)
    {
        super(X,Y);
        health = Health;
        active = false;
        loadGraphic(Reg.ENEMY, true, 20, 20);
        animation.add("fly", [0], 5, true);
        animation.add("explode", [1], 5, true);
        animation.play("fly");
    }

    override public function update():Void
    {
        super.update();
        velocity.x = 0;
        if (active){
            velocity.x = -ENEMY_SPEED;
            angle += ROTATION_SPEED;
        }
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function damage(damage:Float){
        health -= damage;
    }

    public function isDead():Bool{
        if (health <= 0){
            return true;
        }
        return false;
    }
}