import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:group_chat_app/features/user/domain/repository/user_repository.dart';

class GetUserFromUidUsecase {
  final UserRepository repository;

  GetUserFromUidUsecase({
    required this.repository,
  });

  Future<UserEntity> call(String uid) {
    return repository.getUserFromUid(uid);
  }
}
