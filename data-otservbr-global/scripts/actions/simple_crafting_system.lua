local config = {
-- Window Config
	mainTitleMsg = "Crafting System", -- Main window title
	mainMsg = "Welcome to the crafting system. Please choose a vocation to begin.", -- Main window message
 
	craftTitle = "Crafting System: ", -- Title of the crafting screen after player picks of vocation
	craftMsg = "Here is a list of all items that can be crafted for the ", -- Message on the crafting screen after player picks of vocation
-- End Window Config
 
-- Player Notifications Config
	needItems = "You do not have all the required items to make ", -- This is the message the player recieves if he does not have all required items
 
-- Crafting Config
	system = {
	[1] = {vocation = "Master Sorcerer", -- This is the category can be anything.
			items = {
				[1] = {item = "Shadow Sceptre", -- item name (THIS MUST BE EXACT OR IT WILL NOT WORK!)
						itemID = 7451, -- item to be made
						reqItems = { -- items and the amounts in order to craft.
								[1] = {item = 22516, count = 50}, -- Silver Tokens
								[2] = {item = 9056, count = 1}, -- Black Skull
								[3] = {item = 5904, count = 30}, -- Magic Sulphur
								[4] = {item = 9237, count = 1}, -- Shadow Orb
								[5] = {item = 20062, count = 50}, -- Cluster of Solace
							},
						},
 
				[2] = {item = "Knowledgeable Book",
						itemID = 27934,
						reqItems = {
								[1] = {item = 22516, count = 30}, -- Silver Tokens
								[2] = {item = 8090, count = 1}, -- Spellbook of Dark mysteries
								[3] = {item = 20207, count = 5}, -- pool of chitinous glue
								[4] = {item = 9646, count = 20}, -- book of prayers
								[5] = {item = 10320, count = 20}, -- book of necromantic rituals
							},
						},
 
				[3] = {item = "Witch Hat",
						itemID = 39151,
						reqItems = {
								[1] = {item = 22516, count = 30}, -- Silver Tokens
								[2] = {item = 9653, count = 1}, -- Witch  Hat
								[3] = {item = 3014, count = 1}, -- Star Amulet
								[4] = {item = 5910, count = 100}, -- Green Piece of cloth
						},
					},
 
				[4] = {item = "Ethno Coat",
						itemID = 8064,
						reqItems = {
								[1] = {item = 22516, count = 40}, -- Silver Tokens
								[2] = {item = 19391, count = 1}, -- Furious frock
								[3] = {item = 3008, count = 1}, -- Crystal Necklace
								[4] = {item = 8762, count = 1}, -- Piece of royal satin
								[5] = {item = 16126, count = 30}, -- red crystal fragment
						},
					},
 
				[5] = {item = "Demon Legs",
						itemID = 3389,
						reqItems = {
								[1] = {item = 22516, count = 25}, -- Silver Tokens
								[2] = {item = 821, count = 1}, -- Magma legs
								[3] = {item = 3039, count = 1}, -- Red gem
								[4] = {item = 9636, count = 20}, -- Fiery Heart
						},
					},
 
				[6] = {item = "Makeshift Boots",
						itemID = 35519,
						reqItems = {
								[1] = {item = 22516, count = 25}, -- Silver Tokens
								[2] = {item = 818, count = 1}, -- Magma Boots
								[3] = {item = 12600, count = 20}, -- Coal
								[4] = {item = 16126, count = 20}, -- red crystal fragments
						},
					},
				},
			},
 
	[2] = {vocation= "Elder Druid", 
			items = {
				[1] = {item = "Rod of Destruction",
						itemID = 27458,
						reqItems = {
								[1] = {item = 22516, count = 50}, -- Silver Tokens
								[2] = {item = 5944, count = 20}, -- Soul orb
								[3] = {item = 5904, count = 30}, -- Magic Sulphur
								[4] = {item = 7387, count = 1}, -- Diamond Sceptre
								[5] = {item = 20062, count = 50}, -- Cluster of Solace
						},
					},
 
				[2] = {item = "Knowledgeable Book",
						itemID = 27934,
						reqItems = {
								[1] = {item = 22516, count = 30}, -- Silver Tokens
								[2] = {item = 3573, count = 1}, -- Magician Hat
								[3] = {item = 3014, count = 1}, -- Star Amulet
								[4] = {item = 5912, count = 100}, -- Blue piece of cloth
						},
					},
 
				[3] = {item = "Frostmind Raiment",
						itemID = 22537,
						reqItems = {
								[1] = {item = 22516, count = 40}, -- Silver Tokens
								[2] = {item = 19391, count = 1}, -- Furious frock
								[3] = {item = 7290, count = 10}, -- Shard
								[4] = {item = 16124, count = 30}, -- Blue crystal splinter
						},
					},
 
				[4] = {item = "Lightning Legs",
						itemID = 822,
						reqItems = {
								[1] = {item = 22516, count = 25}, -- Silver Tokens
								[2] = {item = 645, count = 1}, -- Blue legs
								[3] = {item = 9661, count = 20}, -- frosty heart
								[4] = {item = 3038, count = 1}, -- Green gem
						},
					},
 
				[5] = {item = "Steel Boots",
						itemID = 3554,
						reqItems = {
								[1] = {item = 22516, count = 25}, -- Silver Tokens
								[2] = {item = 819, count = 1}, -- Glacier Shoes
								[3] = {item = 9661, count = 20}, -- frosty heart
								[4] = {item = 16119, count = 20}, -- Blue crystal shard
						},
					},
				},
			},
 
		[3] = {vocation = "Royal Paladin", 
				items = {
					[1] = {item = "Rift Crossbow",
							itemID = 22867,
							reqItems = {
								[1] = {item = 22516, count = 60}, -- Silver Tokens
								[2] = {item = 3349, count = 1}, -- Crossbow
								[3] = {item = 5904, count = 30}, -- Magic Sulphur
								[4] = {item = 16133, count = 20}, -- Pulverized Ore
								[5] = {item = 20062, count = 50}, -- Cluster of Solace
							},
						},
 
					[2] = {item = "Zaoan Helmet",
							itemID = 10385,
							reqItems = {
								[1] = {item = 22516, count = 35}, -- Silver Tokens
								[2] = {item = 5880, count = 100}, -- Iron Ore
								[3] = {item = 5954, count = 30}, -- Demon Horn
								[4] = {item = 3391, count = 1}, -- Crusader Helmet
							},
						},
 
					[3] = {item = "Frostsoul Tabard",
							itemID = 8057,
							reqItems = {
								[1] = {item = 22516, count = 40}, -- Silver Tokens
								[2] = {item = 5912, count = 100}, -- Blue Cloth
								[3] = {item = 5954, count = 1}, -- Demon Horn
							},
						},
 
					[4] = {item = "Prismatic Legs",
							itemID = 16111,
							reqItems = {
								[1] = {item = 22516, count = 35}, -- Silver Tokens
								[2] = {item = 3398, count = 1}, -- Dwarven Legs
								[3] = {item = 5809, count = 1}, -- Soul Stone
								[4] = {item = 5905, count = 30}, -- Vampire Dust
							},
						},
 
					[5] = {item = "Guardian Boots",
							itemID = 10323,
							reqItems = {
								[1] = {item = 22516, count = 30}, -- Silver Tokens
								[2] = {item = 20205, count = 20}, -- Goosebump Leather
								[3] = {item = 3554, count = 1}, -- Steel Boots
							},
						},
					},
				},
 
		[4] = {vocation = "Elite Knight",
				items = {
					[1] = {item = "Mystic Blade",
							itemID = 34082,
							reqItems = {
								[1] = {item = 22516, count = 50}, -- Silver Tokens
								[2] = {item = 3264, count = 1}, -- Sword
								[3] = {item = 5887, count = 20}, -- Piece of royal steel
								[4] = {item = 16133, count = 20}, -- Pulverized ore
								[5] = {item = 20062, count = 50}, -- Cluster of Solace
							},
						},
 
					[2] = {item = "Falcon Escutcheon",
							itemID = 28722,
							reqItems = {
								[1] = {item = 22516, count = 30}, -- Silver Tokens
								[2] = {item = 3433, count = 1}, -- Griffin Shield
								[3] = {item = 5889, count = 20}, -- piece of draconian steel
							},
						},
 
					[3] = {item = "Terra Helmet",
							itemID = 31557,
							reqItems = {
								[1] = {item = 22516, count = 30}, -- Silver Tokens
								[2] = {item = 3392, count = 1}, -- Royal helmet
								[3] = {item = 5880, count = 100}, -- Iron ore
								[4] = {item = 10310, count = 30}, -- Shiny Stone
							},
						},
 
					[4] = {item = "Crystalline Armor",
							itemID = 8050,
							reqItems = {
								[1] = {item = 22516, count = 40}, -- Silver Tokens
								[2] = {item = 3567, count = 1}, -- Blue Robe
								[3] = {item = 5912, count = 100}, -- Blue piece of cloth
							},
						},
 
					[5] = {item = "Ornate Legs",
							itemID = 13999,
							reqItems = {
								[1] = {item = 22516, count = 25}, -- Silver Tokens
								[2] = {item = 3398, count = 1}, -- Dwarven legs
								[3] = {item = 5809, count = 1}, -- Soul stone
								[4] = {item = 5526, count = 20}, -- Demon dust
							},
						},	
 
 
					[6] = {item = "Pair of Soulwalkers",
							itemID = 34097,
							reqItems = {
								[1] = {item = 22516, count = 25}, -- Silver Tokens
								[2] = {item = 3079, count = 1}, -- Boots of haste
								[3] = {item = 5888, count = 30}, -- piece of hell steel
							},
						},
					},
				},
			},
		}
 
local simpleCraftingSystem = Action()
function simpleCraftingSystem.onUse(player, item, fromPosition, itemEx, toPosition, isHotkey)
    player:sendMainCraftWindow(config)
    return true
end

simpleCraftingSystem:id(36810)
simpleCraftingSystem:register()