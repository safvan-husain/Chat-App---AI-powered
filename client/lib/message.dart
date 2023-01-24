import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:io';
// import 'package:web_socket_channel';
import 'package:web_socket_channel/web_socket_channel.dart';

getMessagesFriend() async {
  var locDb = await openDatabase('messages.db'); // Define database
  List<Map> messages = await locDb.query("chats"); // Open Table

  var getMessages = messages.map((i) {
    return i["msg"];
  });
  var getMessagesSended = messages.map((i) {
    return i["sended"];
  });
  locDb.close();
  return Container(
    child: ListView(
      children: List.generate(
        messages.length, // Get lenght of messages in table
        (index) => Row(
          children: [
            getMessagesSended.toList()[index] == 'true'
                ? Spacer()
                : Container(height: 0, width: 0),
            getMessagesSended.toList()[index] == 'true'
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 8, 0),
                    child: Container(
                      constraints: BoxConstraints(minWidth: 5, maxWidth: 300),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "${getMessages.toList()[index]}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(color: Colors.green),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                    child: Container(
                      constraints: BoxConstraints(minWidth: 5, maxWidth: 300),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "${getMessages.toList()[index]}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    ),
  );
}

late IOWebSocketChannel channel;

// Function to add messages.
sendChat(msg) async {
  var userID = '222'; // Change this to send a message to another person.
  var locDb = await openDatabase('messages.db'); // Define database
  try {
    channel = IOWebSocketChannel.connect("ws://localhost:3000/sendmsg");
  } catch (e) {
    print("Error on connecting to websocket: " + e.toString());
  }
  // We will send this json message to the server
  String data =
      "{'auth':'chatappauthkey231r4','cmd':'send','msg':'$msg','userid':'$userID'}";
  channel.sink.add(data);
  channel.sink.close();
  // Create this table if it doesn't exists
  await locDb
      .execute('CREATE TABLE IF NOT EXISTS chats (msg TEXT, sended TEXT)');
  // Insert message to table
  await locDb
      .rawInsert('INSERT INTO chats(msg, sended) VALUES("$msg", "true")');
  // Close database
  await locDb.close();
}
