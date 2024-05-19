function onUpdateDatabase()
	logger.info("Updating database to version 44 (add cast to players)")
	db.query("ALTER TABLE `players` ADD `cast_viewers` tinyint(4) UNSIGNED NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `players` ADD `cast_description` varchar(255) NOT NULL DEFAULT '';")
	db.query("ALTER TABLE `players` ADD `cast_password` varchar(255) NOT NULL DEFAULT '';")
	db.query("ALTER TABLE `players` ADD `cast_status` tinyint(1) UNSIGNED NOT NULL DEFAULT '0';")
	return true
end