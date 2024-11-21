package control;


import data.game.GameRoom;

import java.util.concurrent.CopyOnWriteArrayList;

public class IncomingMessageProcessor implements Runnable {
    private final CopyOnWriteArrayList<GameRoom> rooms;

    public IncomingMessageProcessor(CopyOnWriteArrayList<GameRoom> rooms) {
        this.rooms = rooms;
    }

    @Override
    public void run() {
        Boolean hasMessages = false;

        while (true) {
            for (GameRoom r : rooms) {
                hasMessages = r.processIncomingEvent();
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
