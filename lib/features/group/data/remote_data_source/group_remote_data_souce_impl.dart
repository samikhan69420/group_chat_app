import 'package:group_chat_app/features/group/data/models/group_model.dart';
import 'package:group_chat_app/features/group/data/models/text_message_model.dart';
import 'package:group_chat_app/features/group/data/remote_data_source/group_remote_data_source.dart';
import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_chat_app/features/group/domain/entities/text_message_entity.dart';

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final FirebaseFirestore firestore;

  GroupRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> getCreateGroup(GroupEntity groupEntity) async {
    final groupCollection = firestore.collection('groups');
    final groupId = groupCollection.doc().id;
    groupCollection.doc(groupId).get().then(
      (groupSnapshot) async {
        final newGroup = GroupModel(
          uid: groupEntity.uid,
          createdAt: groupEntity.createdAt,
          groupId: groupId,
          groupName: groupEntity.groupName,
          groupProfileImage: groupEntity.groupProfileImage,
          lastMessage: groupEntity.lastMessage,
        ).toDocument();

        if (!(groupSnapshot.exists)) {
          await groupCollection.doc(groupId).set(newGroup);
        }
      },
    );
  }

  @override
  Stream<List<GroupEntity>> getGroups() {
    final groupsCollection = firestore.collection('groups');
    return groupsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (e) => GroupModel.fromSnapshot(e),
              )
              .toList(),
        );
  }

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    final messageCollection = firestore
        .collection("groupChatChannel")
        .doc(channelId)
        .collection("messages");
    return messageCollection.orderBy('time').snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (queryDoc) => TextMessageModel.fromSnapshot(queryDoc),
              )
              .toList(),
        );
  }

  @override
  Future<void> sendTextMessage(
      TextMessageEntity textMessageEntity, String channelId) async {
    final messagesCollection = firestore
        .collection("groupChatChannel")
        .doc(channelId)
        .collection("messages");

    final messageId = messagesCollection.doc().id;

    final newTextMessage = TextMessageModel(
            content: textMessageEntity.content,
            senderName: textMessageEntity.senderName,
            senderId: textMessageEntity.senderId,
            recipientId: textMessageEntity.recipientId,
            receiverName: textMessageEntity.receiverName,
            time: textMessageEntity.time,
            messageId: messageId,
            type: "TEXT")
        .toDocument();

    await messagesCollection.doc(messageId).set(newTextMessage);
  }

  @override
  Future<void> updateGroup(GroupEntity groupEntity) async {
    final groupCollection = firestore.collection("groups");
    Map<String, dynamic> groupInformation = {
      "lastMessage": groupEntity.lastMessage,
    };
    groupCollection.doc(groupEntity.groupId).update(groupInformation);
  }
}
