part of 'group_cubit.dart';

sealed class GroupState extends Equatable {
  const GroupState();
}

final class GroupInitial extends GroupState {
  @override
  List<Object?> get props => [];
}

final class GroupLoading extends GroupState {
  @override
  List<Object?> get props => [];
}

final class GroupLoaded extends GroupState {
  final List<GroupEntity> groups;

  const GroupLoaded({required this.groups});

  @override
  List<Object?> get props => [groups];
}

final class GroupFailure extends GroupState {
  @override
  List<Object?> get props => [];
}
