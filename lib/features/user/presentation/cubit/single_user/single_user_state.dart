import 'package:equatable/equatable.dart';
import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';

abstract class SingleUserState extends Equatable {
  const SingleUserState();
}

class SingleUserInitial extends SingleUserState {
  @override
  List<Object?> get props => [];
}

class SingleUserLoading extends SingleUserState {
  @override
  List<Object?> get props => [];
}

class SingleUserEmpty extends SingleUserState {
  @override
  List<Object?> get props => [];
}

class SingleUserLoaded extends SingleUserState {
  final UserEntity currentUser;

  const SingleUserLoaded({required this.currentUser});

  @override
  List<Object?> get props => [currentUser];
}

class SingleUserFailure extends SingleUserState {
  @override
  List<Object?> get props => [];
}
