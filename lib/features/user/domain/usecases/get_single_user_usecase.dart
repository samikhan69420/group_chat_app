import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:group_chat_app/features/user/domain/repository/user_repository.dart';

class GetSingleUserUsecase {
  final UserRepository repository;

  GetSingleUserUsecase({required this.repository});

  Stream<List<UserEntity>> call(UserEntity user) {
    return repository.getSingleUser(user);
  }
}
