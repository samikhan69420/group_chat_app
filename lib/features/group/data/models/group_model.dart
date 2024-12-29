import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    super.groupName,
    super.groupProfileImage,
    super.createdAt,
    super.groupId,
    super.uid,
    super.lastMessage,
  });

  factory GroupModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return GroupModel(
      groupName: documentSnapshot.get('groupName'),
      groupProfileImage: documentSnapshot.get('groupProfileImage'),
      createdAt: documentSnapshot.get('createdAt'),
      groupId: documentSnapshot.get('groupId'),
      uid: documentSnapshot.get('uid'),
      lastMessage: documentSnapshot.get('lastMessage'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "groupName": groupName,
      "groupProfileImage": groupProfileImage,
      "createdAt": createdAt,
      "groupId": groupId,
      "uid": uid,
      "lastMessage": lastMessage,
    };
  }
}
