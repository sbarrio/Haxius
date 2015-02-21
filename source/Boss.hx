package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxVelocity;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;
import flixel.group.FlxTypedGroup;

class Boss extends FlxGroup
{
 
    private static var ENEMY_SPEED:Float = 250;
    public var weakSpot:HitSpot;
    public var body:BossBody;
    public var health:Float;
    public var bX:Float;

    private var bulletArray:FlxTypedGroup<Bullet>;

    public var isMoving:Bool;
    public var lastTimeShot:Float;


    public function new(baseX:Float,X:Float, Y:Float,Health:Float,bossBulletArray:FlxTypedGroup<Bullet>)
    {
        super(10);
        health = Health;
        active = false;
        body = new BossBody(X,Y);
        add(body);
        weakSpot = new HitSpot(X,Y+65);
        add(weakSpot);
        bulletArray = bossBulletArray;
        isMoving = false;
        lastTimeShot = 100;
        bX = baseX;
    }

    override public function update():Void
    {
        super.update();
        if (!isMoving){
            var x = bX + FlxRandom.floatRanged(10,480);
            var y = FlxRandom.floatRanged(20,300);
            var speed = FlxRandom.floatRanged(0.5,3.5);
            moveTo(x,y,speed);
        }

        lastTimeShot--;
        if (lastTimeShot <= 0){
            lastTimeShot = 100;
            attack();
        }
    }

    public function moveTo(X,Y,SPEED):Void{
        if (isMoving){
            return;
        }
        isMoving = true;
        FlxTween.linearMotion(body, body.x, body.y, X, Y, SPEED, true, { complete: finishedMoving,type: FlxTween.ONESHOT }); 
        FlxTween.linearMotion(weakSpot, weakSpot.x, weakSpot.y, X, Y+65, SPEED, true, {  complete: finishedMoving,type: FlxTween.ONESHOT }); 
    }

    private function attack():Void{
        var newBullet = new Bullet(body.x, body.y+65,500,FlxObject.LEFT,10);
        bulletArray.add(newBullet);
        FlxG.sound.play(Reg.SND_BULLET_FIRE);
    }

    public function finishedMoving(tween:FlxTween):Void{
        isMoving = false;
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