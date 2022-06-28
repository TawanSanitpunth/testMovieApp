import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/presenter/LogInPresenter.dart';
import 'package:my_app/view/ListMovies.dart';
import 'package:my_app/view/Register.dart';
import 'package:my_app/view/forgetPassword.dart';

import '../model/LogInModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LogInView {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  LogInModel logInModel = LogInModel();
  final _formKey = GlobalKey<FormState>();
  late LogInPresenter logInPresenter;

  _LoginPageState() {
    logInPresenter = LogInPresenter(this);
  }

  @override
  void initState() {
    checkAuth();
    super.initState();
  }

  @override
  checkAuth() {
    if (_auth.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ListMovies(
                      title: widget.title,
                      emailUser: _auth.currentUser?.email,
                    )),
            (route) => false);
      });
    }
  }

  @override
  loginError(errorCode) {
    if (logInModel.emailController.text.trim().isEmpty ||
        logInModel.passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please fill Email and password"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(errorCode),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Color(0xFF7ccaab), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff022541),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
        },
        child: Container(
          color: const Color(0xff040f0f),
          child: Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
              decoration: BoxDecoration(
                color: const Color(0xff1B1B1B),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Log in',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: logInModel.emailController,
                        decoration:
                            const InputDecoration.collapsed(hintText: 'Email'),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        obscureText: true,
                        controller: logInModel.passwordController,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Password'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () => logInPresenter.onClickLogin(
                          _auth,
                          logInModel.emailController,
                          logInModel.passwordController),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.teal[900],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  ForgetPassword(title: widget.title))),
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              'Forget password?',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                      height: 50,
                    ),
                    const Center(
                      child: Text(
                        'New One?',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  Register(title: widget.title))),
                      child: const Center(
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
