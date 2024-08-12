import 'package:group_chat_app/features/user/domain/repository/user_repository.dart';

class ForgotPasswordUsecase {
  final UserRepository repository;

  ForgotPasswordUsecase({required this.repository});

  Future<void> call(String email) {
    return repository.forgotPassword(email);
  }
}
