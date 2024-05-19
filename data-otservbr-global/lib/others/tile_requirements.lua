tileRequerimentsConfig = {
    ---------------------------------------------------------
   -- Tile Requeriment example 1
   ---------------------------------------------------------
   [37000] = {
       minLevel = 500, -- level req to enter
       maxLevel = 9999, -- set 0 to disable (set level max to enter)
       storageReq = 37000, -- set 0 to disable (if player need storage to enter)
       storageName = "", -- if you want show quest need to enter (example: you need >demon quest< to join this area)
       zoneName = "primary quest", -- name of your zone or use default
       teleport = Position(45, 25, 7) -- if you want teleport player put 0 to disable
    
       },
     ---------------------------------------------------------
   -- Example Tiles
   ---------------------------------------------------------
   [37001] = {
       minLevel = 1000, -- level req to enter
       maxLevel = 9999, -- set 0 to disable (set level max to enter)
       storageReq = 37001, -- set 0 to disable (if player need storage to enter)
       storageName = "Quest Retro", -- if you want show quest need to enter (example: you need >demon quest< to join this area)
       zoneName = "second quest", -- name of your zone or use default
       teleport = Position(2498, 2499, 7) -- if you want teleport player put 0 to disable
       },

    [37002] = {
       minLevel = 1500, -- level req to enter
       maxLevel = 9999, -- set 0 to disable (set level max to enter)
       storageReq = 37002, -- set 0 to disable (if player need storage to enter)
       storageName = "", -- if you want show quest need to enter (example: you need >demon quest< to join this area)
       zoneName = "third quest", -- name of your zone or use default
       teleport = Position(2498, 2499, 7) -- if you want teleport player put 0 to disable
       }
 
 
}