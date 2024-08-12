import 'package:group_chat_app/features/group/domain/entities/text_message_entity.dart';
import 'package:group_chat_app/features/group/domain/repository/group_repository.dart';

class GetMessagesUsecase {
  final GroupRepository repository;

  GetMessagesUsecase({required this.repository});

  Stream<List<TextMessageEntity>> call(String channelId) {
    return repository.getMessages(channelId);
  }
}
