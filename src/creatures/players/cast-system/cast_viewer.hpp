#pragma once

#include "lua/functions/core/game/lua_enums.hpp"
#include "pch.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/achievement/player_achievement.hpp"

class Creature;
class Player;
class Container;
class Tile;
class Item;
class Position;
class Party;
class Npc;
class ProtocolGame;

struct Achievement;

using CastViewersList = std::map<ProtocolGame_ptr, std::pair<std::string, uint32_t>>;
using DataCastList = std::map<std::string, uint32_t>;

class CastViewer {
public:
	CastViewer(ProtocolGame_ptr client) :
		owner(client) {
		id = 0;
		cast_broadcast = false;
		cast_broadcast_time = 0;
		cast_live_record = 0;
		cast_description = "";
	}
	virtual ~CastViewer() { }

	void clear(bool full) {
		for (const auto &it : viewers) {
			it.first->disconnect();
		}

		viewers.clear();
		mutes.clear();
		removeCaster();

		id = 0;
		if (!full) {
			return;
		}

		bans.clear();
		cast_password = "";
		cast_broadcast = false;
		cast_broadcast_time = 0;
		cast_live_record = 0;
	}

	bool checkPassword(const std::string &_password);
	void handle(ProtocolGame_ptr client, const std::string &text, uint16_t channelId);
	void chat(uint16_t channelId);

	uint32_t getCastViewerCount() {
		return viewers.size();
	}

	StringVector listViewers() {
		StringVector list_;
		for (const auto &it : viewers) {
			list_.push_back(it.second.first);
		}
		return list_;
	}

	void kickViewer(StringVector list);
	StringVector muteCastList() {
		return mutes;
	}

	void muteViewer(StringVector _mutes) {
		mutes = _mutes;
	}

	DataCastList banCastList() {
		return bans;
	}

	void banViewer(StringVector _bans);

	bool checkBannedIP(uint32_t ip) const {
		for (const auto &it : bans) {
			if (it.second == ip) {
				return true;
			}
		}

		return false;
	}

	ProtocolGame_ptr getCastOwner() const {
		return owner;
	}

	void setCastOwner(ProtocolGame_ptr client) {
		owner = client;
	}

	void resetCastOwner() {
		owner.reset();
	}

	std::string getCastPassword() const {
		return cast_password;
	}

	void setCastPassword(const std::string &value) {
		cast_password = value;
	}

	bool isCastBroadcasting() const {
		return cast_broadcast;
	}

	void setCastBroadcast(bool value) {
		cast_broadcast = value;
	}

	std::string getCastBroadcastTimeString() const {
		std::stringstream broadcast_message;
		int64_t seconds = getCastBroadcastTime() / 1000;
		uint16_t hour = floor(seconds / 60 / 60 % 24);
		uint16_t minute = floor(seconds / 60 % 60);
		uint16_t second = floor(seconds % 60);

		if (hour > 0) {
			broadcast_message << hour << " hours, ";
		}
		if (minute > 0) {
			broadcast_message << minute << " minutes and ";
		}
		broadcast_message << second << " seconds.";
		return broadcast_message.str();
	}

	void addViewer(ProtocolGame_ptr client, std::string name = "", bool spy = false);
	void removeViewer(ProtocolGame_ptr client, bool spy = false);

	int64_t getCastBroadcastTime() const {
		return OTSYS_TIME() - cast_broadcast_time;
	}

	void setCastBroadcastTime(int64_t time) {
		cast_broadcast_time = time;
	}

	std::string getCastDescription() const {
		return cast_description;
	}

	void setCastDescription(const std::string &desc) {
		cast_description = desc;
	}

	uint32_t getViewerId(ProtocolGame_ptr client) const {
		auto it = viewers.find(client);
		if (it != viewers.end()) {
			return it->second.second;
		}
		return 0;
	}

	// inherited
	void insertCaster() {
		if (owner) {
			owner->insertCaster();
		}
	}

	void removeCaster() {
		if (owner) {
			owner->removeCaster();
		}
	}

	bool canSee(const Position &pos) const {
		if (owner) {
			return owner->canSee(pos);
		}

		return false;
	}

	uint32_t getIP() const {
		if (owner) {
			return owner->getIP();
		}

		return 0;
	}

	void sendStats() {
		if (owner) {
			owner->sendStats();

			for (const auto &it : viewers) {
				it.first->sendStats();
			}
		}
	}

	void sendPing() {
		if (owner) {
			owner->sendPing();

			for (const auto &it : viewers) {
				it.first->sendPing();
			}
		}
	}

	void logout(bool displayEffect, bool forceLogout) {
		if (owner) {
			owner->logout(displayEffect, forceLogout);
		}
	}

	void sendAddContainerItem(uint8_t cid, uint16_t slot, std::shared_ptr<Item> item) {
		if (owner) {
			owner->sendAddContainerItem(cid, slot, item);

			for (const auto &it : viewers) {
				it.first->sendAddContainerItem(cid, slot, item);
			}
		}
	}

	void sendUpdateContainerItem(uint8_t cid, uint16_t slot, std::shared_ptr<Item> item) {
		if (owner) {
			owner->sendUpdateContainerItem(cid, slot, item);

			for (const auto &it : viewers) {
				it.first->sendUpdateContainerItem(cid, slot, item);
			}
		}
	}

	void sendRemoveContainerItem(uint8_t cid, uint16_t slot, std::shared_ptr<Item> lastItem) {
		if (owner) {
			owner->sendRemoveContainerItem(cid, slot, lastItem);

			for (const auto &it : viewers) {
				it.first->sendRemoveContainerItem(cid, slot, lastItem);
			}
		}
	}

	void sendUpdatedVIPStatus(uint32_t guid, VipStatus_t newStatus) {
		if (owner) {
			owner->sendUpdatedVIPStatus(guid, newStatus);

			for (const auto &it : viewers) {
				it.first->sendUpdatedVIPStatus(guid, newStatus);
			}
		}
	}

	void sendVIP(uint32_t guid, const std::string &name, const std::string &description, uint32_t icon, bool notify, VipStatus_t status) {
		if (owner) {
			owner->sendVIP(guid, name, description, icon, notify, status);

			for (const auto &it : viewers) {
				it.first->sendVIP(guid, name, description, icon, notify, status);
			}
		}
	}

	void sendClosePrivate(uint16_t channelId) {
		if (owner) {
			owner->sendClosePrivate(channelId);
		}
	}

	void sendFYIBox(const std::string &message) {
		if (owner) {
			owner->sendFYIBox(message);
		}
	}

	uint32_t getVersion() const {
		if (owner) {
			return owner->getVersion();
		}

		return 0;
	}

	void disconnect() {
		if (owner) {
			owner->disconnect();
		}
	}

	void sendCreatureSkull(std::shared_ptr<Creature> creature) const {
		if (owner) {
			owner->sendCreatureSkull(creature);

			for (const auto &it : viewers) {
				it.first->sendCreatureSkull(creature);
			}
		}
	}

	void sendAddTileItem(const Position &pos, uint32_t stackpos, std::shared_ptr<Item> item) {
		if (owner) {
			owner->sendAddTileItem(pos, stackpos, item);

			for (const auto &it : viewers) {
				it.first->sendAddTileItem(pos, stackpos, item);
			}
		}
	}

	void sendUpdateTileItem(const Position &pos, uint32_t stackpos, std::shared_ptr<Item> item) {
		if (owner) {
			owner->sendUpdateTileItem(pos, stackpos, item);

			for (const auto &it : viewers) {
				it.first->sendUpdateTileItem(pos, stackpos, item);
			}
		}
	}

	void sendRemoveTileThing(const Position &pos, int32_t stackpos) {
		if (owner) {
			owner->sendRemoveTileThing(pos, stackpos);

			for (const auto &it : viewers) {
				it.first->sendRemoveTileThing(pos, stackpos);
			}
		}
	}

	void sendUpdateTile(std::shared_ptr<Tile> tile, const Position &pos) {
		if (owner) {
			owner->sendUpdateTile(tile, pos);

			for (const auto &it : viewers) {
				it.first->sendUpdateTile(tile, pos);
			}
		}
	}

	void sendChannelMessage(const std::string &author, const std::string &text, SpeakClasses type, uint16_t channel) {
		if (owner) {
			owner->sendChannelMessage(author, text, type, channel);

			for (const auto &it : viewers) {
				it.first->sendChannelMessage(author, text, type, channel);
			}
		}
	}

	void sendMoveCreature(std::shared_ptr<Creature> creature, const Position &newPos, int32_t newStackPos, const Position &oldPos, int32_t oldStackPos, bool teleport) {
		if (owner) {
			owner->sendMoveCreature(creature, newPos, newStackPos, oldPos, oldStackPos, teleport);

			for (const auto &it : viewers) {
				it.first->sendMoveCreature(creature, newPos, newStackPos, oldPos, oldStackPos, teleport);
			}
		}
	}

	void sendCreatureTurn(std::shared_ptr<Creature> creature, int32_t stackpos) {
		if (owner) {
			owner->sendCreatureTurn(creature, stackpos);

			for (const auto &it : viewers) {
				it.first->sendCreatureTurn(creature, stackpos);
			}
		}
	}

	void sendForgeResult(ForgeAction_t actionType, uint16_t leftItemId, uint8_t leftTier, uint16_t rightItemId, uint8_t rightTier, bool success, uint8_t bonus, uint8_t coreCount, bool convergence) const {
		if (owner) {
			owner->sendForgeResult(actionType, leftItemId, leftTier, rightItemId, rightTier, success, bonus, coreCount, convergence);
		}
	}

	void sendPrivateMessage(std::shared_ptr<Player> speaker, SpeakClasses type, const std::string &text) {
		if (owner) {
			owner->sendPrivateMessage(speaker, type, text);
		}
	}

	void sendCreatureSquare(std::shared_ptr<Creature> creature, SquareColor_t color) {
		if (owner) {
			owner->sendCreatureSquare(creature, color);

			for (const auto &it : viewers) {
				it.first->sendCreatureSquare(creature, color);
			}
		}
	}

	void sendCreatureOutfit(std::shared_ptr<Creature> creature, const Outfit_t &outfit) {
		if (owner) {
			owner->sendCreatureOutfit(creature, outfit);

			for (const auto &it : viewers) {
				it.first->sendCreatureOutfit(creature, outfit);
			}
		}
	}

	void sendCreatureLight(std::shared_ptr<Creature> creature) {
		if (owner) {
			owner->sendCreatureLight(creature);

			for (const auto &it : viewers) {
				it.first->sendCreatureLight(creature);
			}
		}
	}

	void sendCreatureWalkthrough(std::shared_ptr<Creature> creature, bool walkthrough) {
		if (owner) {
			owner->sendCreatureWalkthrough(creature, walkthrough);

			for (const auto &it : viewers) {
				it.first->sendCreatureWalkthrough(creature, walkthrough);
			}
		}
	}

	void sendCreatureShield(std::shared_ptr<Creature> creature) {
		if (owner) {
			owner->sendCreatureShield(creature);

			for (const auto &it : viewers) {
				it.first->sendCreatureShield(creature);
			}
		}
	}

	void sendContainer(uint8_t cid, std::shared_ptr<Container> container, bool hasParent, uint16_t firstIndex) {
		if (owner) {
			owner->sendContainer(cid, container, hasParent, firstIndex);

			for (const auto &it : viewers) {
				it.first->sendContainer(cid, container, hasParent, firstIndex);
			}
		}
	}

	void sendInventoryItem(Slots_t slot, std::shared_ptr<Item> item) {
		if (owner) {
			owner->sendInventoryItem(slot, item);

			for (const auto &it : viewers) {
				it.first->sendInventoryItem(slot, item);
			}
		}
	}

	void sendCancelMessage(const std::string &msg) const {
		if (owner) {
			owner->sendTextMessage(TextMessage(MESSAGE_FAILURE, msg));

			for (const auto &it : viewers) {
				it.first->sendTextMessage(TextMessage(MESSAGE_FAILURE, msg));
			}
		}
	}

	void sendCancelTarget() const {
		if (owner) {
			owner->sendCancelTarget();

			for (const auto &it : viewers) {
				it.first->sendCancelTarget();
			}
		}
	}

	void sendCancelWalk() const {
		if (owner) {
			owner->sendCancelWalk();

			for (const auto &it : viewers) {
				it.first->sendCancelWalk();
			}
		}
	}

	void sendChangeSpeed(std::shared_ptr<Creature> creature, uint32_t newSpeed) const {
		if (owner) {
			owner->sendChangeSpeed(creature, newSpeed);

			for (const auto &it : viewers) {
				it.first->sendChangeSpeed(creature, newSpeed);
			}
		}
	}

	void sendCreatureHealth(std::shared_ptr<Creature> creature) const {
		if (owner) {
			owner->sendCreatureHealth(creature);

			for (const auto &it : viewers) {
				it.first->sendCreatureHealth(creature);
			}
		}
	}

	void sendDistanceShoot(const Position &from, const Position &to, unsigned char type) const {
		if (owner) {
			owner->sendDistanceShoot(from, to, type);

			for (const auto &it : viewers) {
				it.first->sendDistanceShoot(from, to, type);
			}
		}
	}

	void sendCreatePrivateChannel(uint16_t channelId, const std::string &channelName) {
		if (owner) {
			owner->sendCreatePrivateChannel(channelId, channelName);
		}
	}

	void sendIcons(uint32_t icons) const {
		if (owner) {
			owner->sendIcons(icons);

			for (const auto &it : viewers) {
				it.first->sendIcons(icons);
			}
		}
	}

	void sendMagicEffect(const Position &pos, uint8_t type) const {
		if (owner) {
			owner->sendMagicEffect(pos, type);

			for (const auto &it : viewers) {
				it.first->sendMagicEffect(pos, type);
			}
		}
	}

	void sendSkills() const {
		if (owner) {
			owner->sendSkills();

			for (const auto &it : viewers) {
				it.first->sendSkills();
			}
		}
	}

	void sendTextMessage(MessageClasses mclass, const std::string &message) {
		if (owner) {
			owner->sendTextMessage(TextMessage(mclass, message));

			for (const auto &it : viewers) {
				it.first->sendTextMessage(TextMessage(mclass, message));
			}
		}
	}

	void sendTextMessage(const TextMessage &message) const {
		if (owner) {
			owner->sendTextMessage(message);

			for (const auto &it : viewers) {
				it.first->sendTextMessage(message);
			}
		}
	}

	void sendReLoginWindow(uint8_t unfairFightReduction) {
		if (owner) {
			owner->sendReLoginWindow(unfairFightReduction);
		}
	}

	void sendTextWindow(uint32_t windowTextId, std::shared_ptr<Item> item, uint16_t maxlen, bool canWrite) const {
		if (owner) {
			owner->sendTextWindow(windowTextId, item, maxlen, canWrite);
		}
	}

	void sendTextWindow(uint32_t windowTextId, uint32_t itemId, const std::string &text) const {
		if (owner) {
			owner->sendTextWindow(windowTextId, itemId, text);
		}
	}

	void sendToChannel(std::shared_ptr<Creature> creature, SpeakClasses type, const std::string &text, uint16_t channelId) {
		if (owner) {
			owner->sendToChannel(creature, type, text, channelId);
			for (const auto &it : viewers) {
				it.first->sendToChannel(creature, type, text, channelId);
			}
		}
	}

	void sendShop(std::shared_ptr<Npc> npc) const {
		if (owner) {
			owner->sendShop(npc);
		}
	}

	void sendSaleItemList(const std::vector<ShopBlock> &shopVector, const std::map<uint16_t, uint16_t> &inventoryMap) {
		if (owner) {
			owner->sendSaleItemList(shopVector, inventoryMap);
		}
	}

	void sendCloseShop() const {
		if (owner) {
			owner->sendCloseShop();
		}
	}

	void sendTradeItemRequest(const std::string &traderName, std::shared_ptr<Item> item, bool ack) const {
		if (owner) {
			owner->sendTradeItemRequest(traderName, item, ack);
		}
	}

	void sendTradeClose() const {
		if (owner) {
			owner->sendCloseTrade();
		}
	}

	void sendWorldLight(const LightInfo &lightInfo) {
		if (owner) {
			owner->sendWorldLight(lightInfo);

			for (const auto &it : viewers) {
				it.first->sendWorldLight(lightInfo);
			}
		}
	}

	void sendChannelsDialog() {
		if (owner) {
			owner->sendChannelsDialog();
		}
	}

	void sendOpenPrivateChannel(const std::string &receiver) {
		if (owner) {
			owner->sendOpenPrivateChannel(receiver);
		}
	}

	void sendOutfitWindow() {
		if (owner) {
			owner->sendOutfitWindow();
		}
	}

	void sendCloseContainer(uint8_t cid) {
		if (owner) {
			owner->sendCloseContainer(cid);

			for (const auto &it : viewers) {
				it.first->sendCloseContainer(cid);
			}
		}
	}

	void sendChannel(uint16_t channelId, const std::string &channelName, const UsersMap* channelUsers, const InvitedMap* invitedUsers) {
		if (owner) {
			owner->sendChannel(channelId, channelName, channelUsers, invitedUsers);
		}
	}

	void sendTutorial(uint8_t tutorialId) {
		if (owner) {
			owner->sendTutorial(tutorialId);
		}
	}

	void sendAddMarker(const Position &pos, uint8_t markType, const std::string &desc) {
		if (owner) {
			owner->sendAddMarker(pos, markType, desc);
		}
	}

	void sendFightModes() {
		if (owner) {
			owner->sendFightModes();
		}
	}

	void writeToOutputBuffer(const NetworkMessage &message) {
		if (owner) {
			owner->writeToOutputBuffer(message);

			for (const auto &it : viewers) {
				it.first->writeToOutputBuffer(message);
			}
		}
	}

	void sendAddCreature(std::shared_ptr<Creature> creature, const Position &pos, int32_t stackpos, bool isLogin) {
		if (owner) {
			owner->sendAddCreature(creature, pos, stackpos, isLogin);

			for (const auto &it : viewers) {
				it.first->sendAddCreature(creature, pos, stackpos, isLogin);
			}
		}
	}

	void sendHouseWindow(uint32_t windowTextId, const std::string &text) {
		if (owner) {
			owner->sendHouseWindow(windowTextId, text);
		}
	}

	void sendCloseTrade() const {
		if (owner) {
			owner->sendCloseTrade();
		}
	}

	void BestiarysendCharms() {
		if (owner) {
			owner->BestiarysendCharms();
		}
	}

	void sendImbuementResult(const std::string message) {
		if (owner) {
			owner->sendImbuementResult(message);
		}
	}

	void closeImbuementWindow() {
		if (owner) {
			owner->closeImbuementWindow();
		}
	}

	void sendPodiumWindow(std::shared_ptr<Item> podium, const Position &position, uint16_t itemId, uint8_t stackpos) {
		if (owner) {
			owner->sendPodiumWindow(podium, position, itemId, stackpos);
		}
	}

	void sendCreatureIcon(std::shared_ptr<Creature> creature) {
		if (owner && !owner->oldProtocol) {
			owner->sendCreatureIcon(creature);
		}
	}

	void sendUpdateCreature(std::shared_ptr<Creature> creature) {
		if (owner) {
			owner->sendUpdateCreature(creature);
		}
	}

	void sendCreatureType(std::shared_ptr<Creature> creature, uint8_t creatureType) {
		if (owner) {
			owner->sendCreatureType(creature, creatureType);
		}
	}

	void sendSpellCooldown(uint16_t spellId, uint32_t time) {
		if (owner) {
			owner->sendSpellCooldown(spellId, time);
		}
	}

	void sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time) {
		if (owner) {
			owner->sendSpellGroupCooldown(groupId, time);
		}
	}

	void sendUseItemCooldown(uint32_t time) {
		if (owner) {
			owner->sendUseItemCooldown(time);
		}
	}

	void reloadCreature(std::shared_ptr<Creature> creature) {
		if (owner) {
			owner->reloadCreature(creature);
		}
	}

	void sendBestiaryEntryChanged(uint16_t raceid) {
		if (owner) {
			owner->sendBestiaryEntryChanged(raceid);
		}
	}

	void refreshCyclopediaMonsterTracker(const std::unordered_set<std::shared_ptr<MonsterType>> &trackerList, bool isBoss) const {
		if (owner) {
			owner->refreshCyclopediaMonsterTracker(trackerList, isBoss);
		}
	}

	void sendClientCheck() {
		if (owner) {
			owner->sendClientCheck();
		}
	}

	void sendGameNews() {
		if (owner) {
			owner->sendGameNews();
		}
	}

	void removeMagicEffect(const Position &pos, uint16_t type) {
		if (owner) {
			owner->removeMagicEffect(pos, type);
		}
	}

	void sendPingBack() {
		if (owner) {
			owner->sendPingBack();

			for (const auto &it : viewers) {
				it.first->sendPingBack();
			}
		}
	}

	void sendBasicData() {
		if (owner) {
			owner->sendBasicData();
		}
	}

	void sendBlessStatus() {
		if (owner) {
			owner->sendBlessStatus();
		}
	}

	void updatePartyTrackerAnalyzer(const std::shared_ptr<Party> party) {
		if (owner && party) {
			owner->updatePartyTrackerAnalyzer(party);
		}
	}

	void createLeaderTeamFinder(NetworkMessage &msg) {
		if (owner) {
			owner->createLeaderTeamFinder(msg);
		}
	}

	void sendLeaderTeamFinder(bool reset) {
		if (owner) {
			owner->sendLeaderTeamFinder(reset);
		}
	}

	void sendTeamFinderList() {
		if (owner) {
			owner->sendTeamFinderList();
		}
	}

	void sendCreatureHelpers(uint32_t creatureId, uint16_t helpers) {
		if (owner) {
			owner->sendCreatureHelpers(creatureId, helpers);
		}
	}

	void sendChannelEvent(uint16_t channelId, const std::string &playerName, ChannelEvent_t channelEvent) {
		if (owner) {
			owner->sendChannelEvent(channelId, playerName, channelEvent);
		}
	}

	void sendDepotItems(const ItemsTierCountList &itemMap, uint16_t count) {
		if (owner) {
			owner->sendDepotItems(itemMap, count);
		}
	}

	void sendCloseDepotSearch() {
		if (owner) {
			owner->sendCloseDepotSearch();
		}
	}

	void sendDepotSearchResultDetail(uint16_t itemId, uint8_t tier, uint32_t depotCount, const ItemVector &depotItems, uint32_t inboxCount, const ItemVector &inboxItems, uint32_t stashCount) {
		if (owner) {
			owner->sendDepotSearchResultDetail(itemId, tier, depotCount, depotItems, inboxCount, inboxItems, stashCount);
		}
	}

	void sendCoinBalance() {
		if (owner) {
			owner->sendCoinBalance();
		}
	}

	void sendInventoryIds() {
		if (owner) {
			owner->sendInventoryIds();
		}
	}

	void sendLootContainers() {
		if (owner) {
			owner->sendLootContainers();
		}
	}

	void sendSingleSoundEffect(const Position &pos, SoundEffect_t id, SourceEffect_t source) {
		if (owner) {
			owner->sendSingleSoundEffect(pos, id, source);
		}
	}

	void sendDoubleSoundEffect(const Position &pos, SoundEffect_t mainSoundId, SourceEffect_t mainSource, SoundEffect_t secondarySoundId, SourceEffect_t secondarySource) {
		if (owner) {
			owner->sendDoubleSoundEffect(pos, mainSoundId, mainSource, secondarySoundId, secondarySource);
		}
	}

	void sendCreatureEmblem(std::shared_ptr<Creature> creature) {
		if (owner) {
			owner->sendCreatureEmblem(creature);
		}
	}

	void sendItemInspection(uint16_t itemId, uint8_t itemCount, std::shared_ptr<Item> item, bool cyclopedia) {
		if (owner) {
			owner->sendItemInspection(itemId, itemCount, item, cyclopedia);
		}
	}

	void sendCyclopediaCharacterNoData(CyclopediaCharacterInfoType_t characterInfoType, uint8_t errorCode) {
		if (owner) {
			owner->sendCyclopediaCharacterNoData(characterInfoType, errorCode);
		}
	}

	void sendCyclopediaCharacterBaseInformation() {
		if (owner) {
			owner->sendCyclopediaCharacterBaseInformation();
		}
	}

	void sendCyclopediaCharacterGeneralStats() {
		if (owner) {
			owner->sendCyclopediaCharacterGeneralStats();
		}
	}

	void sendCyclopediaCharacterCombatStats() {
		if (owner) {
			owner->sendCyclopediaCharacterCombatStats();
		}
	}

	void sendCyclopediaCharacterRecentDeaths(uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries) {
		if (owner) {
			owner->sendCyclopediaCharacterRecentDeaths(page, pages, entries);
		}
	}

	void sendOpenForge() {
		if (owner) {
			owner->sendOpenForge();
		}
	}

	void sendForgeError(ReturnValue returnValue) {
		if (owner) {
			owner->sendForgeError(returnValue);
		}
	}

	void sendForgeHistory(uint8_t page) const {
		if (owner) {
			owner->sendForgeHistory(page);
		}
	}

	void closeForgeWindow() const {
		if (owner) {
			owner->closeForgeWindow();
		}
	}

	void sendBosstiaryCooldownTimer() const {
		if (owner) {
			owner->sendBosstiaryCooldownTimer();
		}
	}

	void sendCyclopediaCharacterRecentPvPKills(
		uint16_t page, uint16_t pages,
		const std::vector<
			RecentPvPKillEntry> &entries
	) {
		if (owner) {
			owner->sendCyclopediaCharacterRecentPvPKills(page, pages, entries);
		}
	}

	void sendCyclopediaCharacterAchievements(int16_t secretsUnlocked, std::vector<std::pair<Achievement, uint32_t>> achievementsUnlocked) {
		if (owner) {
			owner->sendCyclopediaCharacterAchievements(secretsUnlocked, achievementsUnlocked);
		}
	}

	void sendCyclopediaCharacterItemSummary(const ItemsTierCountList &inventoryItems, const ItemsTierCountList &storeInboxItems, const StashItemList &supplyStashItems, const ItemsTierCountList &depotBoxItems, const ItemsTierCountList &inboxItems) {
		if (owner) {
			owner->sendCyclopediaCharacterItemSummary(inventoryItems, storeInboxItems, supplyStashItems, depotBoxItems, inboxItems);
		}
	}

	void sendCyclopediaCharacterOutfitsMounts() {
		if (owner) {
			owner->sendCyclopediaCharacterOutfitsMounts();
		}
	}

	void sendCyclopediaCharacterStoreSummary() {
		if (owner) {
			owner->sendCyclopediaCharacterStoreSummary();
		}
	}

	void sendCyclopediaCharacterInspection() {
		if (owner) {
			owner->sendCyclopediaCharacterInspection();
		}
	}

	void sendCyclopediaCharacterBadges() {
		if (owner) {
			owner->sendCyclopediaCharacterBadges();
		}
	}

	void sendCyclopediaCharacterTitles() {
		if (owner) {
			owner->sendCyclopediaCharacterTitles();
		}
	}

	void sendHighscoresNoData() {
		if (owner) {
			owner->sendHighscoresNoData();
		}
	}

	void sendHighscores(const std::vector<HighscoreCharacter> &characters, uint8_t categoryId, uint32_t vocationId, uint16_t page, uint16_t pages, uint32_t updateTimer) {
		if (owner) {
			owner->sendHighscores(characters, categoryId, vocationId, page, pages, updateTimer);
		}
	}

	void sendMonsterPodiumWindow(std::shared_ptr<Item> podium, const Position &position, uint16_t itemId, uint8_t stackpos) {
		if (owner) {
			owner->sendMonsterPodiumWindow(podium, position, itemId, stackpos);
		}
	}

	void sendBosstiaryEntryChanged(uint32_t bossid) {
		if (owner) {
			owner->sendBosstiaryEntryChanged(bossid);
		}
	}

	void sendInventoryImbuements(const std::map<Slots_t, std::shared_ptr<Item>> items) {
		if (owner) {
			owner->sendInventoryImbuements(items);

			for (const auto &it : viewers) {
				it.first->sendInventoryImbuements(items);
			}
		}
	}

	void sendEnterWorld() {
		if (owner) {
			owner->sendEnterWorld();
		}
	}

	void sendExperienceTracker(int64_t rawExp, int64_t finalExp) {
		if (owner) {
			owner->sendExperienceTracker(rawExp, finalExp);
		}
	}

	void sendItemsPrice() {
		if (owner) {
			owner->sendItemsPrice();
		}
	}

	void sendForgingData() {
		if (owner) {
			owner->sendForgingData();
		}
	}

	void sendKillTrackerUpdate(std::shared_ptr<Container> corpse, const std::string &name, const Outfit_t creatureOutfit) {
		if (owner) {
			owner->sendKillTrackerUpdate(corpse, name, creatureOutfit);
		}
	}

	void sendMarketLeave() {
		if (owner) {
			owner->sendMarketLeave();
		}
	}

	void sendMarketBrowseItem(uint16_t itemId, const MarketOfferList &buyOffers, const MarketOfferList &sellOffers, uint8_t tier) {
		if (owner) {
			owner->sendMarketBrowseItem(itemId, buyOffers, sellOffers, tier);
		}
	}

	void sendMarketBrowseOwnOffers(const MarketOfferList &buyOffers, const MarketOfferList &sellOffers) {
		if (owner) {
			owner->sendMarketBrowseOwnOffers(buyOffers, sellOffers);
		}
	}

	void sendMarketBrowseOwnHistory(const HistoryMarketOfferList &buyOffers, const HistoryMarketOfferList &sellOffers) {
		if (owner) {
			owner->sendMarketBrowseOwnHistory(buyOffers, sellOffers);
		}
	}

	void sendMarketDetail(uint16_t itemId, uint8_t tier) {
		if (owner) {
			owner->sendMarketDetail(itemId, tier);
		}
	}

	void sendMarketAcceptOffer(const MarketOfferEx &offer) {
		if (owner) {
			owner->sendMarketAcceptOffer(offer);
		}
	}

	void sendMarketCancelOffer(const MarketOfferEx &offer) {
		if (owner) {
			owner->sendMarketCancelOffer(offer);
		}
	}

	void sendMessageDialog(const std::string &message) {
		if (owner) {
			owner->sendMessageDialog(message);
		}
	}

	void sendOpenStash() {
		if (owner) {
			owner->sendOpenStash();
		}
	}

	void sendPartyCreatureUpdate(std::shared_ptr<Creature> creature) {
		if (owner) {
			owner->sendPartyCreatureUpdate(creature);
		}
	}

	void sendPartyCreatureShield(std::shared_ptr<Creature> creature) {
		if (owner) {
			owner->sendPartyCreatureShield(creature);
		}
	}

	void sendPartyCreatureSkull(std::shared_ptr<Creature> creature) {
		if (owner) {
			owner->sendPartyCreatureSkull(creature);
		}
	}

	void sendPartyCreatureHealth(std::shared_ptr<Creature> creature, uint8_t healthPercent) {
		if (owner) {
			owner->sendPartyCreatureHealth(creature, healthPercent);
		}
	}

	void sendPartyPlayerMana(std::shared_ptr<Player> player, uint8_t manaPercent) {
		if (owner) {
			owner->sendPartyPlayerMana(player, manaPercent);
		}
	}

	void sendPartyCreatureShowStatus(std::shared_ptr<Creature> creature, bool showStatus) {
		if (owner) {
			owner->sendPartyCreatureShowStatus(creature, showStatus);
		}
	}

	void sendPartyPlayerVocation(std::shared_ptr<Player> player) {
		if (owner) {
			owner->sendPartyPlayerVocation(player);
		}
	}

	void sendPlayerVocation(std::shared_ptr<Player> player) {
		if (owner) {
			owner->sendPlayerVocation(player);
		}
	}

	void sendPreyTimeLeft(const std::unique_ptr<PreySlot> &slot) {
		if (owner) {
			owner->sendPreyTimeLeft(slot);
		}
	}

	void sendResourcesBalance(uint64_t money = 0, uint64_t bank = 0, uint64_t preyCards = 0, uint64_t taskHunting = 0, uint64_t forgeDust = 0, uint64_t forgeSliver = 0, uint64_t forgeCores = 0) {
		if (owner) {
			owner->sendResourcesBalance(money, bank, preyCards, taskHunting, forgeDust, forgeSliver, forgeCores);
		}
	}

	void sendCreatureReload(std::shared_ptr<Creature> creature) {
		if (owner) {
			owner->reloadCreature(creature);
		}
	}

	void sendCreatureChangeOutfit(std::shared_ptr<Creature> creature, const Outfit_t &outfit) {
		if (owner) {
			owner->sendCreatureOutfit(creature, outfit);

			for (const auto &it : viewers) {
				it.first->sendCreatureOutfit(creature, outfit);
			}
		}
	}

	void sendPreyData(const std::unique_ptr<PreySlot> &slot) {
		if (owner) {
			owner->sendPreyData(slot);
		}
	}

	void sendSpecialContainersAvailable() {
		if (owner) {
			owner->sendSpecialContainersAvailable();
		}
	}

	void sendTaskHuntingData(const std::unique_ptr<TaskHuntingSlot> &slot) {
		if (owner) {
			owner->sendTaskHuntingData(slot);
		}
	}

	void sendTibiaTime(int32_t time) {
		if (owner) {
			owner->sendTibiaTime(time);
		}
	}

	void sendUpdateInputAnalyzer(CombatType_t type, int32_t amount, std::string target) {
		if (owner) {
			owner->sendUpdateInputAnalyzer(type, amount, target);
		}
	}

	void sendRestingStatus(uint8_t protection) {
		if (owner) {
			owner->sendRestingStatus(protection);
		}
	}

	void AddItem(NetworkMessage &msg, std::shared_ptr<Item> item) {
		if (owner) {
			owner->AddItem(msg, item);
		}
	}

	void AddItem(NetworkMessage &msg, uint16_t id, uint8_t count, uint8_t tier) {
		if (owner) {
			owner->AddItem(msg, id, count, tier);
		}
	}

	void parseSendBosstiary() {
		if (owner) {
			owner->parseSendBosstiary();
		}
	}

	void parseSendBosstiarySlots() {
		if (owner) {
			owner->parseSendBosstiarySlots();
		}
	}

	void sendLootStats(std::shared_ptr<Item> item, uint8_t count) {
		if (owner) {
			owner->sendLootStats(item, count);
		}
	}

	void sendUpdateSupplyTracker(std::shared_ptr<Item> item) {
		if (owner) {
			owner->sendUpdateSupplyTracker(item);
		}
	}

	void sendUpdateImpactTracker(CombatType_t type, int32_t amount) {
		if (owner) {
			owner->sendUpdateImpactTracker(type, amount);
		}
	}

	void openImbuementWindow(std::shared_ptr<Item> item) {
		if (owner) {
			owner->openImbuementWindow(item);
		}
	}

	void sendMarketEnter(uint32_t depotId) {
		if (owner) {
			owner->sendMarketEnter(depotId);
		}
	}

	void sendUnjustifiedPoints(const uint8_t &dayProgress, const uint8_t &dayLeft, const uint8_t &weekProgress, const uint8_t &weekLeft, const uint8_t &monthProgress, const uint8_t &monthLeft, const uint8_t &skullDuration) {
		if (owner) {
			owner->sendUnjustifiedPoints(dayProgress, dayLeft, weekProgress, weekLeft, monthProgress, monthLeft, skullDuration);

			for (const auto &it : viewers) {
				it.first->sendUnjustifiedPoints(dayProgress, dayLeft, weekProgress, weekLeft, monthProgress, monthLeft, skullDuration);
			}
		}
	}

	void sendModalWindow(const ModalWindow &modalWindow) {
		if (owner) {
			owner->sendModalWindow(modalWindow);
		}
	}

	void sendResourceBalance(Resource_t resourceType, uint64_t value) {
		if (owner) {
			owner->sendResourceBalance(resourceType, value);
		}
	}

	void sendOpenWheelWindow(uint32_t ownerId) {
		if (owner) {
			owner->sendOpenWheelWindow(ownerId);
		}
	}

	void sendCreatureSay(std::shared_ptr<Creature> creature, SpeakClasses type, const std::string &text, const Position* pos = nullptr) {
		if (owner) {
			owner->sendCreatureSay(creature, type, text, pos);

			if (type == TALKTYPE_PRIVATE_FROM) {
				return;
			}

			for (const auto &it : viewers) {
				it.first->sendCreatureSay(creature, type, text, pos);
			}
		}
	}

	void disconnectClient(const std::string &message) const {
		if (owner) {
			owner->disconnectClient(message);
		}
	}

	bool oldProtocol;

private:
	friend class Player;

	CastViewersList viewers;
	StringVector mutes;
	DataCastList bans;
	Map map;

	ProtocolGame_ptr owner;
	uint32_t id;
	std::string cast_password;
	std::string cast_description;
	bool cast_broadcast;
	int64_t cast_broadcast_time;
	uint16_t cast_live_record;
};
