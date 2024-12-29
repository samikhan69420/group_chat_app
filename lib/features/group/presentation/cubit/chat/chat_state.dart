part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

final class ChatInitial extends ChatState {
  @override
  List<Object?> get props => [];
}

final class ChatLoading extends ChatState {
  @override
  List<Object?> get props => [];
}

final class ChatLoaded extends ChatState {
  final List<TextMessageEntity> messages;

  const ChatLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

final class ChatFailure extends ChatState {
  @override
  List<Object?> get props => [];
}
