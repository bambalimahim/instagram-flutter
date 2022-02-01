import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String description;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImage;
  final likes;

  Post({
    required this.uid,
    required this.description,
    required this.username,
    required this.datePublished,
    required this.postId,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "username": username,
        "uid": uid,
        "Description": description,
        "datePublished": datePublished,
        "profileImage": profileImage,
        "postUrl": postUrl,
        "likes": likes,
      };

  static Post fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(
      uid: snap['uid'],
      description: snap['description'],
      username: snap['username'],
      datePublished: snap['datePublished'],
      postUrl: snap['postUrl'],
      profileImage: snap['profileImage'],
      likes: snap['likes'],
      postId: snap['postId'],
    );
  }
}
