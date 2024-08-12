import 'dart:io';

import 'package:group_chat_app/features/storage/domain/repository/cloud_storage_repository.dart';

class UploadGroupPhotoUsecase {
  final CloudStorageRepository cloudStorageRepository;

  UploadGroupPhotoUsecase({required this.cloudStorageRepository});

  Future<String> call({required File file}) async {
    return cloudStorageRepository.uploadGroupImage(file: file);
  }
}
