configMining = {
	msg = {
		naoLocal = "Você não pode minerar aqui.",
		naoPick = "Você consegue minerar somente com pick.",
		minerouWin = "Você ganhou uma %s.",
		dano = "As pedras desabaram e você levou um hit.",
		fail = "Falha!",
		upNivel = "Você subiu de nível na mineração! Agora você é %s. Parabéns!",
		usarEspecial = true,
		especial = "[PREMIUM]",
	},
	level = {
		active = true,
		storageTentativas = 81056,
		storageNivel = 81057,
		[1] = {name = "Iniciante", qntMin = 0, qntMax = 50},
		[2] = {name = "Intermediário", qntMin = 51, qntMax = 399},
		[3] = {name = "Avançado", qntMin = 400, qntMax = 899},
		[4] = {name = "Experiente", qntMin = 1000},
	},
	itens = {
		{itemid = 16122, chancePickNormal = 0.05, chancePickEspecial = 0.10}, -- FACIL
		{itemid = 16123, chancePickNormal = 0.05, chancePickEspecial = 0.10}, -- FACIL
		{itemid = 16124, chancePickNormal = 0.05, chancePickEspecial = 0.10}, -- FACIL
		{itemid = 16124, chancePickNormal = 0.02, chancePickEspecial = 0.04}, -- MEDIO
		{itemid = 16125, chancePickNormal = 0.02, chancePickEspecial = 0.04}, -- MEDIO
		{itemid = 16126, chancePickNormal = 0.02, chancePickEspecial = 0.04}, -- MEDIO
		{itemid = 16127, chancePickNormal = 0.01, chancePickEspecial = 0.02}, -- DIFICIL
		{itemid = 16124, chancePickNormal = 0.01, chancePickEspecial = 0.02}, -- DIFICIL
		{itemid = 16124, chancePickNormal = 0.01, chancePickEspecial = 0.02}, -- DIFICIL
		{itemid = 16124, chancePickNormal = 0.01, chancePickEspecial = 0.04}, -- DIFICIL
		{itemid = 37317, chancePickNormal = 0.001, chancePickEspecial = 0.015, level = true, nivelMin = 4}, -- IMPOSSIVEL
	},
	hit = {
		active = true,
		danoMin = 300, 
		danoMax = 500, 
		chance = 0.10
	},
	idPick = 19249,
	idPickEspecial = 32711,
	actionIdPedras = 34561,
}