package data.game;

import io.netty.channel.ChannelHandlerContext;

import java.util.UUID;

public class GamePlayer {

    public GamePlayer(UUID id, ChannelHandlerContext ctx) {
        this.id = id;
        this.ctx = ctx;
        isOnline=true;
    }

    public UUID getId() {
        return id;
    }

    public void setCtx(ChannelHandlerContext ctx) {
        this.ctx = ctx;
    }

    public void setName(String name) {
        this.name = name;
    }
    public GameRoom getRoom() {
        return room;
    }

    public String getName() {
        return name;
    }

    public void setRoom(GameRoom room) {
        this.room = room;
    }
    public ChannelHandlerContext getCtx() {
        return ctx;
    }


    public int getMarkSN() {return markSN;}

    public void setMarkSN(int markSN) {this.markSN = markSN;}

    public boolean isOnline() {return isOnline;}

    public void setOnline(boolean online) {isOnline = online;}

    private boolean isOnline;

    private final UUID id;

    private int markSN;
    private GameRoom room;


    private String name="no name";


    private ChannelHandlerContext ctx;
}
