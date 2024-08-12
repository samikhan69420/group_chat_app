import 'package:group_chat_app/features/user/data/remote_data_source/user_remote_data_source.dart';
import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:group_chat_app/features/user/domain/repository/user_repository.dart';

class UserRepositoryImplementation implements UserRepository {
  UserRemoteDataSource remoteDataSource;

  UserRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<void> forgotPassword(String email) async =>
      remoteDataSource.forgotPassword(email);

  @override
  Stream<List<UserEntity>> getAllUsers(UserEntity user) =>
      remoteDataSource.getAllUsers(user);

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async =>
      remoteDataSource.getCreateCurrentUser(user);

  @override
  Future<String> getCurrentUid() async => remoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleUser(UserEntity user) =>
      remoteDataSource.getSingleUser(user);

  @override
  Future<void> getUpdateUser(UserEntity user) async =>
      remoteDataSource.getUpdateUser(user);

  @override
  Future<void> googleAuth() async => remoteDataSource.googleAuth();

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> signIn(UserEntity user) async => remoteDataSource.signIn(user);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> signUp(UserEntity user) async => remoteDataSource.signUp(user);

  @override
  Future<UserEntity> getUserFromUid(String uid) =>
      remoteDataSource.getUserByUid(uid);
}
