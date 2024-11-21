package control;

import data.game.GamePlayer;
import data.game.GameRoom;
import data.msg.IGameMessage;
import data.msg.IMessage;
import data.msg.MessageFactory;
import logging.Logger;
import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;

import java.util.UUID;
import java.util.concurrent.CopyOnWriteArrayList;

public class ClientHandler extends ChannelInboundHandlerAdapter {
    private final CopyOnWriteArrayList<GameRoom> roomsList;
    private UUID playerId = null;
    private GamePlayer player;
    private Boolean playerLoggedOut = false;

    public ClientHandler(CopyOnWriteArrayList<GameRoom> roomsList) {
        this.roomsList = roomsList;
    }

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object message) {
        ByteBuf buf = (ByteBuf) message;
        try {
            IGameMessage msg = (IGameMessage) MessageFactory.constructIncomingMessage(buf, playerId);

            if (msg == null) {
                Logger.log("unknown msg from client[" + playerId + "]");
            } else {
                //Logger.log("IN msg from client type:" + msg.getType());
                GameRoom r;
                GamePlayer p;

                switch (msg.getType()) {

                    case IMessage.TYPE_IN_PLAYER_JOIN:
                        playerId = UUID.randomUUID();
                        msg.setPlayerId(playerId);

                        IMessage outMsg = MessageFactory.cmTYPE_OUT_YOUR_ID(this.playerId);
                        outMsg.writeToContext(ctx);

                        Logger.log(msg.getPlayerName().concat(" joined. his id is:".concat(playerId.toString())));

                        //get new or existing room
                        r = searchFreeRoom(roomsList);
                        if (r == null) r = addNewRoom();

                        p = new GamePlayer(msg.getPlayerId(), ctx);
                        p.setName(msg.getPlayerName());
                        player = p;
                        r.addPlayer(p);
                        break;

                    case IMessage.TYPE_IN_PLAYER_LOGIN:
                        r = searchRoom(roomsList, msg.getPlayerId());

                        if (r == null) {//room with a player is not found

                            //get new or existing room
                            r = searchFreeRoom(roomsList);
                            if (r == null) r = addNewRoom();

                            p = new GamePlayer(msg.getPlayerId(), ctx);
                            p.setName(msg.getPlayerName());

                            r.addPlayer(p);

                        } else {

                            //player reconnected, update player ctx
                            p = r.getPlayer(msg.getPlayerId());
                            p.setCtx(ctx);
                            //notify others
                            IGameMessage evt = (IGameMessage) MessageFactory.cmTYPE_OUT_PLAYER_ENTERED_ROOM(p.getId(), p.getName());
                            p.getRoom().addEvent(evt);

                            //send session data to client
                            evt = (IGameMessage) MessageFactory.cmTYPE_OUT_GAME_SESSION_DATA(msg.getPlayerId());
                            p.getRoom().addEvent(evt);

                        }

                        player = p;
                        playerId = p.getId();

                        //Logger.log("player is back:" + msg.getPlayerName());
                        break;

                    case IMessage.TYPE_IN_PLAYER_LOGOUT:
                        msg.setPlayerName(player.getName());
                        msg.setPlayerId(player.getId());
                        player.getRoom().addEvent(msg);
                        ctx.close();
                        playerLoggedOut = true;
                        break;

                    case IMessage.TYPE_IN_PLAYER_MOVE:
                        msg.setPlayerId(playerId);
                        player.getRoom().addEvent(msg);
                        break;

                }


            }
        } catch (Exception e) {
            Logger.log("Cl handler: error reading incoming data[" + this.playerId + "]:" + e.getMessage());
        }
        buf.release();
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        cause.printStackTrace();
        ctx.close();
    }

    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        super.channelActive(ctx);
        Logger.log("Connected: " + ctx.channel().remoteAddress());

    }

    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        super.channelInactive(ctx);

        if (playerLoggedOut) return;//logged out

        if (playerId == null) {
            Logger.log("Disconnected: " + ctx.channel().remoteAddress());
        } else {
            Logger.log("player left temporarily: " + " pid=" + playerId);
            player.getRoom().addEvent(MessageFactory.cmTYPE_OUT_PLAYER_LEFT_ROOM_TEMP(playerId));
        }

    }

    private static GameRoom searchRoom(CopyOnWriteArrayList<GameRoom> array, UUID playerId) {
        for (GameRoom r : array) {
            if (r.getPlayer(playerId) != null) {
                return r;
            }
        }
        return null;
    }

    private static GameRoom searchFreeRoom(CopyOnWriteArrayList<GameRoom> array) {
        for (GameRoom r : array) {
            if (!r.isGameIsOver() && !r.isFull() && r.getNumOnlinePlayers()>0) {
                return r;
            }
        }
        return null;
    }

    private GameRoom addNewRoom() {
        GameRoom r = new GameRoom();
        roomsList.add(r);
        return r;
    }
}
