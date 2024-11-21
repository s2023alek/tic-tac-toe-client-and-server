package data.encoders;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelHandlerContext;

public class GameMessageEncoder {

    public static void writeString(ChannelHandlerContext ctx, String s) {
        byte[] sb = s.getBytes();
        ctx.write(Unpooled.buffer(4).writeInt(sb.length));
        //Logger.log("white string l="+sb.length);
        ByteBuf b = Unpooled.copiedBuffer(sb);
        ctx.write(b);
    }
}
