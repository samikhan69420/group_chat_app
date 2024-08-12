import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:group_chat_app/features/group/domain/entities/text_message_entity.dart';

abstract class GroupRepository {
  Future<void> getCreateGroup(GroupEntity groupEntity);
  Future<void> updateGroup(GroupEntity groupEntity);
  Future<List<GroupEntity>> getGroups();
  Future<void> sendTextMessage(
      TextMessageEntity textMessageEntity, String channelId);
  Stream<List<TextMessageEntity>> getMessages(String channelId);
}
