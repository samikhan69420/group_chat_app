import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_app/features/user/domain/usecases/get_current_uid_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/is_sign_in_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/sign_out_usecase.dart';
import 'package:group_chat_app/features/user/presentation/cubit/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsSignInUsecase isSignInUsecase;
  final SignOutUsecase signOutUsecase;
  final GetCurrentUidUsecase getCurrentUidUsecase;

  AuthCubit(
      {required this.isSignInUsecase,
      required this.signOutUsecase,
      required this.getCurrentUidUsecase})
      : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      final isSignIn = await isSignInUsecase.call();
      if (isSignIn == true) {
        final uid = await getCurrentUidUsecase.call();
        emit(Authenticated(uid: uid));
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> loggedIn() async {
    final uid = await getCurrentUidUsecase.call();
    try {
      emit(Authenticated(uid: uid));
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> logOut() async {
    try {
      signOutUsecase.call();
      emit(Unauthenticated());
    } catch (_) {
      emit(Unauthenticated());
    }
  }
}
