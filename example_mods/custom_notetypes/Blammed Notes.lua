function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do	
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Blammed Notes' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'Blammed');
			setPropertyFromGroup('unspawnNotes',i,'missHealth', 0.6)

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				
			end
		end
	end

end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == "Blammed Notes" then
			triggerEvent('Play Animation', 'shoot', 0);
			triggerEvent('Screen Shake', "0.25, 0.0025", 0)
			playSound('gun')
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == "Blammed Notes" then
		triggerEvent('Screen Shake', "0.25, 0.0025", 0)
		triggerEvent('Play Animation', 'shoot', 0);
			if direction==0 then
					triggerEvent('Play Animation', 'Dodge left', 1 );
			elseif direction==1 then
					triggerEvent('Play Animation', 'Dodge down', 1);
			elseif direction==2 then
					triggerEvent('Play Animation', 'Dodge up', 1);
			elseif direction==3 then
					triggerEvent('Play Animation', 'Dodge right', 1);
			end
	end
end
