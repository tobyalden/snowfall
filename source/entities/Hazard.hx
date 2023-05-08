package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import scenes.*;

class Hazard extends Entity
{
    public static inline var FALL_SPEED = 20;
    public static inline var ACCEL = 50;

    public var sprite:Image;
    public var velocity:Vector2;

    public function new(x:Float, y:Float) {
        super(x, y);
        type = "hazard";
        mask = new Hitbox(5, 5);
        sprite = Image.createRect(width, height, 0xFFFFFF);
        sprite.centerOrigin();
        sprite.x += width / 2;
        sprite.y += height / 2;
        graphic = sprite;
        velocity = new Vector2(
            0,
            FALL_SPEED * MathUtil.lerp(0.75, 1.25, Random.random)
        );
    }

    override public function update() {
        velocity.y += ACCEL * HXP.elapsed;
        moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed);
        if(y > GameScene.GAME_HEIGHT) {
            HXP.scene.remove(this);
        }
        super.update();
    }
}

