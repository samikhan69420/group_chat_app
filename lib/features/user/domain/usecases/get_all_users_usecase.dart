import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:group_chat_app/features/user/domain/repository/user_repository.dart';

class GetAllUsersUsecase {
  final UserRepository repository;

  GetAllUsersUsecase({required this.repository});

  Stream<List<UserEntity>> call(UserEntity user) {
    return repository.getAllUsers(user);
  }
}
