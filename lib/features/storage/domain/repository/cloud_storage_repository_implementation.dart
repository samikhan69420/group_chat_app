import 'dart:io';

import 'package:group_chat_app/features/storage/data/remote_data_source/cloud_storage_remote_data_source.dart';
import 'package:group_chat_app/features/storage/domain/repository/cloud_storage_repository.dart';

class CloudStorageRepositoryImplementation implements CloudStorageRepository {
  final CloudStorageRemoteDataSource remoteDataSource;

  CloudStorageRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<String> uploadGroupImage({required File file}) =>
      remoteDataSource.uploadGrounpImage(file: file);

  @override
  Future<String> uploadProfileImage({required File file}) =>
      remoteDataSource.uploadProfileImage(file: file);
}
