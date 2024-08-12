import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:group_chat_app/features/user/domain/usecases/get_all_users_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/get_update_user_usecase.dart';
import 'package:group_chat_app/features/user/presentation/cubit/user/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetAllUsersUsecase getAllUsersUsecase;
  final GetUpdateUserUsecase getUpdateUserUsecase;

  UserCubit({
    required this.getAllUsersUsecase,
    required this.getUpdateUserUsecase,
  }) : super(UserInitial());

  Future<void> getUsers({required UserEntity user}) async {
    emit(UserLoading());
    try {
      final streamResponse = getAllUsersUsecase.call(user);
      streamResponse.listen((users) {
        emit(UserLoaded(users: users));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> getUpdateUser({required UserEntity user}) async {
    try {
      getUpdateUserUsecase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
