import 'package:group_chat_app/features/injection_container.dart';
import 'package:group_chat_app/features/storage/data/remote_data_source/cloud_storage_remote_data_source.dart';
import 'package:group_chat_app/features/storage/data/remote_data_source/cloud_storage_remote_data_source_implementation.dart';
import 'package:group_chat_app/features/storage/domain/usecases/upload_group_photo_usecase.dart';
import 'package:group_chat_app/features/storage/domain/usecases/upload_profile_photo_usecase.dart';
import 'package:group_chat_app/features/storage/domain/repository/cloud_storage_repository.dart';
import 'package:group_chat_app/features/storage/domain/repository/cloud_storage_repository_implementation.dart';

Future<void> storageInjectionContainer() async {
  sl.registerLazySingleton<UploadProfileUsecase>(
    () => UploadProfileUsecase(cloudStorageRepository: sl.call()),
  );
  sl.registerLazySingleton<UploadGroupPhotoUsecase>(
    () => UploadGroupPhotoUsecase(cloudStorageRepository: sl.call()),
  );

  sl.registerLazySingleton<CloudStorageRepository>(
    () => CloudStorageRepositoryImplementation(remoteDataSource: sl.call()),
  );
  sl.registerLazySingleton<CloudStorageRemoteDataSource>(
    () =>
        CloudStorageRemoteDataSourceImplementation(firebaseStorage: sl.call()),
  );
}
