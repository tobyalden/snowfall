package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import scenes.*;

class Player extends Entity
{
    public static inline var SPEED = 150;

    public var hasMoved(default, null):Bool;
    public var isDead(default, null):Bool;
    private var sprite:Image;
    private var velocity:Vector2;

    public function new(x:Float, y:Float) {
        super(x, y);
        mask = new Hitbox(10, 10);
        sprite = new Image("graphics/player.png");
        sprite.centerOrigin();
        sprite.x += width / 2;
        sprite.y += height / 2;
        graphic = sprite;
        velocity = new Vector2(SPEED, 0);
        hasMoved = false;
        isDead = false;
    }

    override public function update() {
        if(isDead) {
            return;
        }

        for(input in ["left", "right", "up", "down"]) {
            if(Input.check(input)) {
                if(!hasMoved) {
                    cast(HXP.scene, GameScene).onStart();
                }
                hasMoved = true;
            }
        }

        if(!hasMoved) {
            return;
        }

        if(Input.check("up")) {
            velocity.y = -SPEED;
        }
        else if(Input.check("down")) {
            velocity.y = SPEED;
        }
        else {
            velocity.y = 0;
        }

        moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed);

        if(x <= 0) {
            velocity.x = SPEED;
        }
        else if(right >= GameScene.GAME_WIDTH) {
            velocity.x = -SPEED;
        }
        y = MathUtil.clamp(y, 0, GameScene.GAME_HEIGHT - height);

        if(collide("hazard", x, y) != null) {
            die();
        }

        super.update();
    }

    public function die() {
        isDead = true;
        visible = false;
        explode();
        Main.sfx["die"].play();
        cast(HXP.scene, GameScene).onDeath();
    }

    private function explode() {
        var numExplosions = 50;
        var directions = new Array<Vector2>();
        for(i in 0...numExplosions) {
            var angle = (2/numExplosions) * i;
            directions.push(new Vector2(Math.cos(angle), Math.sin(angle)));
            directions.push(new Vector2(-Math.cos(angle), Math.sin(angle)));
            directions.push(new Vector2(Math.cos(angle), -Math.sin(angle)));
            directions.push(new Vector2(-Math.cos(angle), -Math.sin(angle)));
        }
        var count = 0;
        for(direction in directions) {
            direction.scale(0.8 * Math.random());
            direction.normalize(
                Math.max(0.1 + 0.2 * Math.random(), direction.length)
            );
            var explosion = new Particle(
                centerX, centerY, directions[count], 1, 1
            );
            explosion.layer = -99;
            HXP.scene.add(explosion);
            count++;
        }

#if desktop
        Sys.sleep(0.02);
#end
        HXP.scene.camera.shake(1, 4);
    }
}
