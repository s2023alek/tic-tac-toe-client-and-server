import control.ClientHandler;
import control.IncomingMessageProcessor;
import control.OutgoingMessageSender;
import data.game.GameRoom;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import logging.Logger;

import java.util.concurrent.CopyOnWriteArrayList;

public class Main {
    private static final int PORT = 8003;
    private static final CopyOnWriteArrayList<GameRoom> rooms = new CopyOnWriteArrayList<>();



    public static void main(String[] args) throws InterruptedException {
        Logger.log("app started");

        //flash network security policy
        prepareFlashPolicyResponder();

        // game network
        new Thread(new IncomingMessageProcessor(rooms)).start();
        new Thread(new OutgoingMessageSender(rooms)).start();

        //netty
        startNettyServer();

    }

    private static void startNettyServer() throws InterruptedException {
        EventLoopGroup bossGroup = new NioEventLoopGroup();
        EventLoopGroup workerGroup = new NioEventLoopGroup();


        ServerBootstrap b = new ServerBootstrap();

        b.group(bossGroup, workerGroup)
                .channel(NioServerSocketChannel.class)
                .childHandler(new ChannelInitializer<SocketChannel>() {
                    @Override
                    public void initChannel(SocketChannel ch) {
                        ChannelPipeline p = ch.pipeline();
                        p.addLast(new ClientHandler(rooms));
                    }
                });

        ChannelFuture future = b.bind(PORT).sync();

        future.addListener(evt -> Logger.log("server is started, port:" + PORT));
        future.addListener(evt -> Logger.log("SERVER IS READY"));

        future.channel().closeFuture().addListener((evt) -> {
            Logger.log("Server is stopping");
            bossGroup.shutdownGracefully();
            workerGroup.shutdownGracefully();
        }).sync();
    }

    private static void prepareFlashPolicyResponder(){
        new Thread(new PolicyServer()).start();
    }
}





