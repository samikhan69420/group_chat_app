import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:group_chat_app/features/storage/data/remote_data_source/cloud_storage_remote_data_source.dart';

class CloudStorageRemoteDataSourceImplementation
    implements CloudStorageRemoteDataSource {
  final FirebaseStorage firebaseStorage;

  CloudStorageRemoteDataSourceImplementation({required this.firebaseStorage});

  @override
  Future<String> uploadGrounpImage({required File file}) async {
    final ref = firebaseStorage.ref().child(
          "groups/${DateTime.now().millisecondsSinceEpoch}${getNameOnly(file.path)}",
        );
    final uploadTask = ref.putFile(file);

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return imageUrl;
  }

  @override
  Future<String> uploadProfileImage({required File file}) async {
    final ref = firebaseStorage.ref().child(
          "profiles/${DateTime.now().millisecondsSinceEpoch}${getNameOnly(file.path)}",
        );
    final uploadTask = ref.putFile(file);

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return imageUrl;
  }

  static String getNameOnly(String path) {
    return path.split("/").last.split("/").last.split("/").first;
  }
}
