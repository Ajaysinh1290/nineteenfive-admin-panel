class ChatData {
  late String chatId;
  late String message;
  late DateTime messageDateTime;
  late bool isSeenByReceiver;
  late bool isSendByUser;

  ChatData(
      {required this.chatId,
      required this.message,
      required this.messageDateTime,
      required this.isSeenByReceiver,
      required this.isSendByUser});

  ChatData.fromJson(Map<String,dynamic> data) {
    this.chatId = data['chat_id'];
    this.message = data['message'];
    this.messageDateTime = data['message_date_time']?.toDate();
    this.isSeenByReceiver = data['is_seen_by_receiver'];
    this.isSendByUser = data['is_send_by_user'];
  }

  Map<String,dynamic> toJson() {
    return  {
      "chat_id" : this.chatId,
      "message" : this.message,
      "message_date_time" : this.messageDateTime,
      "is_send_by_user" : this.isSendByUser,
      "is_seen_by_receiver" : this.isSeenByReceiver
    };
  }
}
