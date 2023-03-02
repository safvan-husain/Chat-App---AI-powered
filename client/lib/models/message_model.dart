class MessageModel {
  //message data model
  String msgtext, sender;
  bool isme, isread;
  DateTime time;
  MessageModel({
    required this.sender,
    required this.isread,
    required this.time,
    required this.isme,
    required this.msgtext,
  });
}
