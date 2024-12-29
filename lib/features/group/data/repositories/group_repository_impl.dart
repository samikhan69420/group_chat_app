import 'package:group_chat_app/features/group/data/remote_data_source/group_remote_data_source.dart';
import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:group_chat_app/features/group/domain/entities/text_message_entity.dart';
import 'package:group_chat_app/features/group/domain/repository/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<void> getCreateGroup(GroupEntity groupEntity) async =>
      remoteDataSource.getCreateGroup(groupEntity);

  @override
  Stream<List<GroupEntity>> getGroups() => remoteDataSource.getGroups();

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) =>
      remoteDataSource.getMessages(channelId);

  @override
  Future<void> sendTextMessage(
          TextMessageEntity textMessageEntity, String channelId) async =>
      remoteDataSource.sendTextMessage(textMessageEntity, channelId);

  @override
  Future<void> updateGroup(GroupEntity groupEntity) async =>
      remoteDataSource.updateGroup(groupEntity);
}
