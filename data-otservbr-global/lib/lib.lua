-- Core API functions implemented in Lua
dofile(DATA_DIRECTORY .. "/lib/core/load.lua")

-- Others library
dofile(DATA_DIRECTORY .. "/lib/others/load.lua")

-- Quests library
dofile(DATA_DIRECTORY .. "/lib/quests/quest.lua")

-- Tables library
dofile(DATA_DIRECTORY .. "/lib/tables/load.lua")
dofile(DATA_DIRECTORY .. "/lib/tables/karin_lib.lua")

dofile(DATA_DIRECTORY.. '/lib/others/tile_requirements.lua')

-- Tasks Library
dofile(DATA_DIRECTORY .. "/lib/others/task_lib.lua")

-- Mining
dofile(DATA_DIRECTORY.. '/lib/custom/mining.lua')

-- Quests library
dofile(DATA_DIRECTORY .. '/lib/custom/simple_crafting_system.lua')

-- Addon Doll library
dofile(DATA_DIRECTORY .. '/lib/others/addon_doll_lib.lua')

-- Mount Doll library
dofile(DATA_DIRECTORY .. '/lib/others/mount_doll_lib.lua')


