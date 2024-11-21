import logging.Logger;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class PolicyServer implements Runnable {

    @Override
    public void run() {

        int port = 843;
        try {
            ServerSocket serverSocket = new ServerSocket(port);
            Logger.log("policy server started on port " + port);

            while (true) {
                Socket socket = serverSocket.accept();
                Logger.log("policy server: client connected: " + socket.getInetAddress());
                handleClient(socket);

                // Close socket
                socket.close();
            }
        } catch (IOException e) {
            Logger.log("policy server: ioexception:");
            e.printStackTrace();
        }
    }

    private static void handleClient(Socket socket) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));

        String request = reader.readLine();
        Logger.log("received policy request: " + request);

        if (request.contains("crossdomain.xml") || request.contains("<policy-file-request/>")) {
            serveCrossdomainXml(writer);
        }

        reader.close();
        writer.close();
    }

    private static void serveCrossdomainXml(BufferedWriter writer) throws IOException {
        writer.write("HTTP/1.1 200 OK");
        writer.newLine();
        writer.write("Content-Type: text/xml");
        writer.newLine();
        writer.newLine();

        writer.write("<?xml version=\"1.0\"?>");
        writer.newLine();
        writer.write("<!DOCTYPE cross-domain-policy SYSTEM \"/xml/dtds/cross-domain-policy.dtd\">");
        writer.newLine();
        writer.write("<cross-domain-policy>");
        writer.newLine();
        writer.write("<!-- This is a master-policy file -->");
        writer.newLine();
        writer.write("<site-control permitted-cross-domain-policies=\"master-only\"/>");
        writer.newLine();
        writer.write("<allow-access-from domain=\"localhost\" to-ports=\"8003\" />");
        writer.newLine();
        writer.write("</cross-domain-policy>");
        writer.newLine();

        writer.flush();
    }
}