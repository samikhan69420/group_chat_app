import 'package:group_chat_app/features/group/domain/entities/text_message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextMessageModel extends TextMessageEntity {
  const TextMessageModel({
    super.recipientId,
    super.senderId,
    super.senderName,
    super.type,
    super.time,
    super.content,
    super.receiverName,
    super.messageId,
  });

  factory TextMessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    return TextMessageModel(
      recipientId: snapshot.get('recipientId'),
      senderId: snapshot.get('senderId'),
      senderName: snapshot.get('senderName'),
      type: snapshot.get('type'),
      time: snapshot.get('time'),
      content: snapshot.get('content'),
      receiverName: snapshot.get('receiverName'),
      messageId: snapshot.get('messageId'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "recipientId": recipientId,
      "senderId": senderId,
      "senderName": senderName,
      "type": type,
      "time": time,
      "content": content,
      "receiverName": receiverName,
      "messageId": messageId,
    };
  }
}
