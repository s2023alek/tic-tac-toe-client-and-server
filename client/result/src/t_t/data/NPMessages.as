// Project TicTacToe
package t_t.data {
	
	//{ ======= import
	//} ======= END OF import
	
	
	/**
	 * application constants
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 
	 */
	public class NPMessages {
		
		

    /// incoming messages


    /**
     * String UUID id, String playerName
     */
    public static const TYPE_IN_PLAYER_LOGIN:int = 100;
    /**
     * String playerName
     */
     public static const TYPE_IN_PLAYER_JOIN:int = 101;
    /**
     * int x, int y
     */
     public static const TYPE_IN_PLAYER_MOVE:int = 102;
    /**
     * String UUID playerId
     */
    public static const TYPE_IN_PLAYER_LOGOUT:int = 103;





    /// outgoing messages
    /**
     * String UUID playerId
     */
    public static const TYPE_OUT_YOUR_ID:int = 207;
    /**
     * 
     */
	public static const TYPE_OUT_WAIT_FOR_ANOTHER_PLAYER:int = 200;
    /**
     * String UUID firstTurnPlayerId, String UUID Mark1PlayerId
     */
    public static const TYPE_OUT_GAME_STARTED:int = 201;
    /**
     * int youWon
     */
    public static const TYPE_OUT_GAME_ENDED:int = 202;

    /**
     * String UUID playerName
     */
    public static const TYPE_OUT_PLAYER_JOINED_ROOM:int = 203;
    /**
     * String UUID playerName
     */
    public static const TYPE_OUT_PLAYER_LEFT_ROOM_TEMP:int = 204;
    /**
     * String UUID playerName
     */
    public static const TYPE_OUT_PLAYER_LEFT_ROOM_PERM:int = 208;
    /**
     * String UUID playerName
     */
    public static const TYPE_OUT_PLAYER_ENTERED_ROOM:int = 209;


    /**
     * String UUID playerId, String UUID playerTurn, int x, int y, int winnerMarkSN
     */
    public static const TYPE_OUT_PLAYER_MOVE:int = 501;
    /**
     * current player turn 
	 * String UUID playerId
     */
    public static const TYPE_OUT_PLAYER_TURN:int = 502;
    /**
     * String UUID playerTurn, [int] boardData
     */
    public static const TYPE_OUT_GAME_SESSION_DATA:int = 600;

	}
}
