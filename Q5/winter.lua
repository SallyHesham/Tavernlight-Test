--[[ Added this file in the data/spells/scripts/custom folder server side ]]--

-- initializing random seed
math.randomseed(os.time())

-- custom spell area
--[[ umm, I can't put the three centered in the middle because the columns are even,
	and when I add a column the spell area gets too big and the effect isn't right. 
	Apart from that, it works as intended. ]]--
--[[ also, I could have put this in spells.lua but I thought here would be better
	since this isn't a standard spell area. ]]--
AREA_DIAMOND = {
	{0, 0, 0, 1, 1, 0, 0, 0},
	{0, 0, 1, 1, 1, 1, 0, 0},
	{0, 1, 1, 1, 1, 1, 1, 0},
	{1, 1, 1, 1, 3, 1, 1, 1},
	{0, 1, 1, 1, 1, 1, 1, 0},
	{0, 0, 1, 1, 1, 1, 0, 0},
	{0, 0, 0, 1, 1, 0, 0, 0}
}

--[[ The tornadoes appeared to be random, so I have created a function to randomly set 1 or 0
	according to the predefined area matrix. ]]--

local function createRandomArea()
	area = {}
    for i=1, #AREA_DIAMOND do
      area[i] = {}
      for j=1, #AREA_DIAMOND[i] do

		-- if there ia a 1, then choose randomly
		-- else keep the 0s and the 3 as is

		if AREA_DIAMOND[i][j] == 1 then
    		area[i][j] = math.random(0, 1)
		else
			area[i][j] = AREA_DIAMOND[i][j]
		end
      end
    end

	return area
end

--[[ The tornadoes appeared in waves, hence I've adjusted the code accordingly.
	The 4 is arbitrary though. ]]--

local combats = {}
for i=1, 4 do
	combats[i] = Combat()
	combats[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
	combats[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
	combats[i]:setArea(createCombatArea(createRandomArea()))

	-- this is from the eternal winter script since I have no idea what damage it's supposed to do
	function onGetFormulaValues(player, level, magicLevel)
		local min = (level / 5) + (magicLevel * 5.5) + 25
		local max = (level / 5) + (magicLevel * 11) + 50
		return -min, -max
	end

	combats[i]:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

end

-- created func to get creature by id and execute combat
-- this is because I get a warning in cmd at server start when I add event with creature directly (I need to use id)
local function executeCombat(i, cid, variant)
	local creature = Creature(cid)
	
	return combats[i]:execute(creature, variant)
end

function onCastSpell(creature, variant)
	-- execute the other waves after a delay
	for i=2, #combats do
		addEvent(executeCombat, 500 * (i-1), i, creature:getId(), variant)
	end
	-- execute the first now
	return combats[1]:execute(creature, variant)
end
