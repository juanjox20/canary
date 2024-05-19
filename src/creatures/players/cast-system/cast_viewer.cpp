#include "pch.hpp"

#include "creatures/players/cast-system/cast_viewer.hpp"
#include "creatures/players/player.hpp"

#include "creatures/interactions/chat.hpp"
#include "config/configmanager.hpp"

#include "server/network/message/outputmessage.hpp"

bool CastViewer::checkPassword(const std::string &_password) {
	if (cast_password.empty()) {
		return true;
	}

	std::string t = _password;
	trimString(t);

	return t == cast_password;
}

void CastViewer::kickViewer(StringVector list) {
	for (const auto &it : list) {
		for (const auto &sit : viewers) {
			if (asLowerCaseString(sit.second.first) == it) {
				sit.first->disconnect();
			}
		}
	}
}

void CastViewer::banViewer(StringVector _bans) {
	StringVector::const_iterator it;
	for (auto bit = bans.begin(); bit != bans.end();) {
		it = std::find(_bans.begin(), _bans.end(), bit->first);
		if (it == _bans.end()) {
			bans.erase(bit++);
		} else {
			++bit;
		}
	}

	for (it = _bans.begin(); it != _bans.end(); ++it) {
		for (const auto &sit : viewers) {
			if (asLowerCaseString(sit.second.first) != *it) {
				continue;
			}

			bans[*it] = sit.first->getIP();
			sit.first->disconnect();
		}
	}
}

void CastViewer::addViewer(ProtocolGame_ptr client, std::string name /* = nullptr*/, bool spy) {
	if (++id == 65536) {
		id = 1;
	}

	std::stringstream message;
	if (name.empty()) {
		message << "Viewer " << id << "";
	} else {
		message << name << " (Telescope)";
		for (const auto &it : viewers) {
			if (it.second.first.compare(name) == 0) {
				message << " " << id;
			}
		}
	}

	viewers[client] = std::make_pair(message.str(), id);

	if (!spy) {
		// sendTextMessage(MESSAGE_STATUS, message.str() + " has entered the cast.");
		sendChannelMessage("", message.str() + " has entered the cast.", TALKTYPE_CHANNEL_O, CHANNEL_CAST);

		if (viewers.size() > cast_live_record) {
			cast_live_record = viewers.size();
			// sendTextMessage(MESSAGE_STATUS, "New record: " + std::to_string(cast_live_record) + " people are watching your livestream now.");
			sendChannelMessage("", "New record: " + std::to_string(cast_live_record) + " people are watching your livestream now.", TALKTYPE_CHANNEL_O, CHANNEL_CAST);
		}
	}
}

void CastViewer::removeViewer(ProtocolGame_ptr client, bool spy) {
	auto it = viewers.find(client);
	if (it == viewers.end()) {
		return;
	}

	auto mit = std::find(mutes.begin(), mutes.end(), it->second.first);
	if (mit != mutes.end()) {
		mutes.erase(mit);
	}

	if (!spy) {
		// sendTextMessage(MESSAGE_STATUS, it->second.first + " has left the cast.");
		sendChannelMessage("", it->second.first + " has left the cast.", TALKTYPE_CHANNEL_O, CHANNEL_CAST);
	}

	viewers.erase(it);
}

void CastViewer::handle(ProtocolGame_ptr client, const std::string &text, uint16_t channelId) {
	if (!owner) {
		return;
	}

	auto sit = viewers.find(client);
	if (sit == viewers.end()) {
		return;
	}

	const int64_t &now = OTSYS_TIME();
	if (client->cast_cooldown_time + 5000 < now) {
		client->cast_cooldown_time = now, client->cast_count = 0;
	} else if (client->cast_count++ >= 3) {
		std::stringstream messageViewer;
		messageViewer << "Please wait a " << ((client->cast_cooldown_time + 5000 - now) / 1000) + 1 << " seconds to send another message.";
		client->sendTextMessage(TextMessage(MESSAGE_STATUS, messageViewer.str()));
		return;
	}

	bool isCastChannel = channelId == CHANNEL_CAST;
	if (text[0] == '/') {
		StringVector CommandParam = explodeString(text.substr(1, text.length()), " ", 1);
		if (strcasecmp(CommandParam[0].c_str(), "show") == 0) {
			std::stringstream messageViewer;
			messageViewer << viewers.size() << " spectator" << (viewers.size() > 1 ? "s" : "") << ". ";
			for (auto it = viewers.begin(); it != viewers.end(); ++it) {
				if (it != viewers.begin()) {
					messageViewer << " ,";
				}

				messageViewer << it->second.first;
			}

			messageViewer << ".";
			client->sendTextMessage(TextMessage(MESSAGE_STATUS, messageViewer.str()));
		} else if (strcasecmp(CommandParam[0].c_str(), "name") == 0) {
			if (CommandParam.size() > 1) {
				if (CommandParam[1].length() > 2) {
					if (CommandParam[1].length() < 18) {
						bool found = false;
						for (auto it = viewers.begin(); it != viewers.end(); ++it) {
							if (strcasecmp(it->second.first.c_str(), CommandParam[1].c_str()) != 0) {
								continue;
							}

							found = true;
							break;
						}

						if (!found) {
							if (isCastChannel) {
								sendChannelMessage("", sit->second.first + " was renamed for " + CommandParam[1] + ".", TALKTYPE_CHANNEL_O, CHANNEL_CAST);
							}

							auto mit = std::find(mutes.begin(), mutes.end(), asLowerCaseString(sit->second.first));
							if (mit != mutes.end()) {
								(*mit) = asLowerCaseString(CommandParam[1]);
							}

							sit->second.first = CommandParam[1];
						} else {
							client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "There is already someone with that name."));
						}
					} else {
						client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "It is not possible very long name."));
					}
				} else {
					client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "It is not possible very small name."));
				}
			}
		} else {
			client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "Available commands: /name, /show."));
		}

		return;
	}

	auto mit = std::find(mutes.begin(), mutes.end(), asLowerCaseString(sit->second.first));
	if (mit == mutes.end()) {
		if (isCastChannel) {
			sendChannelMessage(sit->second.first, text, TALKTYPE_CHANNEL_Y, CHANNEL_CAST);
		}
	} else {
		client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "You are mutated."));
	}
}

// nao usadao
void CastViewer::chat(uint16_t channelId) {
	if (!owner) {
		return;
	}

	const auto &channel = g_chat().getPrivateChannel(owner->getPlayer());
	if (!channel || channel->getId() != channelId) {
		return;
	}

	for (const auto &it : viewers) {
		it.first->sendClosePrivate(channelId);
	}
}

/*void CastViewer::sendCreatureSay(std::shared_ptr<Creature> creature, SpeakClasses type, const std::string& text, const Position* pos = nullptr) {
	if (owner) {
		owner->sendCreatureSay(creature, type, text, pos);
		for (const auto& it : viewers) {
			it.first->sendCreatureSay(creature, type, text, pos);
		}
	}
}

void CastViewer::sendToChannel(std::shared_ptr<Creature> creature, SpeakClasses type, const std::string& text, uint16_t channelId) {
	if (owner) {
		owner->sendToChannel(creature, type, text, channelId);
		for (const auto& it : viewers) {
			it.first->sendToChannel(creature, type, text, channelId);
		}
	}
}*/
