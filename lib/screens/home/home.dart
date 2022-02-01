import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exo1/models/user.dart';
import 'package:exo1/providers/user_provider.dart';
import 'package:exo1/screens/add_post.dart';
import 'package:exo1/utils/color.dart';
import 'package:exo1/utils/global_variable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
