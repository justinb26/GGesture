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
    The default settings below will be for the multytasking gestures from macOS
    - Up 		Mission Control 	(Control+Up-Arrow)
    - Down 	Application Windows (Control+Down-Arrow)
    - Left 	move right a space 	(Control+Right-Arrow)
    - Right 	move left a space 	(Control+Left-Arrow)
    The default settings below will be for the navigation gestures for in browsers
 - Up 		{ no action }
 - Down 	{ no action }
 - Left 	next page 		(Command+Right-Bracket)
 - Right 	previous page 	(Command+Left-Bracket)
]]--
 
-- The minimal horizontal/vertical distance your mouse needs to be moved for the gesture to recognize in pixels
minimalHorizontalMovement = 200;
minimalVerticalMovement = 200;

-- Default values for 
horizontalStartingPosition = 0;
verticalStartingPosition = 0;
horizontalEndingPosition = 0;
verticalEndingPosition = 0;

-- Delay between keypresses in millies
delay = 20


actions = {}
    actions["5U"] = function() { pressTwoKeys("lctrl", "up")}
    actions["5D"] = function() { pressTwoKeys("lctrl", "down")}
    actions["5L"] = function() { pressTwoKeys("lctrl", "left")}
    actions["5R"] = function() { pressTwoKeys("lctrl", "right")}

    actions["6U"] = function() { pressThreeKeys("lctrl", "lalt", "up")}
    actions["6D"] = function() { pressThreeKeys("lctrl", "lalt", "down")}
    actions["6L"] = function() { pressThreeKeys("lctrl", "lalt", "left")}
    actions["6R"] = function() { pressThreeKeys("lctrl", "lalt", "right")}
        

-- Toggles debugging messages
debuggingEnabled = false

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

        if horizontalDifference >  minimalHorizontalMovement then direction = "L" end
		if horizontalDifference < -minimalHorizontalMovement then direction = "R" end
		if verticalDifference   >  minimalVerticalMovement   then direction = "D" end
		if verticalDifference   < -minimalVerticalMovement   then direction = "U" end

        if direction then
            key = buttonNumber .. direction
            if actions[key] and type(actions[key]) == "function" then 
                actions[key]() 
            end
        end
	end
end

-- ==========================================================================================

-- Helper Functions
function pressTwoKeys(firstKey, secondKey)
	PressKey(firstKey)
	Sleep(delay)
	PressKey(secondKey)
	Sleep(delay)
	ReleaseKey(firstKey)
	ReleaseKey(secondKey)
end

-- Helper Functions
function pressThreeKeys(firstKey, secondKey, thirdKey)
	PressKey(firstKey)
	Sleep(delay)
	PressKey(secondKey)
	Sleep(delay)
	PressKey(thirdKey)
	Sleep(delay)

	ReleaseKey(firstKey)
	ReleaseKey(secondKey)
    ReleaseKey(thirdKey)
end
