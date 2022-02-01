import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exo1/models/user.dart';
import 'package:exo1/services/post.dart';
import 'package:exo1/utils/color.dart';
import 'package:exo1/utils/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  UserAuth? userAuth;
  Uint8List? _file;
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  _selectedImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Chose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionController.dispose();
  }

  clearImage() {
    setState(() {
      _file = null;
    });
  }

  savePost(UserAuth userAuth) async {
    setState(() {
      isLoading = true;
    });
    String res = await PostService()
        .upload(descriptionController.text, _file!, userAuth);
    if (res == 'success') {
      setState(() {
        isLoading = false;
      });
      showSnackBarr('Posted!', context);
      clearImage();
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBarr(res, context);
    }
  }

  void getUser() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    userAuth = UserAuth.fromSnapshot(snapshot);
  }

  @override
  Widget build(BuildContext context) {
    return _file == null
        ? Center(
            child: IconButton(
              icon: Icon(Icons.upload),
              onPressed: () => _selectedImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              title: Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => savePost(userAuth!),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                isLoading
                    ? LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        userAuth!.urlPhoto,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Write a caption',
                          border: InputBorder.none,
                        ),
                        controller: descriptionController,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(
                                _file!,
                              ),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
