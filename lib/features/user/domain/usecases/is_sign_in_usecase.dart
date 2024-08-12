import 'package:group_chat_app/features/user/domain/repository/user_repository.dart';

class IsSignInUsecase {
  final UserRepository repository;

  IsSignInUsecase({required this.repository});

  Future<bool> call() {
    return repository.isSignIn();
  }
}
