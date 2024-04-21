--Q1 - Fix or improve the implementation of the below methods



local function releaseStorage(player)

    player:setStorageValue(1000, -1)

end

-- added getStorage function which returns the value of storage #1000
-- did this to follow previous set convention (the func above), and to make it easier to check or change storage number in the future
local function getStorage(player)

    return player:getStorageValue(1000)

end

function onLogout(player)

    if getStorage(player) == 1 then

        -- changed this to call function directly and not after a set amount of time
        releaseStorage(player)

    end

    -- the logic here is that aparently storage #1000 must be released for player to logout,
    -- but return true allows player to logout while the event may not have yet occured, possibly causing problems.
    return true

end