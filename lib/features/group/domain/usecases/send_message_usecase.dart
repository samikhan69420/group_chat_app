import 'package:group_chat_app/features/group/domain/entities/text_message_entity.dart';
import 'package:group_chat_app/features/group/domain/repository/group_repository.dart';

class SendTextMessageUsecase {
  final GroupRepository repository;

  SendTextMessageUsecase({required this.repository});

  Future<void> call(
      TextMessageEntity textMessageEntity, String channelId) async {
    repository.sendTextMessage(textMessageEntity, channelId);
  }
}
