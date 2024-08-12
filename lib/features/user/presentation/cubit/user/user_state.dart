import 'package:equatable/equatable.dart';
import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';

abstract class UserState extends Equatable {}

class UserInitial extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoaded extends UserState {
  final List<UserEntity> users;

  UserLoaded({
    required this.users,
  });
  @override
  List<Object?> get props => [users];
}

class UserFailure extends UserState {
  @override
  List<Object?> get props => [];
}
