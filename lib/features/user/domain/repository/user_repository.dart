import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<void> googleAuth();
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<void> forgotPassword(String email);
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<void> getUpdateUser(UserEntity user);
  Future<String> getCurrentUid();
  Future<UserEntity> getUserFromUid(String uid);
  Stream<List<UserEntity>> getAllUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(UserEntity user);
}
