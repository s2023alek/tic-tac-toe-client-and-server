package data.game;

import data.game.GamePlayer;
import data.msg.GameMessage;
import data.msg.IGameMessage;
import data.msg.IMessage;
import data.msg.MessageFactory;
import logging.Logger;

import java.util.UUID;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.CopyOnWriteArrayList;

public class GameRoom {

    public GameRoom() {
        // create new empty GameBoard
        board = new GameBoard(3, 3);
        id = UUID.randomUUID();
        this.playersList = new CopyOnWriteArrayList<>();
        numOnlinePlayers = 0;
    }

    public GamePlayer getPlayer(UUID playerId) {
        for (GamePlayer obj : playersList) {
            if (obj != null && obj.getId().equals(playerId)) {
                return obj;
            }
        }
        return null;
    }


    public Boolean isFull() {
        int l = playersList.size();
        if (l < 2) return false;
        //Logger.log("isFull l=" + l);
        for (int i = 0; i < l; i++) {
            if (playersList.get(i) == null) {
                //Logger.log("found sn=" + i);
                return false;
            }
        }
        //Logger.log("!not found");
        return true;
    }

    public void addPlayer(GamePlayer p) {
        numOnlinePlayers += 1;
        playersList.add(p);
        p.setRoom(this);
        outgoingEventsList.add(MessageFactory.cmTYPE_OUT_PLAYER_JOINED_ROOM(p.getId(), p.getName()));
        Logger.log("player (" + p.getId().toString() + ") joined room " + id.toString());

        //Logger.log("playersList.size()="+playersList.size());
        if (playersList.size() == 2 && !gameStarted) {
            startGame();
        }
    }


    public Boolean processIncomingEvent() {
        //Logger.log("processIncomingMessage>");
        if (incomingEventsList.size() < 1) return false;
        GameMessage msg = (GameMessage) incomingEventsList.poll();
        GameMessage evt;
        GamePlayer p;
        //Logger.log("processIncomingMessage>type="+msg.getType());

        switch (msg.getType()) {

            case IMessage.TYPE_IN_PLAYER_LOGOUT:
                removePlayer(getPlayer(msg.getPlayerId()));
                break;

            case IMessage.TYPE_OUT_PLAYER_LEFT_ROOM_TEMP:
                numOnlinePlayers -= 1;
                outgoingEventsList.add(MessageFactory.cmTYPE_OUT_PLAYER_LEFT_ROOM_TEMP(msg.getPlayerId()));
                Logger.log("player (" + msg.getPlayerId().toString() + ") lost connection in room " + id.toString());
                break;

            case IMessage.TYPE_OUT_PLAYER_ENTERED_ROOM:
                numOnlinePlayers += 1;
                outgoingEventsList.add(msg);
                Logger.log("player (" + msg.getPlayerId().toString() + ") RESTORED connection in room " + id.toString());
                break;

            case IMessage.TYPE_OUT_GAME_SESSION_DATA:
                msg.setCurrentTurnPlayerId(currentPlayerTurn);
                msg.setGameBoardCellsData(board.getData());
                outgoingEventsList.add(msg);
                Logger.log("SESSION send to " + msg.getPlayerId().toString());
                break;


            case IMessage.TYPE_IN_PLAYER_MOVE:
                if (!gameStarted || gameIsOver) {
                    Logger.log("TYPE_IN_PLAYER_MOVE > cannot set board mark, the game is not started or it is over");
                    break;
                }

                p = getPlayer(msg.getPlayerId());

                if (p != null) {

                    //Logger.log("DATA> check turn:" + currentPlayerTurn + " == " + p.getId());
                    if (!currentPlayerTurn.equals(p.getId())) {
                        Logger.log("!cannot set mark, not player's turn; mark: " + msg.getX() + "/" + msg.getY());
                        break;
                    }

                    boolean opSuccess = board.setMark(msg.getX(), msg.getY(), p.getMarkSN());


                    if (opSuccess) {
                        Logger.log("player (" + msg.getPlayerId().toString() + ") setMark: x=" + msg.getX() + " y=" + msg.getY());

                        //test victory
                        if (board.isFull()) {
                            gameOver();
                            evt = (GameMessage) MessageFactory.cmTYPE_OUT_PLAYER_MOVE(msg.getPlayerId(), currentPlayerTurn, msg.getX(), msg.getY(), GameBoard.BOARD_IS_FULL);
                            outgoingEventsList.add(evt);
                            break;
                        }

                        int winnerMarkSN = board.getWinnerMarkSN();

                        if (winnerMarkSN == GameBoard.EMPTY_CELL) {
                            switchTurns();
                        } else {
                            //else //game is over, the winner has markSN
                            gameOver();
                        }
                        evt = (GameMessage) MessageFactory.cmTYPE_OUT_PLAYER_MOVE(msg.getPlayerId(), currentPlayerTurn, msg.getX(), msg.getY(), winnerMarkSN);
                        outgoingEventsList.add(evt);
                    } else {
                        Logger.log("cannot set mark here:" + msg.getX() + "/" + msg.getY());
                    }

                } else {
                    Logger.log("ERROR: TYPE_IN_PLAYER_MOVE > player not found pid=" + msg.getPlayerId());
                }
                break;


        }
        return true;
    }

    public GameMessage getOutgoingEvent() {
        return (GameMessage) outgoingEventsList.poll();
    }



    private void startGame() {
        // assign marks to players
        //todo random marks
        GamePlayer p1 = playersList.get(0);
        GamePlayer p2 = playersList.get(1);
        p1.setMarkSN(GameBoard.MARK1);
        p2.setMarkSN(GameBoard.MARK2);
        currentPlayerTurn = p2.getId();
        Logger.log("================ match started =====================");
        //start the match, provide players with a sign, a playerTurn
        IGameMessage evt = (IGameMessage) MessageFactory.cmTYPE_OUT_GAME_STARTED(currentPlayerTurn, p1.getId());
        outgoingEventsList.add(evt);
        // if not started yet, start the match
        gameStarted = true;
    }

    private void switchTurns() {
        GamePlayer p1 = playersList.get(0);
        GamePlayer p2 = playersList.get(1);
        currentPlayerTurn = currentPlayerTurn.equals(p1.getId()) ? p2.getId() : p1.getId();
        // inform players
        //IMessage evt = (GameMessage) MessageFactory.cmTYPE_OUT_PLAYER_TURN(currentPlayerTurn);
        //outgoingEventsList.add(evt);
    }
    private void gameOver() {
        gameIsOver = true;
    }

    private void removePlayer(GamePlayer p) {
        playersList.remove(p);
        p.setRoom(null);
        numOnlinePlayers -= 1;
        outgoingEventsList.add(MessageFactory.cmTYPE_OUT_PLAYER_LEFT_ROOM_PERM(p.getId()));
        Logger.log("player (" + p.getId().toString() + ") left room " + id.toString());
    }

    public void addEvent(IMessage m) {
        incomingEventsList.add(m);
    }


    public int getNumOnlinePlayers() {return numOnlinePlayers;}

    public boolean isGameIsOver() {return gameIsOver;}

    private int numOnlinePlayers;
    private UUID currentPlayerTurn;
    private boolean gameStarted = false;

    private boolean gameIsOver = false;
    private final GameBoard board;

    public CopyOnWriteArrayList<GamePlayer> getPlayersList() {return playersList;}

    private final ConcurrentLinkedQueue<IMessage> incomingEventsList = new ConcurrentLinkedQueue<>();
    private final ConcurrentLinkedQueue<IMessage> outgoingEventsList = new ConcurrentLinkedQueue<>();

    private final CopyOnWriteArrayList<GamePlayer> playersList;
    private final UUID id;

}