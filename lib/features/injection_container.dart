import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:group_chat_app/features/group/group_injection_container.dart';
import 'package:group_chat_app/features/storage/storage_injection_container.dart';
import 'package:group_chat_app/features/user/user_injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => firestore);
  sl.registerLazySingleton(() => googleSignIn);
  sl.registerLazySingleton(() => firebaseStorage);

  await userInjectionContainer();
  await storageInjectionContainer();
  await groupInjectionContainer();
}
