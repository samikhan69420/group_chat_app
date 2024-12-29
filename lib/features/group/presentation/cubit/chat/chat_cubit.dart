import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:group_chat_app/features/group/domain/entities/text_message_entity.dart';
import 'package:group_chat_app/features/group/domain/usecases/get_message_usecase.dart';
import 'package:group_chat_app/features/group/domain/usecases/send_message_usecase.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendTextMessageUsecase sendTextMessageUsecase;
  final GetMessagesUsecase getMessagesUsecase;

  ChatCubit({
    required this.sendTextMessageUsecase,
    required this.getMessagesUsecase,
  }) : super(ChatInitial());

  Future<void> getMessages({required String channelId}) async {
    emit(ChatLoading());
    try {
      final streamResponse = getMessagesUsecase.call(channelId);
      streamResponse.listen(
        (message) => emit(
          ChatLoaded(messages: message),
        ),
      );
    } on SocketException catch (_) {
      emit(ChatFailure());
    } catch (_) {
      emit(ChatFailure());
    }
  }

  Future<void> sendTextMessage(
      {required TextMessageEntity textMessageEntity,
      required String channelId}) async {
    try {
      await sendTextMessageUsecase.call(textMessageEntity, channelId);
    } on SocketException catch (_) {
      emit(ChatFailure());
    } catch (_) {
      emit(ChatFailure());
    }
  }
}
