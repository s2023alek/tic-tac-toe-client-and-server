package control;


import data.game.GamePlayer;
import data.game.GameRoom;
import data.msg.IMessage;
import io.netty.channel.ChannelHandlerContext;
import logging.Logger;

import java.util.concurrent.CopyOnWriteArrayList;

public class OutgoingMessageSender implements Runnable {
    private final CopyOnWriteArrayList<GameRoom> rooms;

    public OutgoingMessageSender(CopyOnWriteArrayList<GameRoom> rooms) {
        this.rooms = rooms;
    }

    @Override
    public void run() {
        ChannelHandlerContext ctx;
        IMessage msg;
        IMessage outMsg;
        boolean hasMessages = false;
        CopyOnWriteArrayList<GamePlayer> pl;

        while (true) {

            for (GameRoom r : rooms) {

                msg = r.getOutgoingEvent();

                if (msg != null) {

                    hasMessages = true;
                    pl = r.getPlayersList();
                    for (GamePlayer p : pl) {
                        outMsg = msg;

                        switch (msg.getType()) {

                            case IMessage.TYPE_OUT_PLAYER_JOINED_ROOM:
                            case IMessage.TYPE_OUT_PLAYER_ENTERED_ROOM:
                                //Logger.log("process out joined:");
                                //dont send join event to joined user
                                if (outMsg.getPlayerId().equals(p.getId())) {
                                    //Logger.log("process out joined:DONT SEND");
                                    continue;
                                }
                                break;

                            //Logger.log("process out joined:SEND");
                            case IMessage.TYPE_OUT_GAME_SESSION_DATA:
                                if (!outMsg.getPlayerId().equals(p.getId())) {
                                    //Logger.log("process out session: will send only to just loggedin client");
                                    continue;
                                }
                                break;

                            default:
                                //Logger.log("NET> broadcast msg: type:"+outMsg.getType()+" to player: "+p.getId());
                                break;
                        }
                        outMsg.writeToContext(p.getCtx());

                        try {
                            Thread.sleep(5);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }

                    }

                }

            }
            if (!hasMessages) {
                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }

    }
}
