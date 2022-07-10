--[[
    Author: Justin Burns
    Version: 0.1
    Date: 07-08-2022
    
    A flexible interface for configuring and mapping gestures.

    Building off the work of Mark van der Berg https://github.com/mark-vandenberg/g-hub-mouse-gestures/
    Special credits to https://github.com/wookiefriseur for showing a way to do this for windows gestures which inspired this script
    For some windows gestures check https://github.com/wookiefriseur/LogitechMouseGestures
    This script wil let you use a button on your mouse to act like the "Gesture button" from Logitech Options.
    It will also let you use another button on your mouse for navigating between browser pages using gestures.
]]--
 
-- The minimal horizontal/vertical distance your mouse needs to be moved for the gesture to recognize in pixels
minimalHorizontalMovement = 2500;
minimalVerticalMovement = 2500;

-- Default values for 
horizontalStartingPosition = 0;
verticalStartingPosition = 0;
horizontalEndingPosition = 0;
verticalEndingPosition = 0;

-- Delay between keypresses in millies
delay = 20

os = "windows" -- windows, macos

actions = { macos = {}, windows = {} }

-- Toggles debugging messages
debuggingEnabled = true
os = "windows"


currentCycle = 1
cycleStates = { 
  function() pressThreeKeys("lctrl", "lalt", "d") end, 
  function() pressThreeKeys("lctrl", "lalt", "f") end, 
  function() pressThreeKeys("lctrl", "lalt", "g") end 
} 

-- ==========================================================================================

-- Macos actions
actions["macos"]["5U"] = function() pressTwoKeys("lctrl", "up") end
actions["macos"]["5D"] = function() pressTwoKeys("lctrl", "down") end
actions["macos"]["5L"] = function() pressTwoKeys("lctrl", "left") end
actions["macos"]["5R"] = function() pressTwoKeys("lctrl", "right") end

actions["macos"]["6U"] = function() pressThreeKeys("lctrl", "lalt", "up") end
actions["macos"]["6D"] = function() pressThreeKeys("lctrl", "lalt", "down") end
--actions["macos"]["6L"] = function() pressThreeKeys("lctrl", "lalt", "left") end
--actions["macos"]["6R"] = function() pressThreeKeys("lctrl", "lalt", "right") end

actions["macos"]["6L"] = function() cycleStates[currentCycle](); if currentCycle == #cycleStates then currentCycle = 1 else currentCycle = currentCycle + 1 end end
actions["macos"]["6R"] = function() cycleStates[currentCycle](); if currentCycle == 1 then currentCycle = #cycleStates else currentCycle = currentCycle - 1 end end

-- ==========================================================================================

-- Windows actions
actions["windows"]["5U"] = function() pressTwoKeys("lctrl", "up") end
actions["windows"]["5D"] = function() pressTwoKeys("lctrl", "down") end
actions["windows"]["5L"] = function() pressTwoKeys("lgui", "left") end
actions["windows"]["5R"] = function() pressTwoKeys("lgui", "right") end

actions["windows"]["6U"] = function() pressThreeKeys("lctrl", "lalt", "up") end
actions["windows"]["6D"] = function() pressThreeKeys("lctrl", "lalt", "down") end
actions["windows"]["6L"] = function() pressThreeKeys("lctrl", "lgui", "left") end
actions["windows"]["6R"] = function() pressThreeKeys("lctrl", "lgui", "right") end
  
-- ==========================================================================================

-- TODO: What if multiple buttons are pressed? we should use the buttonNumber on MouseUp to match up to the right starting coords,
-- or keep track of the last button that was pressed and reset if button changes

-- Event detection
function OnEvent(event, arg, family)
    buttonNumber = arg
    
    if event == "MOUSE_BUTTON_PRESSED" then
		if debuggingEnabled then OutputLogMessage("\nEvent: " .. event .. " for button: " .. buttonNumber .. "\n") end
		
		-- Get starting mouse position
		horizontalStartingPosition, verticalStartingPosition = GetMousePosition()
		
		if debuggingEnabled then 
			OutputLogMessage("Horizontal starting Position: " .. horizontalStartingPosition .. "\n") 
			OutputLogMessage("Vertical starting Position: " .. verticalStartingPosition .. "\n") 
		end
	end

    -- =============================

	if event == "MOUSE_BUTTON_RELEASED" then
		if debuggingEnabled then OutputLogMessage("\nEvent: " .. event .. " for button: " .. buttonNumber .. "\n") end
		
		-- Get ending mouse Position
		horizontalEndingPosition, verticalEndingPosition = GetMousePosition()
		
		if debuggingEnabled then 
			OutputLogMessage("Horizontal ending Position: " .. horizontalEndingPosition .. "\n") 
			OutputLogMessage("Vertical ending Position: " .. verticalEndingPosition .. "\n") 
		end

		-- Calculate differences between start and end Positions
		horizontalDifference = horizontalStartingPosition - horizontalEndingPosition
		verticalDifference   = verticalStartingPosition   - verticalEndingPosition

        if horizontalDifference >  minimalHorizontalMovement then direction = "L" 
        elseif horizontalDifference < -minimalHorizontalMovement then direction = "R"
        elseif verticalDifference   >  minimalVerticalMovement   then direction = "D"
        elseif verticalDifference   < -minimalVerticalMovement   then direction = "U" 
        end

        if direction then
            key = buttonNumber .. direction
            if actions[os][key] and type(actions[os][key]) == "function" then 
                actions[os][key]() 
                if debuggingEnabled then OutputLogMessage("Key" .. key) end
            end
        end
        
        direction = nil
	end
end

-- ==========================================================================================

-- Helper Functions
function pressTwoKeys(firstKey, secondKey)
	PressKey(firstKey)
	Sleep(delay)
	PressKey(secondKey)
	Sleep(delay)
	ReleaseKey(secondKey)
	Sleep(delay)
	ReleaseKey(firstKey)
end

-- Helper Functions
function pressThreeKeys(firstKey, secondKey, thirdKey)
	PressKey(firstKey)
	Sleep(delay)
	PressKey(secondKey)
	Sleep(delay)
	PressKey(thirdKey)
	Sleep(delay)

       ReleaseKey(thirdKey)
	Sleep(delay)
	ReleaseKey(firstKey)
	Sleep(delay)
	ReleaseKey(secondKey)
end
