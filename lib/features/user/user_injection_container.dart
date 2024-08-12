import 'package:group_chat_app/features/injection_container.dart';
import 'package:group_chat_app/features/user/data/remote_data_source/user_remote_data_source.dart';
import 'package:group_chat_app/features/user/data/remote_data_source/user_remote_data_source_impl.dart';
import 'package:group_chat_app/features/user/data/repository/user_repository_implementation.dart';
import 'package:group_chat_app/features/user/domain/repository/user_repository.dart';
import 'package:group_chat_app/features/user/domain/usecases/forgot_password_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/get_all_users_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/get_create_current_user_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/get_current_uid_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/get_single_user_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/get_update_user_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/get_user_from_uid.dart';
import 'package:group_chat_app/features/user/domain/usecases/google_auth_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/is_sign_in_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/sign_in_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/sign_out_usecase.dart';
import 'package:group_chat_app/features/user/domain/usecases/sign_up_usecase.dart';
import 'package:group_chat_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/single_user/single_user_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/user/user_cubit.dart';

Future<void> userInjectionContainer() async {
  // Cubit

  sl.registerFactory(
    () => AuthCubit(
      isSignInUsecase: sl.call(),
      signOutUsecase: sl.call(),
      getCurrentUidUsecase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => UserCubit(
      getAllUsersUsecase: sl.call(),
      getUpdateUserUsecase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => SingleUserCubit(
      getSingleUserUsecase: sl.call(),
      getUserFromUidUsecase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CredentialCubit(
        signUpUsecase: sl.call(),
        signInUsecase: sl.call(),
        forgotPasswordUsecase: sl.call(),
        googleAuthUsecase: sl.call()),
  );

  // Use Cases
  sl.registerLazySingleton<ForgotPasswordUsecase>(
    () => ForgotPasswordUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<GetAllUsersUsecase>(
    () => GetAllUsersUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<GetCreateCurrentUserUsecase>(
    () => GetCreateCurrentUserUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<GetCurrentUidUsecase>(
    () => GetCurrentUidUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<GetSingleUserUsecase>(
    () => GetSingleUserUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<GetUpdateUserUsecase>(
    () => GetUpdateUserUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<GoogleAuthUsecase>(
    () => GoogleAuthUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<IsSignInUsecase>(
    () => IsSignInUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton<SignOutUsecase>(
    () => SignOutUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<SignUpUsecase>(
    () => SignUpUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<GetUserFromUidUsecase>(
    () => GetUserFromUidUsecase(repository: sl.call()),
  );

  // Repository

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImplementation(
      remoteDataSource: sl.call(),
    ),
  );

  // Remote Data Source

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImplementation(
      firestore: sl.call(),
      firebaseAuth: sl.call(),
      googleSignIn: sl.call(),
    ),
  );
}
