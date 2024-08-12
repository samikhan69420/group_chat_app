import 'package:group_chat_app/features/user/domain/repository/user_repository.dart';

class SignOutUsecase {
  final UserRepository repository;

  SignOutUsecase({required this.repository});

  Future<void> call() {
    return repository.signOut();
  }
}
