--Q2 - Fix or improve the implementation of the below method



function printSmallGuildNames(memberCount)

-- this method is supposed to print names of all guilds that have less than memberCount max members

    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"

    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

    -- added a repeat block in order to print all names
    repeat
        -- added the missing parameter resultId
        local guildName = result.getString(resultId, "name")

        print(guildName)

    until not result.next(resultId)

    -- added this because it seems right
    result.free(resultId)

end