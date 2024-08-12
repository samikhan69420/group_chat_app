import 'package:group_chat_app/features/user/domain/repository/user_repository.dart';

class GetCurrentUidUsecase {
  final UserRepository repository;

  GetCurrentUidUsecase({required this.repository});

  Future<String> call() {
    return repository.getCurrentUid();
  }
}
