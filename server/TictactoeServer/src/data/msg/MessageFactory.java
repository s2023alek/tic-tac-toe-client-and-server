package data.msg;

import data.parsers.GameMessageParser;
import io.netty.buffer.ByteBuf;
import logging.Logger;

import java.util.UUID;

public class MessageFactory {



    /// incoming messages
    private static IMessage cmTYPE_IN_PLAYER_LOGIN(ByteBuf buf) {
        GameMessage m = new GameMessage(IMessage.TYPE_IN_PLAYER_LOGIN, null);
        String su = GameMessageParser.parseString(buf);
        String spn = GameMessageParser.parseString(buf);
        Logger.log("MSG> LOGIN: uuid: "+su+" player name:"+spn);
        m.setPlayerId(UUID.fromString(su));
        m.setPlayerName(spn);
        return m;
    }

    private static IMessage cmTYPE_IN_PLAYER_LOGOUT() {
        return new GameMessage(IMessage.TYPE_IN_PLAYER_LOGOUT, null);
    }
    private static IMessage cmTYPE_IN_PLAYER_JOIN(ByteBuf buf, UUID playerId) {
        GameMessage m = new GameMessage(IMessage.TYPE_IN_PLAYER_JOIN, playerId);
        String pn = GameMessageParser.parseString(buf);
        Logger.log("MSG> JOIN: player name: "+pn);
        m.setPlayerName(pn);
        return m;
    }
    private static IMessage cmTYPE_IN_PLAYER_MOVE(ByteBuf buf, UUID playerId) {
        GameMessage m = new GameMessage(IMessage.TYPE_IN_PLAYER_MOVE, playerId);
        m.setX(buf.readInt());
        m.setY(buf.readInt());
        return m;
    }


    /// outgoing messages
    public static IMessage cmTYPE_OUT_WAIT_FOR_ANOTHER_PLAYER() {
        return new GameMessage(IMessage.TYPE_OUT_WAIT_FOR_ANOTHER_PLAYER, null);
    }

    public static IMessage cmTYPE_OUT_YOUR_ID(UUID id) {
        return new GameMessage(IMessage.TYPE_OUT_YOUR_ID, id);
    }


    public static IMessage cmTYPE_OUT_GAME_ENDED(Boolean youWon) {
        GameMessage m = new GameMessage(IMessage.TYPE_OUT_GAME_ENDED, null);
        m.setYouWon(youWon);
        return m;
    }

    public static IMessage cmTYPE_OUT_PLAYER_JOINED_ROOM(UUID id, String playerName) {
        GameMessage m = new GameMessage(IMessage.TYPE_OUT_PLAYER_JOINED_ROOM, id);
        m.setPlayerName(playerName);
        return m;
    }

    public static IMessage cmTYPE_OUT_PLAYER_LEFT_ROOM_TEMP(UUID id) {
        return new GameMessage(IMessage.TYPE_OUT_PLAYER_LEFT_ROOM_TEMP, id);
    }
    public static IMessage cmTYPE_OUT_PLAYER_LEFT_ROOM_PERM(UUID id) {
        return new GameMessage(IMessage.TYPE_OUT_PLAYER_LEFT_ROOM_PERM, id);
    }

    public static IMessage cmTYPE_OUT_PLAYER_MOVE(UUID playerId, UUID playerTurn, int x, int y, int winnerMarkSN) {
        GameMessage m = new GameMessage(IMessage.TYPE_OUT_PLAYER_MOVE, playerId);
        m.setX(x);
        m.setY(y);
        m.setWinnerMarkSN(winnerMarkSN);
        m.setCurrentTurnPlayerId(playerTurn);
        return m;
    }

    public static IMessage cmTYPE_OUT_GAME_SESSION_DATA(UUID targetPlayerId) {
        return new GameMessage(IMessage.TYPE_OUT_GAME_SESSION_DATA, targetPlayerId);
    }

    public static IMessage cmTYPE_OUT_GAME_STARTED(UUID currentTurnPlayerId, UUID Mark1PlayerId) {
        GameMessage m = new GameMessage(IMessage.TYPE_OUT_GAME_STARTED, null);
        m.setCurrentTurnPlayerId(currentTurnPlayerId);
        m.setMark1PlayerId(Mark1PlayerId);
        return m;
    }
    public static IMessage cmTYPE_OUT_PLAYER_ENTERED_ROOM(UUID id, String playerName) {
        GameMessage m = new GameMessage(IMessage.TYPE_OUT_PLAYER_ENTERED_ROOM, id);
        m.setPlayerName(playerName);
        return m;
    }

    /*
    public static IMessage cmTYPE_OUT_PLAYER_TURN(UUID id) {
        GameMessage m = new GameMessage(IMessage.TYPE_OUT_PLAYER_TURN, id);
        return m;
    }*/






    public static IMessage constructIncomingMessage(ByteBuf buf, UUID playerId) {
        try {
            int type = buf.readInt();
            //Logger.log("msg factory. msg type="+type);

            switch (type) {

                /// incoming messages
                case IMessage.TYPE_IN_PLAYER_LOGIN:// {UUID}
                    return cmTYPE_IN_PLAYER_LOGIN(buf);

                case IMessage.TYPE_IN_PLAYER_LOGOUT:
                    return cmTYPE_IN_PLAYER_LOGOUT();

                case IMessage.TYPE_IN_PLAYER_JOIN:// {string playerName}
                    return cmTYPE_IN_PLAYER_JOIN(buf, playerId);

                case IMessage.TYPE_IN_PLAYER_MOVE: //{int x, int y}
                    return cmTYPE_IN_PLAYER_MOVE(buf, playerId);

            }

        } catch (Exception e) {
            Logger.log("MessageFactory: error while parsing data:");
        }

        return null;
    }
}
