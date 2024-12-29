import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:group_chat_app/features/group/domain/entities/group_entity.dart';
import 'package:group_chat_app/features/group/domain/usecases/get_create_group_usecase.dart';
import 'package:group_chat_app/features/group/domain/usecases/get_groups_usecase.dart';
import 'package:group_chat_app/features/group/domain/usecases/update_group_usecase.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final GetCreateGroupUsecase getCreateGroupUsecase;
  final GetGroupsUsecase getGroupsUsecase;
  final UpdateGroupUsecase updateGroupUsecase;

  GroupCubit({
    required this.getCreateGroupUsecase,
    required this.getGroupsUsecase,
    required this.updateGroupUsecase,
  }) : super(GroupInitial());

  Future<void> getGroups() async {
    emit(GroupLoading());
    try {
      final streamResponse = getGroupsUsecase.call();
      streamResponse.listen(
        (groups) => emit(GroupLoaded(groups: groups)),
      );
    } on SocketException catch (_) {
      emit(GroupFailure());
    } catch (_) {
      emit(GroupFailure());
    }
  }

  Future<void> getCreateGroup({required GroupEntity groupEntity}) async {
    emit(GroupLoading());
    try {
      getCreateGroupUsecase.call(groupEntity);
    } on SocketException catch (_) {
      emit(GroupFailure());
    } catch (_) {
      emit(GroupFailure());
    }
  }

  Future<void> updateGroup({required GroupEntity groupEntity}) async {
    try {
      await updateGroupUsecase.call(groupEntity);
    } on SocketException catch (_) {
      emit(GroupFailure());
    } catch (_) {
      emit(GroupFailure());
    }
  }
}
