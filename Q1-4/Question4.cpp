//Q4 - Assume all method calls work fine.Fix the memory leak issue in below method



void Game::addItemToPlayer(const std::string & recipient, uint16_t itemId)

{

    Player* player = g_game.getPlayerByName(recipient);

    if (!player) {

        player = new Player(nullptr);

        if (!IOLoginData::loadPlayerByName(player, recipient)) {

            // delete invalid player before exiting, most likely culprit of memory leak
            delete player;

            return;

        }

    }



    Item* item = Item::CreateItem(itemId);

    if (!item) {

        // no item to delete here, so not the culprit
        return;

    }



    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);



    if (player->isOffline()) {

        IOLoginData::savePlayer(player);

        // delete player and item memory here since player is offline, so they are not needed (I think)
        delete player;
        delete item;

        return;
    }

    // if we made it here then both item and player are valid and are used, so I will not delete them before exiting function

}