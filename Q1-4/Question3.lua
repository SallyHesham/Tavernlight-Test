--Q3 - Fix or improve the name and the implementation of the below method



-- seems like an appropriate name
function removeMemberFromPlayerParty(playerId, membername)

    player = Player(playerId)

    -- added a check just in case
    if not player then
        return
    end

    -- saved refrence to the member neeeded to be removed, to prevent doing this multiple times later
    unwantedMember = Player(membername)

    local party = player:getParty()

    -- renamed variables for clarity
    for i, member in pairs(party : getMembers()) do

        if member == unwantedMember then

            party : removeMember(unwantedMember)
            -- I assume calling removeMember() for a member not in player party will cause problems
            -- otherwise this whole block is meaningless
        end

    end

end