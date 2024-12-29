import 'package:group_chat_app/features/group/data/remote_data_source/group_remote_data_souce_impl.dart';
import 'package:group_chat_app/features/group/data/remote_data_source/group_remote_data_source.dart';
import 'package:group_chat_app/features/group/data/repositories/group_repository_impl.dart';
import 'package:group_chat_app/features/group/domain/repository/group_repository.dart';
import 'package:group_chat_app/features/group/domain/usecases/get_create_group_usecase.dart';
import 'package:group_chat_app/features/group/domain/usecases/get_groups_usecase.dart';
import 'package:group_chat_app/features/group/domain/usecases/get_message_usecase.dart';
import 'package:group_chat_app/features/group/domain/usecases/send_message_usecase.dart';
import 'package:group_chat_app/features/group/domain/usecases/update_group_usecase.dart';
import 'package:group_chat_app/features/group/presentation/cubit/chat/chat_cubit.dart';
import 'package:group_chat_app/features/group/presentation/cubit/group/group_cubit.dart';
import 'package:group_chat_app/features/injection_container.dart';

Future<void> groupInjectionContainer() async {
  // Cubit

  sl.registerFactory<GroupCubit>(
    () => GroupCubit(
      getCreateGroupUsecase: sl.call(),
      getGroupsUsecase: sl.call(),
      updateGroupUsecase: sl.call(),
    ),
  );

  sl.registerFactory<ChatCubit>(
    () => ChatCubit(
      sendTextMessageUsecase: sl.call(),
      getMessagesUsecase: sl.call(),
    ),
  );

  // Usecases

  sl.registerLazySingleton<GetCreateGroupUsecase>(
    () => GetCreateGroupUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<GetGroupsUsecase>(
    () => GetGroupsUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<UpdateGroupUsecase>(
    () => UpdateGroupUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<GetMessagesUsecase>(
    () => GetMessagesUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<SendTextMessageUsecase>(
    () => SendTextMessageUsecase(repository: sl.call()),
  );

  // Repository

  sl.registerLazySingleton<GroupRepository>(
    () => GroupRepositoryImpl(remoteDataSource: sl.call()),
  );
  sl.registerLazySingleton<GroupRemoteDataSource>(
    () => GroupRemoteDataSourceImpl(firestore: sl.call()),
  );
}
