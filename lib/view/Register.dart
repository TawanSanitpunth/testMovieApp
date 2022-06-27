import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/model/RegisterModel.dart';
import 'package:my_app/presenter/RegisterPresenter.dart';

import '../main.dart';

class Register extends StatefulWidget {
  final String title;
  const Register({Key? key, required this.title}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> implements RegisterView {
  late RegisterPresenter registerPresenter;
  _RegisterState() {
    registerPresenter = RegisterPresenter(this);
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  RegisterModel registerModel = RegisterModel();

  @override
  passwordNotMatch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Password and Confirm password not match"),
      ),
    );
  }

  @override
  registerSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.greenAccent,
        content: Text("Register Success"),
      ),
    );
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(title: widget.title)),
        (route) => false);
  }

  @override
  registerError(errorCode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(errorCode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff040f0f),
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
        child: SingleChildScrollView(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign up',
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
                        onChanged: (value) {
                          setState(() {
                            if (registerModel.regExpEmail.hasMatch(value)) {
                              registerModel.isFormatEmail = true;
                            } else {
                              registerModel.isFormatEmail = false;
                            }
                          });
                        },
                        controller: registerModel.emailController,
                        decoration:
                            const InputDecoration.collapsed(hintText: 'Email'),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        obscureText: true,
                        controller: registerModel.passwordController,
                        onChanged: (value) {
                          setState(() {
                            // check length
                            if (value.length >= 8) {
                              registerModel.pwLengt = true;
                            } else {
                              registerModel.pwLengt = false;
                            }

                            //check uppercase
                            if (RegExp('(?=.*[A-Z])').hasMatch(value)) {
                              registerModel.isUppercase = true;
                            } else {
                              registerModel.isUppercase = false;
                            }

                            //check lowercase
                            if (RegExp('(?=.*[a-z])').hasMatch(value)) {
                              registerModel.isLowercase = true;
                            } else {
                              registerModel.isLowercase = false;
                            }

                            //check special characters
                            if (RegExp('(?=.*?[!@#\$&*~])').hasMatch(value)) {
                              registerModel.isSpecial = true;
                            } else {
                              registerModel.isSpecial = false;
                            }

                            //check num
                            if (RegExp('(?=.*?[0-9])').hasMatch(value)) {
                              registerModel.isNum = true;
                            } else {
                              registerModel.isNum = false;
                            }
                          });
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Password'),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        obscureText: true,
                        controller: registerModel.cfPasswordController,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Confirm password'),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    registerModel.passwordController.text.trim() != ""
                        ? Container(
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Password must contain : ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              checkPassword(registerModel.pwLengt,
                                  "Atlease 8 characters"),
                              checkPassword(registerModel.isUppercase,
                                  "Atlease 1 Uppercase"),
                              checkPassword(registerModel.isLowercase,
                                  "Atlease 1 Lowercase"),
                              checkPassword(registerModel.isSpecial,
                                  "Atlease 1 Special characters"),
                              checkPassword(
                                  registerModel.isNum, "Atlease 1 Number")
                            ],
                          ))
                        : Container(),
                    const SizedBox(
                      height: 30,
                    ),
                    registerModel.isFormatEmail &&
                            registerModel.pwLengt &&
                            registerModel.isUppercase &&
                            registerModel.isLowercase &&
                            registerModel.isSpecial &&
                            registerModel.isNum == true
                        ? InkWell(
                            onTap: () {
                              // signUp();
                              registerPresenter.onclickSignUp(
                                  _auth,
                                  registerModel.email,
                                  registerModel.password,
                                  registerModel.cfPassword);
                            },
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.teal[900],
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const Center(
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {},
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.grey,
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const Center(
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
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
                        'Have already account?',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(
                        context,
                      ),
                      child: const Center(
                        child: Text(
                          'Log in',
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

  Container checkPassword(bool passwordFormat, String TextFormat) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.info_outline,
            color: passwordFormat == true ? Colors.green[300] : Colors.red,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            TextFormat,
            style: TextStyle(
                color: passwordFormat == true ? Colors.green[300] : Colors.red),
          )
        ],
      ),
    );
  }
}
