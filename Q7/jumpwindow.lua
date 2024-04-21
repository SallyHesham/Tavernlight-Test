--[[ Added this file (along with the other two) in a new folder(jumpwindow) in the client's mods folder ]]--

-- function called when loading module
function init()

    -- added toggle button to access the new window
    toggleButton = modules.client_topmenu.addRightToggleButton("jumpButton", tr("jump!"), '', toggle)
    toggleButton:setOn(false)

    -- this is the main window
    jumpWindow = g_ui.displayUI("jumpwindow")
    jumpWindow:hide()

    -- saving these references for later use
    windowWidth = jumpWindow:getWidth()
    windowWidth = windowWidth - 70 -- the 70 is an offset to prevent the button from going out of bounds
    windowHeight = jumpWindow:getHeight()
    windowHeight = windowHeight - 40 -- the same can be said for the 40
    jumpButton = jumpWindow:recursiveGetChildById("jumpButton")
    math.randomseed(os.time())

end

-- function called when unloading module
function terminate()

    -- remove any loops before unloading
    if (loop) then
        removeEvent(loop)
    end

    toggleButton:destroy()
    jumpWindow:destroy()

end

-- function called when pressing the toggle button
function toggle()

    if toggleButton:isOn() then
        -- close window
        jumpWindow:hide()
        toggleButton:setOn(false)
        -- remove loop when closing window
        if (loop) then
            removeEvent(loop)
        end

    else
        -- open window
        jumpWindow:show()
        toggleButton:setOn(true)
        jump() -- start immediatly when opening window
    end

end

-- this function causes the button to jump vertically
-- it is called when button is pressed, when going out of bounds, and when window opens
function jump()

    -- remove any existing loop
    if (loop) then
        removeEvent(loop)
    end

    -- set button on the right most side at a random height
    local pos = jumpWindow:getPosition()
    -- the random range starts with 30 so the button doesn't spawn on the top part of the window
    local newPos = { x = pos.x + windowWidth, y = pos.y + math.random(30, windowHeight)}
    jumpButton:setPosition(newPos)

    -- start the loop which moves the button horizontally
    loop = scheduleEvent(move, 100)

end

-- this function moves the button horizontally and is called periodically
function move()

    -- I get both the window and button positions to make sure button stays in bounds even if the window moves
    local buttonPos = jumpButton:getPosition()
    local windowPos = jumpWindow:getPosition()

    -- here I increment the button's horizontal position by 10
    local newButtonPos = { x = buttonPos.x - 10, y = buttonPos.y }

    -- if button will get out of bounds, stop loop and reposition button
    if newButtonPos.x < windowPos.x + 20 then -- this offset is also here to keep button in the window's frame
        return jump()
    else -- else move button
        jumpButton:setPosition(newButtonPos)
    end

    -- schedule the next iteration of the move loop 0.1s later
    loop = scheduleEvent(move, 100)

    --[[ for smoother movement decrease horizontal increment and decrease time between iterations.
        but I felt this combination was just right. ]]--

end

--[[ I know hard coding the offsets is bad practice, but with the time constraints, it'll have to do.
    I hope you don't mind :)  ]]--