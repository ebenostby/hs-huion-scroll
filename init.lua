-- make the huion h610pro aka monoprice scroll using the second button
-- I set the config (in the huion driver) to have this button emit cmd-shift-option-/ (slash)
-- and this runs in hammerspoon

-- add to hammerspoon config and hit hs.reload()

local scrollModifiers = {"shift", "cmd", "alt"}
local kickoffKey = '¿'
local oldMousePosition = {}
local scrollIntensity = 1
local scrollAllowed = true
local scrollInterval = 1.0/60.0
local scrollTimer
local stopScrollingSoon = false

function scrollTime()
	scrollAllowed = 1
end
	
scrollTracker = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDragged }, function(e)
	--local modifiers = e:getFlags()
	----print(modifiers)
	if (scrollAllowed) then
		if (stopScrollingSoon) then
			scrollTracker:stop()
			scrollTimer:stop()
			return true
		end
		--print("allowed")
    	oldMousePosition = hs.mouse.absolutePosition()
		local dX = e:getProperty(hs.eventtap.event.properties['mouseEventDeltaX'])
		local dY = e:getProperty(hs.eventtap.event.properties['mouseEventDeltaY'])

		hs.eventtap.scrollWheel({0 , dY * scrollIntensity }, {})
		-- put the mouse back
		--hs.mouse.setAbsolutePosition(oldMousePosition)
		scrollAllowed = false
		scrollTimer:start()
		return true
	end
	return true
end)

initiateScroll = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
	local downKey = e:getCharacters()

	if (downKey == kickoffKey) then
		local modifiers = e:getFlags()
		local allset = true
		for _, flag in ipairs(scrollModifiers) do
			allset = allset and modifiers[flag]
		end
		if (allset) then 
			--print("start")
			--for _, flag in ipairs(scrollModifiers) do
				--print (flag, modifiers[flag])
			--end
			scrollTracker:start()
			scrollTimer:start()
			stopScrollingSoon = false
			return true
		end
	end
	return false
end)
terminateScroll = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(e)

    local modifiers = e:getFlags()
    local allset = true
    if (scrollTracker:isEnabled()) then 
		for _, flag in ipairs(scrollModifiers) do
			allset = allset and modifiers[flag]
		end
		if (not allset) then
			--print("term")			
			--for _, flag in ipairs(scrollModifiers) do
				--print (flag, modifiers[flag])
			--end
			stopScrollingSoon = true
			return false
		end
    end
    return false
end)
--print("starting")
scrollTimer=hs.timer.delayed.new(scrollInterval, scrollTime)
initiateScroll:start()
terminateScroll:start()
