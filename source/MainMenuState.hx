package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import sys.io.File;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	public var code:Float = 0;
	var picoo:BGSprite;
	var bf:BGSprite;
	var chesta:BGSprite;
	var spoopy:BGSprite;
	var fart:FlxText;

	var typin:String = ''; // for the code

	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'options',
		'credits'
	];

	var magenta:FlxSprite;
	var menuItem:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);


		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 0.6;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		//HI JACKIE OVER HERE
		// put in the menu items like this
		// addMenuItem(id (SHOULD BE 0, 1, 2, 3 BASED ON THE ARRAY) EX: story mode is 0, x - x value, y - y value)
		// addMenuItem(0, 0, 0); should spawn story mode in the top left corner
		// this was done by TK since im stupid and couldnt figure it out

		addMenuItem(0, 650, 50);
		addMenuItem(1, 950, 120);
		addMenuItem(2, 750, 340);
		addMenuItem(3, 950, 430);

		var blackfuck:BGSprite = new BGSprite('mainmenu/blackfuck', -250, 0, 0.9, 0.9);
		add(blackfuck);

		picoo = new BGSprite('mainmenu/menu_picer', -275, -150, 0.9, 0.9, ['deez pico idle'], false);
		picoo.visible = false;
		picoo.setGraphicSize(Std.int(picoo.width * 0.5));
		add(picoo);

		bf = new BGSprite('mainmenu/menu_bf', -275, -215, 0.9, 0.9, ['deez bf idle'], false);
		bf.visible = false;
		bf.setGraphicSize(Std.int(bf.width * 0.5));
		add(bf);

		spoopy = new BGSprite('mainmenu/menu_spooks', -275, -215, 0.9, 0.9, ['deez skid and pump idle'], false);
		spoopy.visible = false;
		spoopy.setGraphicSize(Std.int(spoopy.width * 0.5));
		add(spoopy);

		chesta = new BGSprite('mainmenu/menu_chester', -55, 75, 0.9, 0.9, ['deez chester idle'], false);
		chesta.visible = false;
		chesta.setGraphicSize(Std.int(chesta.width * 0.8));
		add(chesta);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "D-Sides V 2.5", 12);
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		#if android
		addVirtualPad(UP_DOWN, A_B);
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;
	var codeClearTimer:Float = 0;

	override function beatHit(){
		trace("beet hit");
		chesta.dance();
		spoopy.dance();
		bf.dance();
		picoo.dance();
	}

	function keyInput(k:FlxKey): String{
		var asString = k.toString().toLowerCase();
		switch(asString){
			case 'zero' | 'numpadzero': return '0';
			case 'one' | 'numpadone': return '1';
			case 'two' | 'numpadtwo': return '2';
			case 'three' | 'numpadthree': return '3';
			case 'four' | 'numpadfour': return '4';
			case 'five' | 'numpadfive': return '5';
			case 'six' | 'numpadsix': return '6';
			case 'seven' | 'numpadseven': return '7';
			case 'eight' | 'numpadeight': return '8';
			case 'nine' | 'numpadnine': return '9';
			case 'backslash': return '\\';
			case 'any' | 'none' | 'printscreen' | 'pageup' | 'pagedown' | 'home' | 'end' | 'insert' | 'escape' | 'delete' | 'backspace' | 'capslock' | 'enter' | 'shift' | 'control' | 'alt' | 'f1' | 'f2' | 'f3' | 'f4' | 'f5' | 'f6' | 'f7' | 'f8' | 'f9' | 'f0' | 'tab' | 'up' | 'down' | 'left' | 'right': return '';
			case 'space': return ' ';
			case 'slash': return '/';
			case 'period' | 'numpadperiod': return '.';
			case 'comma': return ',';
			case 'lbracket': return '[';
			case 'rbracket': return ']';
			case 'semicolon': return ';';
			case 'colon': return ':';
			case 'plus' | 'numpadplus': return '+';
			case 'minus' | 'numpadminus': return '-';
			case 'asterisk' | 'numpadmultiply': return '*';
			case 'graveaccent': return '`';
			case 'quote': return '"';
			default: return asString;
		}
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());

									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());

									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());

									case 'credits':
										MusicBeatState.switchState(new CreditsState());

									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());

								}
							});
						}
					});
				}
			}

			// whoever did the previous code thing ur code sucks /hj -neb
			// im sorry neb :( -jackie
			if(codeClearTimer>0)codeClearTimer-=elapsed;
			if(codeClearTimer<=0)typin='';
			if(codeClearTimer<0)codeClearTimer=0;

			if(FlxG.keys.firstJustPressed()!=-1){
				codeClearTimer = 1 ; // 1 second to press next key in the code
				var key:FlxKey = FlxG.keys.firstJustPressed();
				typin += keyInput(key);
				switch(typin){
					case 'mighty':
						typin = '';
						PlayState.SONG = Song.loadFromJson('too-slow-hard', 'too-slow');
						LoadingState.loadAndSwitchState(new PlayState(), true);
					case 'zip':
						typin = '';
						var path = SUtil.sPath + '/incorrect.txt';
						var content:String = "YOU ARE SO FAR AND YET SO CLOSE
BUT EASY PUZZLES WOULD BE GROSS
SO IF YOU WOULD THINK LIKE ADULTS
THEN THAT JUST MIGHT YIELD MORE RESULTS
NO RAYS OF LIGHT WILL ENTER HERE
AND SOON THE FROST WILL FAST ADHERE
THE LEAST TO FEAR IS THAT YOU'D LOSE
CHAOTIC MANIA ENSUES
- .ZIP";
						try{
							File.saveContent(path, content);
						}catch(e:Dynamic){
							path = SUtil.getPath() + 'incorrect.txt';
							File.saveContent(path, content);
							trace(e);
						}						
					case 'sonic':
						typin = '';
						var path = SUtil.sPath + '/dumbass.txt';
						var content:String = "YOU MUST BE DENSER THAN A BRICK
I HAVE NO QUILLS WITH WHICH TO PRICK
WHILE I CAN HOLD MYSELF ON WALLS
THAT PORCUPINE WOULD SIMPLY FALL
YOU COULDN'T KILL ME WITH MERE SPIKES
AND I DON'T SHARE TROPHIES ON PIKES
SO THINK AGAIN, IF YOU'RE NOT BORED
WHAT IS THE PEN AGAINST THE SWORD?
- .ZIP";
						try{
							File.saveContent(path, content);
						}catch(e:Dynamic){
							path = SUtil.getPath() + 'dumbass.txt';
							File.saveContent(path, content);
							trace(e);
						}
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end

			#if android
        	if (FlxG.android.justPressed.BACK)
        	{
				PlayState.SONG = Song.loadFromJson('too-slow-hard', 'too-slow');
				LoadingState.loadAndSwitchState(new PlayState(), true);
			}
        	#end
		}
		Conductor.songPosition = FlxG.sound.music.time;
		super.update(elapsed);
	}

	function addMenuItem(id:Int, x:Float, y:Float) {
		menuItem = new FlxSprite(x, y);
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[id]);
		menuItem.animation.addByPrefix('idle', optionShit[id] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[id] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.scale.x = 0.6;
		menuItem.scale.y = 0.6;
		menuItem.ID = id;
		menuItems.add(menuItem);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		menuItem.updateHitbox();
	}

	function removeChar(char1:FlxSprite, char2:FlxSprite, char3:FlxSprite)
	{
		char1.visible = false;
		char2.visible = false;
		char3.visible = false;
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		switch (optionShit[curSelected])
        {
            case 'story_mode':
                removeChar(picoo, spoopy, chesta);
                bf.visible = true;
            case 'freeplay':
                removeChar(bf, picoo, chesta);
                spoopy.visible = true;
            case 'credits':
                removeChar(bf, picoo, spoopy);
                chesta.visible = true;
            case 'options':
                removeChar(bf, chesta, spoopy);
                picoo.visible = true;
        }

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
