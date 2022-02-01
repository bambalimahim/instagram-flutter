import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exo1/models/user.dart';
import 'package:exo1/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserAuth> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserAuth.fromSnapshot(snapshot);
  }

  Future<String> singUp({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Error occured";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          file != null) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        String photoUrl = await StorageService().uploadFile(
          "profiles",
          file,
          false,
        );
        UserAuth userAuth = UserAuth(
            uid: userCredential.user!.uid,
            email: email,
            username: username,
            bio: bio,
            urlPhoto: photoUrl,
            followers: [],
            following: []);
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userAuth.toJson());
        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      res = e.message.toString();
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future singInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<String> singInWithEmailAndPassword(
      {required String email, required String password}) async {
    String res = "";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "All fields are required";
      }
    } on FirebaseAuthException catch (e) {
      res = e.message.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
