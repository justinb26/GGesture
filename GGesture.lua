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
]] --
-- The minimal horizontal/vertical distance your mouse needs to be moved for the gesture to recognize in pixels
os = "macos" -- windows, macos

minimalHorizontalMovement_WINDOWS = 2500; -- Roughly 1/26 of the screen
minimalVerticalMovement_WINDOWS = 2500;

minimalHorizontalMovement_MACOS = 200; -- 200px = about 1.8" at 110ppi
minimalVerticalMovement_MACOS = 100;

if (os == "windows") then
    minimalHorizontalMovement = minimalHorizontalMovement_WINDOWS;
    minimalVerticalMovement = minimalVerticalMovement_WINDOWS;
else
    minimalHorizontalMovement = minimalHorizontalMovement_MACOS;
    minimalVerticalMovement = minimalVerticalMovement_MACOS;
end

-- Default values for 
horizontalStartingPosition = 0;
verticalStartingPosition = 0;
horizontalEndingPosition = 0;
verticalEndingPosition = 0;

-- Delay between keypresses in millies
delay = 20

actions = {macos = {}, windows = {}}

-- Toggles debugging messages
debuggingEnabled = true

-- disable to test internal logic without triggering gestures
gesturesEnabled = true 
-- ==========================================================================================

numButtons = 9

buttons = {}
for i = 1, numButtons do buttons[i] = false end

stickyButtons = {}
for i = 1, numButtons do stickyButtons[i] = false end



-- Macos actions

-- Middle mouse button - Expose
-- actions["macos"]["3"] = function() PressAndReleaseMouseButton(2) end -- Note: Button 2, not 3
-- actions["macos"]["3U"] = function() end
-- actions["macos"]["3D"] = function() end
-- actions["macos"]["3L"] = function() end
-- actions["macos"]["3R"] = function() end

-- Button 4 (Bottom Right) - Magnet 1/2
-- actions["macos"]["4"] = function() PressAndReleaseMouseButton(4) end
actions["macos"]["4"] = function() pressKeyCombo({"lgui", "equal"}) end
actions["macos"]["4U"] = function() pressKeyCombo({"lctrl", "lalt", "up"}) end
actions["macos"]["4D"] = function() pressKeyCombo({"lctrl", "lalt", "down"}) end
actions["macos"]["4L"] = function() pressKeyCombo({"lctrl", "lalt", "left"}) end
actions["macos"]["4R"] = function() pressKeyCombo({"lctrl", "lalt", "right"}) end

-- Button 5 (Bottom middle) - Magnet 1/3
actions["macos"]["5"] = function() PressAndReleaseMouseButton(5) end
actions["macos"]["5U"] = function() pressKeyCombo({"lctrl", "lalt", "f"}) end
actions["macos"]["5D"] = function() pressKeyCombo({"lctrl", "lalt", "down"}) end
actions["macos"]["5L"] = function() pressKeyCombo({"lctrl", "lalt", "d"}) end
actions["macos"]["5R"] = function() pressKeyCombo({"lctrl", "lalt", "g"}) end

-- Button 6 (Bottom Left) - Magnet 1/6 (left)
actions["macos"]["6"] = function() pressKeyCombo({"lctrl", "lalt", "2"}) end
actions["macos"]["6U"] = function() pressKeyCombo({"lctrl", "lalt", "2"}) end
actions["macos"]["6D"] = function() pressKeyCombo({"lctrl", "lalt", "2"}) end
actions["macos"]["6L"] = function() pressKeyCombo({"lctrl", "lalt", "1"}) end
actions["macos"]["6R"] = function() pressKeyCombo({"lctrl", "lalt", "3"}) end

-- Button 7 (Top Right) - Expose
-- actions["macos"]["7"] = function() PressAndReleaseMouseButton(9) end
actions["macos"]["7"] = function() pressKeyCombo({"lgui", "minus"}) end
actions["macos"]["7U"] = function() pressKeyCombo({"lctrl", "up"}) end
actions["macos"]["7D"] = function() pressKeyCombo({"lctrl", "down"}) end
actions["macos"]["7L"] = function() pressKeyCombo({"lctrl", "left"}) end
actions["macos"]["7R"] = function() pressKeyCombo({"lctrl", "right"}) end

-- Button 8 (Top middle) - Magnet 1/2
actions["macos"]["8"] = function() PressAndReleaseMouseButton(8) end
actions["macos"]["8U"] = function() pressKeyCombo({"lctrl", "lalt", "up"}) end
actions["macos"]["8D"] = function() pressKeyCombo({"lctrl", "lalt", "down"}) end
actions["macos"]["8L"] = function() pressKeyCombo({"lctrl", "lalt", "left"}) end
actions["macos"]["8R"] = function() pressKeyCombo({"lctrl", "lalt", "right"}) end

-- Button 9 (Top left) - Magnet 1/6 (Right)
actions["macos"]["9"] = function() pressKeyCombo({"lctrl", "lalt", "5"}) end
actions["macos"]["9U"] = function() pressKeyCombo({"lctrl", "lalt", "5"}) end
actions["macos"]["9D"] = function() pressKeyCombo({"lctrl", "lalt", "5"}) end
actions["macos"]["9L"] = function() pressKeyCombo({"lctrl", "lalt", "4"}) end
actions["macos"]["9R"] = function() pressKeyCombo({"lctrl", "lalt", "6"}) end


-- Chorded gestures
actions["macos"]["58L"] = function() pressKeyCombo({"lctrl", "left"}) end
actions["macos"]["58R"] = function() pressKeyCombo({"lctrl", "right"}) end


-- ==========================================================================================

-- Windows actions
actions["windows"]["5U"] = function() pressKeyCombo({"lctrl", "up"}) end
actions["windows"]["5D"] = function() pressKeyCombo({"lctrl", "down"}) end
actions["windows"]["5L"] = function() pressKeyCombo({"lgui", "left"}) end
actions["windows"]["5R"] = function() pressKeyCombo({"lgui", "right"}) end

actions["windows"]["8U"] = function() pressKeyCombo({"lctrl", "lalt", "up"}) end
actions["windows"]["8D"] = function() pressKeyCombo({"lctrl", "lalt", "down"}) end
actions["windows"]["8L"] = function() pressKeyCombo({"lctrl", "lgui", "left"}) end
actions["windows"]["8R"] = function() pressKeyCombo({"lctrl", "lgui", "right"}) end

-- ==========================================================================================

-- TODO: What if multiple buttons are pressed? we should use the buttonNumber on MouseUp to match up to the right starting coords,
-- or keep track of the last button that was pressed and reset if button changes

-- Event detection
function OnEvent(event, arg, family)
    buttonNumber = arg

    if event == "MOUSE_BUTTON_PRESSED" then
        buttons[buttonNumber] = true
        stickyButtons[buttonNumber] = true

        if debuggingEnabled then
            OutputLogMessage("\nEvent: " .. event .. " for button: " ..
                                 buttonNumber .. "\n")
        end

        -- Get starting mouse position
        horizontalStartingPosition, verticalStartingPosition =
            GetMousePosition()

        if debuggingEnabled then
            OutputLogMessage("Horizontal starting Position: " ..
                                 horizontalStartingPosition .. "\n")
            OutputLogMessage("Vertical starting Position: " ..
                                 verticalStartingPosition .. "\n")
        end
    end

    -- =============================

    if event == "MOUSE_BUTTON_RELEASED" then
        buttons[buttonNumber] = false

        if debuggingEnabled then
            OutputLogMessage("\nEvent: " .. event .. " for button: " ..
                                 buttonNumber .. "\n")
        end

        -- Only unset sticky buttons and run actions if this is the last button
        if getMaskString(buttons) == getEmptyMaskString() then
            

            -- Get ending mouse Position
            horizontalEndingPosition, verticalEndingPosition =
                GetMousePosition()

            if debuggingEnabled then
                OutputLogMessage("Horizontal ending Position: " ..
                                     horizontalEndingPosition .. "\n")
                OutputLogMessage("Vertical ending Position: " ..
                                     verticalEndingPosition .. "\n")
            end

            -- Calculate differences between start and end Positions
            horizontalDifference = horizontalStartingPosition -
                                       horizontalEndingPosition
            verticalDifference = verticalStartingPosition -
                                     verticalEndingPosition

            if horizontalDifference > minimalHorizontalMovement then
                direction = "L"
            elseif horizontalDifference < -minimalHorizontalMovement then
                direction = "R"
            elseif verticalDifference > minimalVerticalMovement then
                direction = "D"
            elseif verticalDifference < -minimalVerticalMovement then
                direction = "U"
            else
                direction = ""
            end

            if direction then
                -- Get key from ALL buttons that were pressed during gesture (plus direction)
                key = getPressedButtons() .. direction
                
                if actions[os][key] and type(actions[os][key]) == "function" then
                    if gesturesEnabled then
                        actions[os][key]()
                    end
                    if debuggingEnabled then
                        OutputLogMessage("Key" .. key)
                    end
                end
            end

            clearStickyButtons()
            direction = nil
        end

    end

end

-- ==========================================================================================

function getMaskString(arrayOfBools)
    maskStr = ""
    for i = 1, numButtons do maskStr = maskStr .. tostring(arrayOfBools[i] and 1 or 0) end
    return maskStr
end

function getEmptyMaskString()
  maskStr = ""
  for i = 1, numButtons do maskStr = maskStr .. "0" end
  return maskStr
end

function getPressedButtons()
    pressedButtons = ""
    for i = 1, numButtons do
       if stickyButtons[i] then
         pressedButtons = pressedButtons .. tostring(i)
       end
    end
    return pressedButtons
end

function clearStickyButtons()
  for i = 1, numButtons do stickyButtons[i] = false end
end

-- ==================================================================

-- Any modifiers are applied first. All keys are applied before any are released
function pressKeyCombo(keys)
	for i = 1, #keys do
		PressKey(keys[i])
		Sleep(delay)
	end
	for i = 1, #keys do
		ReleaseKey(keys[i])
		Sleep(delay)
	end

end
