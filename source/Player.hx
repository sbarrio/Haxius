package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxVelocity;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;

class Player extends FlxSprite
{

    private static var SPEED:Float = 250;
    private var bulletArray:FlxTypedGroup<Bullet>;

    public function new(X:Float, Y:Float,playerBulletArray:FlxTypedGroup<Bullet>)
    {
        super(X,Y);

        alive = true;
        
        loadGraphic(Reg.PLAYER, true, 32, 22);
        animation.add("fly", [0, 1], 5, true);
        animation.add("explode", [2], 5, true);
        animation.play("fly");

        bulletArray = playerBulletArray;
    }

    override public function update():Void
    {

        velocity.x = 0;
        velocity.y = 0;

        if (alive){
            //Input
            if (FlxG.keys.pressed.LEFT)
            {
                moveLeft();
            }

            if (FlxG.keys.pressed.RIGHT)
            {
                moveRight();
            }

            if (FlxG.keys.pressed.UP)
            {
                moveUp();
            }

            if (FlxG.keys.pressed.DOWN)
            {
                moveDown();
            }

            if (FlxG.keys.justPressed.A){
                attack();
            }
        }


        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function killPlayer():Void{
        alive = false;
        animation.play("explode");
        FlxG.sound.play(Reg.SND_PLAYER_EXPLODES);
    }


    private function attack():Void{
        var newBullet = new Bullet(x + 32, y+15,500,FlxObject.RIGHT,10);
        bulletArray.add(newBullet);
        FlxG.sound.play(Reg.SND_BULLET_FIRE);
    }

    private function moveRight():Void{
            velocity.x += SPEED;
    }

    private function moveLeft():Void{
            velocity.x -= SPEED;
    }

    private function moveUp():Void{
            velocity.y -= SPEED;
    }

    private function moveDown():Void{
            velocity.y += SPEED;
    }
}