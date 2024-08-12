import 'package:group_chat_app/features/user/domain/repository/user_repository.dart';

class GoogleAuthUsecase {
  final UserRepository repository;

  GoogleAuthUsecase({
    required this.repository,
  });

  Future<void> call() {
    return repository.googleAuth();
  }
}
