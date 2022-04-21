function onCreate()

    makeLuaSprite('bg','W5/bgWalls', -1199, -861)
	addLuaSprite('bg',false)
	setLuaSpriteScrollFactor('bg' , 0.6, 0.6);

	makeLuaSprite('stands','W5/bgEscalator', -1372, -802)
	addLuaSprite('stands', false)
	setLuaSpriteScrollFactor('stands' , 0.5, 0.1);

	makeAnimatedLuaSprite('Audience2', 'W5/upperBop', -237, 214)
	addAnimationByPrefix('Audience2', 'IdleEaster2', 'Upper Crowd Bop', 24, true)
	addLuaSprite('Audience2', false)
	objectPlayAnimation ('Audience2', 'IdleEaster2', false)
	setLuaSpriteScrollFactor('Audience2' , 0.5, 0.1);

	makeLuaSprite('egg','W5/christmasTree', 298, -307)
	addLuaSprite('egg', false);
	setLuaSpriteScrollFactor('egg' , 0.6, 0.6);

	makeAnimatedLuaSprite('Audience', 'W5/bottomBop', -153, 19)
	addAnimationByPrefix('Audience','IdleEaster', 'Bottom Level Boppers', 24, true)
	addLuaSprite('Audience', false)
	objectPlayAnimation ('Audience', 'IdleEaster', false);

	makeLuaSprite('floor','W5/fgsnow',-581,675)
	addLuaSprite('floor', false);

	makeAnimatedLuaSprite('springtrap', 'W5/santa', -861, 158)
	addAnimationByPrefix('springtrap','IdleSpring','santa idle in fear', 24, true)
	addLuaSprite('springtrap', false)
	objectPlayAnimation ('springtrap', 'Idle', false)


end

function onBeatHit()
	objectPlayAnimation ('Audience', 'IdleEaster', true)
	objectPlayAnimation ('springtrap', 'IdleSpring', true)
	objectPlayAnimation ('Audience2', 'IdleEaster2', true)


end
