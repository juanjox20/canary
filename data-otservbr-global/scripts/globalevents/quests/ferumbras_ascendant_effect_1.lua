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
	{ position = Position(2574, 2623, 7), text = "", effect = 73 },
}

local ferumbrasEffect1 = GlobalEvent("effect")
function ferumbrasEffect1.onThink(interval)
	for i = 1, #effects do
		local settings = effects[i]
		if settings.effect then
			settings.position:sendMagicEffect(settings.effect)
		end
	end
	return true
end

ferumbrasEffect1:interval(3000)
ferumbrasEffect1:register()
