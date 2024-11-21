package data.msg;

import io.netty.channel.ChannelHandlerContext;

import java.util.UUID;

public interface IMessage {
    int getType();

    UUID getPlayerId();

    Boolean writeToContext(ChannelHandlerContext ctx);

    @Override
    String toString();





    /// incoming messages


    /**
     * UUID id, String playerName
     */
    int TYPE_IN_PLAYER_LOGIN = 100;
    /**
     * String playerName
     */
     int TYPE_IN_PLAYER_JOIN = 101;
    /**
     * int x, int y
     */
     int TYPE_IN_PLAYER_MOVE = 102;
    /**
     * UUID playerId
     */
    int TYPE_IN_PLAYER_LOGOUT = 103;





    /// outgoing messages
    /**
     * UUID playerId
     */
    int TYPE_OUT_YOUR_ID = 207;
     int TYPE_OUT_WAIT_FOR_ANOTHER_PLAYER = 200;
    /**
     * UUID firstTurnPlayerId, UUID Mark1PlayerId
     */
    int TYPE_OUT_GAME_STARTED = 201;
    /**
     * boolean youWon
     */
    int TYPE_OUT_GAME_ENDED = 202;

    /**
     * UUID, string playerName
     */
    int TYPE_OUT_PLAYER_JOINED_ROOM = 203;
    /**
     * UUID
     */
    int TYPE_OUT_PLAYER_LEFT_ROOM_TEMP = 204;
    /**
     * UUID
     */
    int TYPE_OUT_PLAYER_LEFT_ROOM_PERM = 208;
    /**
     * UUID
     */
    int TYPE_OUT_PLAYER_ENTERED_ROOM = 209;


    /**
     * UUID playerId, UUID playerTurn, int x, int y, int winnerMarkSN
     */
    int TYPE_OUT_PLAYER_MOVE = 501;
    /**
     * current player turn - UUID playerId
     */
    int TYPE_OUT_PLAYER_TURN = 502;
    /**
     * UUID playerTurn, int[] boardData
     */
    int TYPE_OUT_GAME_SESSION_DATA = 600;

}
