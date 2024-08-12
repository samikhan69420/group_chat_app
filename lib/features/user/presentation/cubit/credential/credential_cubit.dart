import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:group_chat_app/features/user/domain/usecases/forgot_password_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/google_auth_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/sign_in_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/sign_up_usecase.dart';
import 'package:group_chat_app/features/user/presentation/cubit/credential/credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignUpUsecase signUpUsecase;
  final SignInUseCase signInUsecase;
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final GoogleAuthUsecase googleAuthUsecase;

  CredentialCubit({
    required this.signUpUsecase,
    required this.signInUsecase,
    required this.forgotPasswordUsecase,
    required this.googleAuthUsecase,
  }) : super(CredentialInitial());

  Future<void> forgotPassword(String email) async {
    try {
      forgotPasswordUsecase.call(email);
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> submitSignIn({
    required String email,
    required String password,
  }) async {
    emit(CredentialLoading());
    try {
      await signInUsecase.call(UserEntity(
        email: email,
        password: password,
      ));
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> submitSignUp(UserEntity user) async {
    emit(CredentialLoading());
    try {
      await signUpUsecase.call(user);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> submitGoogleAuth() async {
    emit(CredentialLoading());
    try {
      await googleAuthUsecase.call();
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }
}
