import 'dart:io';

import 'package:group_chat_app/features/storage/domain/repository/cloud_storage_repository.dart';

class UploadProfileUsecase {
  final CloudStorageRepository cloudStorageRepository;

  UploadProfileUsecase({required this.cloudStorageRepository});

  Future<String> call({required File file}) async {
    return cloudStorageRepository.uploadProfileImage(file: file);
  }
}
