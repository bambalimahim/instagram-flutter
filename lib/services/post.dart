import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exo1/models/post.dart';
import 'package:exo1/models/user.dart';
import 'package:exo1/services/storage.dart';
import 'package:uuid/uuid.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> upload(
    String description,
    Uint8List file,
    UserAuth userAuth,
  ) async {
    String res = "";
    try {
      String idPost = const Uuid().v1();
      String urlPhoto = await StorageService().uploadFile('posts', file, true);
      Post post = Post(
        uid: userAuth.uid,
        description: description,
        username: userAuth.username,
        datePublished: DateTime.now(),
        postId: idPost,
        postUrl: urlPhoto,
        profileImage: userAuth.urlPhoto,
        likes: [],
      );
      await _firestore.collection('posts').doc(post.postId).set(post.toJson());
      res = "success";
    } on FirebaseException catch (e) {
      res = e.message.toString();
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
