import 'package:exo1/screens/authenticate/sing_up.dart';
import 'package:exo1/screens/wrapper.dart';
import 'package:exo1/services/auth.dart';
import 'package:exo1/utils/util.dart';
import 'package:exo1/widgets/text_filed_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SingIn extends StatefulWidget {
  const SingIn({Key? key}) : super(key: key);
  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void login() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthService().singInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Wrapper()));
    } else {
      showSnackBarr(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void goToSinUp() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SingUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
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
                height: 64,
              ),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'your email',
                  textInputType: TextInputType.emailAddress),
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
                height: 12,
              ),
              InkWell(
                onTap: login,
                child: Container(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text('Log in'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: Colors.green,
                  ),
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
                    child: const Text("Don't have an account "),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: goToSinUp,
                    child: Container(
                      child: const Text(
                        "Sing up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
