package data.parsers;

import data.msg.IMessage;
import io.netty.buffer.ByteBuf;
import logging.Logger;

import java.nio.charset.StandardCharsets;

public class GameMessageParser {

    public static String parseString(ByteBuf byteBuf) {
        try {
            /*
            int strLength = byteBuf.readInt();
            byte[] strBytesRead = new byte[strLength];
            Logger.log("byteBuf.readBytes(strBytesRead); len:"+strLength);
            byteBuf.readBytes(strBytesRead);
            String s = new String(strBytesRead, StandardCharsets.UTF_8);
            Logger.log("string read:\""+s+"\" len:"+s.length());
            return s;
            */

            int strLength = byteBuf.readInt();

            CharSequence cs = byteBuf.readCharSequence(strLength, StandardCharsets.UTF_8);
            //String s = cs.toString().substring(2);
            //Logger.log("string read:\""+s+"\" len:"+s.length());
            return cs.toString().substring(2);
        } catch (Exception e) {
            Logger.log("GameMessageParser> failed to parse string"+e.getMessage());
            return "failed to parse";
        }

    }

}
