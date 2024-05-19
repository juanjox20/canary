local effects = {
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
}

local ferumbrasEffect2 = GlobalEvent("effcts")
function ferumbrasEffect2.onThink(interval)
	for i = 1, #effects do
		local settings = effects[i]
		if settings.effect then
			settings.position:sendMagicEffect(settings.effect)
		end
	end
	return true
end

ferumbrasEffect2:interval(4000)
ferumbrasEffect2:register()
