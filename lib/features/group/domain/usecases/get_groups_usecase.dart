import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:group_chat_app/features/group/domain/repository/group_repository.dart';

class GetGroupsUsecase {
  final GroupRepository repository;

  GetGroupsUsecase({required this.repository});

  Future<List<GroupEntity>> call() async {
    return repository.getGroups();
  }
}
