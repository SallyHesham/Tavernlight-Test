--[[ Added this file in the data/spells/scripts/custom folder server side ]]--

local dashStep = 1
local dashDist = 5
local dashInterval = 25
local unwanted_tilestates = { TILESTATE_HOUSE, TILESTATE_FLOORCHANGE, TILESTATE_TELEPORT, TILESTATE_BLOCKSOLID, TILESTATE_BLOCKPATH }

function onCastSpell(creature, variant)

	-- created a series of teleport events to act like dash movement
	for i=1, dashDist do
		addEvent(teleport, dashInterval * i, creature:getId())
	end
	-- execute the first now
	return teleport(creature:getId(), variant)
end

function teleport(playerId)

	-- get next position
	player = Player(playerId)
	local newPos = player:getPosition()
	newPos:getNextPosition(player:getDirection(), dashStep)

	-- check if out of bounds
	local tile = newPos and Tile(newPos)
    if not tile then
        return
    end

	-- here I check for obstacles and exit if there are any
    for _, tilestate in pairs(unwanted_tilestates) do
        if tile:hasFlag(tilestate) then
            return
        end
    end

	-- move player
	player:teleportTo(newPos)
	newPos:sendMagicEffect(CONST_ME_POFF)
end

--[[ And yeah, shaders are hard. I tried but there wasn't enough time to figure out shaders from the top ]]--