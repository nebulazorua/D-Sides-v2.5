package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
using StringTools;

class FNFSprite extends FlxSprite
{
	public var offsets:Map<String,Array<Float>>=[];
	public var holdTimer:Float = 0;
	public var stepsToHold:Float = 6.1; // dadVar
	public var canResetIdle:Bool = false;

	override function update(elapsed:Float)
	{
		if(animation.curAnim != null)
		{
			if (animation.curAnim.name.startsWith('sing'))
				holdTimer += elapsed;
			else
				holdTimer=0;

			canResetIdle = (holdTimer >= Conductor.stepCrochet * 0.001 * stepsToHold) || holdTimer == 0 && !animation.curAnim.name.startsWith('sing') ;
		}
		super.update(elapsed);
	}


	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = offsets.get(AnimName);
		if (offsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		offsets[name] = [x, y];
	}
}
