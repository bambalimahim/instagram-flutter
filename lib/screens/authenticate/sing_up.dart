import 'dart:typed_data';

import 'package:exo1/screens/authenticate/sing_in.dart';
import 'package:exo1/screens/home/home.dart';
import 'package:exo1/screens/wrapper.dart';
import 'package:exo1/services/auth.dart';
import 'package:exo1/utils/util.dart';
import 'package:exo1/widgets/text_filed_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class SingUp extends StatefulWidget {
  const SingUp({Key? key}) : super(key: key);
  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  selectedImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void singUp() async {
    setState(() {
      _isLoading = true;
    });
    String res = "";
    if (_image != null) {
      res = await AuthService().singUp(
          email: _emailController.text,
          password: _passwordController.text,
          username: _usernameController.text,
          bio: _bioController.text,
          file: _image!);
    } else {
      showSnackBarr("Image is null", context);
    }
    setState(() {
      _isLoading = false;
    });
    if (res != "success") {
      showSnackBarr(res, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Wrapper()));
    }
  }

  void goToSinIn() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SingIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                'images/logo.svg',
                color: Colors.green[500],
                height: 64,
              ),
              const SizedBox(
                height: 12,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.white,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage("images/dmn.png"),
                          backgroundColor: Colors.white,
                        ),
                  Positioned(
                      bottom: -10,
                      left: 85,
                      child: IconButton(
                        onPressed: selectedImage,
                        icon: const Icon(Icons.add_a_photo),
                      ))
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'your email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'your username',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: _bioController,
                hintText: 'your bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: singUp,
                child: Container(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text('Sing Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: Colors.green),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Have an account  "),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                      onTap: goToSinIn,
                      child: Container(
                        child: const Text(
                          "Sing in",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
