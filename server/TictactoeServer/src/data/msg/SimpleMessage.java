package data.msg;

import io.netty.channel.ChannelHandlerContext;

import java.util.UUID;

public class SimpleMessage implements IMessage {

    public SimpleMessage(int type, UUID playerId) {
        this.playerId = playerId;
        this.type = type;
    }


    public Boolean writeToContext(ChannelHandlerContext ctx) {
        return false;
    }


    public int getType() {
        return type;
    }

    public UUID getPlayerId() {
        return playerId;
    }

    public void setPlayerId(UUID id) {
        this.playerId = id;
    }

    public UUID getCurrentTurnPlayerId() { return currentTurnPlayerId; }

    public UUID getMark1PlayerId() { return mark1PlayerId; }

    public void setCurrentTurnPlayerId(UUID currentTurnPlayerId) {this.currentTurnPlayerId = currentTurnPlayerId;}

    public void setMark1PlayerId(UUID mark1PlayerId) {this.mark1PlayerId = mark1PlayerId;}

    protected UUID mark1PlayerId;

    protected UUID currentTurnPlayerId;

    protected UUID playerId;
    protected final int type;



    @Override
    public String toString() {
        return "SimpleMessage{" +
                "id=" + playerId +
                ", type=" + type +
                '}';
    }
}