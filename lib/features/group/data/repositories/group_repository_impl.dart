import 'package:group_chat_app/features/group/data/models/group_model.dart';
import 'package:group_chat_app/features/group/data/models/text_message_model.dart';
import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:group_chat_app/features/group/domain/entities/text_message_entity.dart';
import 'package:group_chat_app/features/group/domain/repository/group_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupRepositoryImpl implements GroupRepository {
  final FirebaseFirestore firebaseFirestore;

  GroupRepositoryImpl({required this.firebaseFirestore});

  @override
  Future<void> getCreateGroup(GroupEntity groupEntity) async {
    final groupCollection = firebaseFirestore.collection("groups");

    final groupId = groupCollection.doc().id;

    groupCollection.doc(groupId).get().then(
      (groupSnapshot) async {
        final newGroup = GroupModel(
          uid: groupEntity.uid,
          createdAt: groupEntity.createdAt,
          groupId: groupEntity.groupId,
          groupName: groupEntity.groupName,
          groupProfileImage: groupEntity.groupProfileImage,
          lastMessage: groupEntity.lastMessage,
        );
        if (!(groupSnapshot.exists)) {
          await groupCollection.doc(groupId).set(newGroup.toDocument());
          return groupCollection
              .orderBy("createdAt", descending: true)
              .snapshots()
              .map(
            (querySnapshot) {
              querySnapshot.docs.map(
                (e) => GroupModel.fromSnapshot(e),
              );
            },
          );
        }
      },
    );
  }

  @override
  Future<List<GroupEntity>> getGroups() {
    throw UnimplementedError();
  }

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    final messageCollection = firebaseFirestore
        .collection("messages")
        .doc(channelId)
        .collection("messages");

    return messageCollection.orderBy('time').snapshots().map(
          (querySnap) => querySnap.docs
              .map(
                (queryDoc) => TextMessageModel.fromSnapshot(queryDoc),
              )
              .toList(),
        );
  }

  @override
  Future<void> sendTextMessage(
      TextMessageEntity textMessageEntity, String channelId) async {
    final messageCollection = firebaseFirestore
        .collection("messages")
        .doc(channelId)
        .collection("messages");

    final messageId = messageCollection.doc().id;

    final newTextMessage = TextMessageModel(
      content: textMessageEntity.content,
      messageId: textMessageEntity.messageId,
      receiverName: textMessageEntity.receiverName,
      recipientId: textMessageEntity.recipientId,
      senderId: textMessageEntity.senderId,
      senderName: textMessageEntity.content,
      time: textMessageEntity.time,
      type: "TEXT",
    ).toDocument();

    messageCollection.doc(messageId).set(newTextMessage);
  }

  @override
  Future<void> updateGroup(GroupEntity groupEntity) async {
    Map<String, dynamic> groupInformation = {};

    final groupCollection = firebaseFirestore.collection("groups");

    if (groupEntity.groupProfileImage != null &&
        groupEntity.groupProfileImage != "") {
      groupInformation['groupProfileImage'] = groupEntity.groupProfileImage;
    }
    if (groupEntity.groupName != null && groupEntity.groupName != "") {
      groupInformation['groupName'] = groupEntity.groupName;
    }
    if (groupEntity.lastMessage != null && groupEntity.lastMessage != "") {
      groupInformation['lastMessage'] = groupEntity.lastMessage;
    }
    groupCollection.doc(groupEntity.groupId).update(groupInformation);
  }
}
