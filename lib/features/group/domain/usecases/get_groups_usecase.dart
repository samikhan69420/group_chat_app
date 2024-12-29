import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:group_chat_app/features/group/domain/repository/group_repository.dart';

class GetGroupsUsecase {
  final GroupRepository repository;

  GetGroupsUsecase({required this.repository});

  Stream<List<GroupEntity>> call() {
    return repository.getGroups();
  }
}
