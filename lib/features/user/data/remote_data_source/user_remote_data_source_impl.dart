import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app/features/user/data/model/user_model.dart';
import 'package:group_chat_app/features/user/data/remote_data_source/user_remote_data_source.dart';
import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRemoteDataSourceImplementation implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  UserRemoteDataSourceImplementation({
    required this.firestore,
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<void> forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Stream<List<UserEntity>> getAllUsers(UserEntity user) {
    final userCollection = firestore.collection("users");

    return userCollection
        .where("uid", isNotEqualTo: user.uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    });
  }

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final uid = await getCurrentUid();
    final userCollection = firestore.collection('users');
    userCollection.doc(uid).get().then((userDoc) {
      if (!(userDoc.exists)) {
        final newUser = UserModel(
          email: user.email,
          name: user.name,
          profileUrl: user.profileUrl,
          status: user.status,
          uid: uid,
        );
        userCollection.doc(uid).set(newUser.toDocument());
      } else {
        Fluttertoast.showToast(msg: "User Already Exists");
      }
    });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleUser(UserEntity user) {
    final userCollection = firestore.collection("users");

    return userCollection
        .limit(1)
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    });
  }

  @override
  Future<void> getUpdateUser(UserEntity user) async {
    final userCollection = firestore.collection("users");

    Map<String, dynamic> userInformation = {};

    if (user.profileUrl != null && user.profileUrl != "") {
      userInformation['profileUrl'] = user.profileUrl;
    }

    if (user.status != null && user.status != "") {
      userInformation['status'] = user.status;
    }

    if (user.name != null && user.name != "") {
      userInformation['name'] = user.name;
    }

    await userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<void> googleAuth() async {
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await account!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final information =
        (await firebaseAuth.signInWithCredential(credential)).user;

    getCreateCurrentUser(
      UserEntity(
        name: information!.displayName,
        email: information.email,
        status: "",
        profileUrl: information.photoURL,
      ),
    );
  }

  @override
  Future<bool> isSignIn() async {
    return (firebaseAuth.currentUser?.uid) != null;
  }

  @override
  Future<void> signIn(UserEntity user) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: user.email!, password: user.password!);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Error");
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Error");
    } on SocketException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    firebaseAuth.signOut();
  }

  @override
  Future<void> signUp(UserEntity user) async {
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: user.email!, password: user.password!)
        .then(
      (value) {
        getCreateCurrentUser(user);
      },
    );
  }

  @override
  Future<UserEntity> getUserByUid(String uid) async {
    final userUid = await getCurrentUid();
    final userDoc = await firestore.collection('users').doc(userUid).get();
    return UserModel.fromSnapshot(userDoc);
  }
}
