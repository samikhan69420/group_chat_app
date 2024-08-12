import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:group_chat_app/features/user/domain/repository/user_repository.dart';

class GetUpdateUserUsecase {
  final UserRepository repository;

  GetUpdateUserUsecase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.getUpdateUser(user);
  }
}
