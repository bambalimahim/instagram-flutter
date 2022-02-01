import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuth {
  final String uid;
  final String email;
  final String username;
  final String bio;
  final String urlPhoto;
  final List followers;
  final List following;

  UserAuth(
      {required this.uid,
      required this.email,
      required this.username,
      required this.bio,
      required this.urlPhoto,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "urlPhoto": urlPhoto,
        "bio": bio,
        "followers": followers,
        "following": following,
      };

  static UserAuth fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return UserAuth(
        uid: snap['uid'],
        email: snap['email'],
        username: snap['username'],
        bio: snap['bio'],
        urlPhoto: snap['urlPhoto'],
        followers: snap['followers'],
        following: snap['following']);
  }
}
