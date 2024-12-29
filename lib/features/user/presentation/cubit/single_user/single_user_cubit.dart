import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:group_chat_app/features/user/domain/usecases/get_single_user_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/get_user_from_uid.dart';
import 'package:group_chat_app/features/user/presentation/cubit/single_user/single_user_state.dart';

class SingleUserCubit extends Cubit<SingleUserState> {
  final GetSingleUserUsecase getSingleUserUsecase;
  final GetUserFromUidUsecase getUserFromUidUsecase;

  SingleUserCubit({
    required this.getSingleUserUsecase,
    required this.getUserFromUidUsecase,
  }) : super(SingleUserInitial());

  Future<void> getSingleUserProfile({required UserEntity user}) async {
    emit(SingleUserLoading());
    try {
      final streamResponse = getSingleUserUsecase.call(user);
      streamResponse.listen((user) {
        emit(SingleUserLoaded(currentUser: user.first));
      });
    } on SocketException catch (_) {
      emit(SingleUserFailure());
    } catch (_) {
      emit(SingleUserFailure());
    }
  }
}
