package data.msg;

import java.util.UUID;

public interface IGameMessage extends IMessage {
    int getX();

    int getY();

    String getPlayerName();

    void setPlayerId(UUID id);
    void setPlayerName(String playerName);

    Boolean getYouWon();
}
