import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:group_chat_app/features/group/domain/repository/group_repository.dart';

class GetCreateGroupUsecase {
  final GroupRepository repository;

  GetCreateGroupUsecase({required this.repository});

  Future<void> call(GroupEntity groupEntity) async {
    repository.getCreateGroup(groupEntity);
  }
}
