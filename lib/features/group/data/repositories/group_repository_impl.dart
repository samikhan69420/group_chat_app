import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:group_chat_app/features/group/domain/entities/text_message_entity.dart';
import 'package:group_chat_app/features/group/domain/repository/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  @override
  Future<void> getCreateGroup(GroupEntity groupEntity) {
    throw UnimplementedError();
  }

  @override
  Future<List<GroupEntity>> getGroups() {
    throw UnimplementedError();
  }

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendTextMessage(
      TextMessageEntity textMessageEntity, String channelId) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateGroup(GroupEntity groupEntity) {
    throw UnimplementedError();
  }
}
