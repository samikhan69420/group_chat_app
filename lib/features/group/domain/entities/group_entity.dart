import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupEntity extends Equatable {
  final String? groupName;
  final String? groupProfileImage;
  final Timestamp? timestamp;
  final String? groupId;
  final String? uid;
  final String? lastMessage;

  const GroupEntity({
    this.groupName,
    this.groupProfileImage,
    this.timestamp,
    this.groupId,
    this.uid,
    this.lastMessage,
  });

  @override
  List<Object?> get props => [
        groupName,
        groupProfileImage,
        timestamp,
        groupId,
        uid,
        lastMessage,
      ];
}
