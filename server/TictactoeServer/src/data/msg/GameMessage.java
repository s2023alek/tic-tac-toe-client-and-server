package data.msg;

import data.encoders.GameMessageEncoder;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelHandlerContext;
import logging.Logger;

import java.util.ArrayList;
import java.util.UUID;

public class GameMessage extends SimpleMessage implements IGameMessage {

    public GameMessage(int type, UUID playerId) {
        super(type, playerId);
    }


    @Override
    public Boolean writeToContext(ChannelHandlerContext ctx) {
        //todo simplify this method - create message fields list and datatype, then process data types here
        switch (type) {

            case IMessage.TYPE_OUT_PLAYER_TURN:
            case IMessage.TYPE_OUT_YOUR_ID:
            case IMessage.TYPE_OUT_PLAYER_LEFT_ROOM_TEMP:
                ctx.write(Unpooled.buffer(4).writeInt(type));// msg type
                GameMessageEncoder.writeString(ctx, playerId.toString());
                ctx.flush();
                break;

            case IMessage.TYPE_OUT_PLAYER_JOINED_ROOM:
                ctx.write(Unpooled.buffer(4).writeInt(type));// msg type
                GameMessageEncoder.writeString(ctx, playerId.toString());
                GameMessageEncoder.writeString(ctx, playerName);
                ctx.flush();
                break;

            case IMessage.TYPE_OUT_PLAYER_ENTERED_ROOM:
                ctx.write(Unpooled.buffer(4).writeInt(type));// msg type
                GameMessageEncoder.writeString(ctx, playerId.toString());
                GameMessageEncoder.writeString(ctx, playerName);
                ctx.flush();
                //Logger.log("SWRITE> TYPE_OUT_PLAYER_ENTERED_ROOM to client"+playerId);
                break;

            case IMessage.TYPE_OUT_GAME_STARTED:
                //Logger.log("NET> OUT msg> TYPE_OUT_GAME_STARTED: currentTurnPlayerId="+currentTurnPlayerId.toString()+"mark1PlayerId="+mark1PlayerId.toString());
                ctx.write(Unpooled.buffer(4).writeInt(type));// msg type
                GameMessageEncoder.writeString(ctx, currentTurnPlayerId.toString());
                GameMessageEncoder.writeString(ctx, mark1PlayerId.toString());
                ctx.flush();
                break;

            case IMessage.TYPE_OUT_PLAYER_MOVE:
                ctx.write(Unpooled.buffer(4).writeInt(type));// msg type
                GameMessageEncoder.writeString(ctx, playerId.toString());
                GameMessageEncoder.writeString(ctx, currentTurnPlayerId.toString());
                ctx.write(Unpooled.buffer(4).writeInt(x));
                ctx.write(Unpooled.buffer(4).writeInt(y));
                ctx.write(Unpooled.buffer(4).writeInt(winnerMarkSN));
                ctx.flush();
                break;

            case IMessage.TYPE_OUT_GAME_SESSION_DATA:
                ctx.write(Unpooled.buffer(4).writeInt(type));// msg type
                //GameMessageEncoder.writeString(ctx, playerId.toString());
                if (currentTurnPlayerId == null) {
                    GameMessageEncoder.writeString(ctx, "no id");
                } else {
                    GameMessageEncoder.writeString(ctx, currentTurnPlayerId.toString());
                }

                for (Integer i : gameBoardCellsData) {
                    ctx.write(Unpooled.buffer(4).writeInt(i));
                }
                ctx.flush();
                //Logger.log("SWRITE> TYPE_OUT_GAME_SESSION_DATA to client"+playerId);
                break;



            default:
                Logger.log("!! WARNING: GameMessage.writeToContext() type not implemented:"+type);
                return false;

        }

        return false;
    }

    /// === getters and setters

    public int getX() {
        return x;
    }


    public int getY() {
        return y;
    }


    public String getPlayerName() {
        return playerName;
    }


    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public void setX(int x) {
        this.x = x;
    }

    public void setY(int y) {
        this.y = y;
    }

    public int getWinnerMarkSN() {
        return winnerMarkSN;
    }

    public void setWinnerMarkSN(int winnerMarkSN) {
        this.winnerMarkSN = winnerMarkSN;
    }


    public void setYouWon(Boolean youWon) {
        this.youWon = youWon;
    }

    public void setGameBoardCellsData(ArrayList<Integer>  gameBoardCellsData) {
        this.gameBoardCellsData = gameBoardCellsData;
    }




    /// === fields

    public Boolean getYouWon() {
        return youWon;
    }
    private  String playerName;
    private  int x;
    private  int y;

    private  int winnerMarkSN;

    private  Boolean youWon;
    private ArrayList<Integer> gameBoardCellsData;


}
