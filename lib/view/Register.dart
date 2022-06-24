import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../main.dart';

class Register extends StatefulWidget {
  final String title;
  const Register({Key? key, required this.title}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cfPasswordController = TextEditingController();
  late String email = emailController.text.trim();
  late String password = passwordController.text.trim();
  late String cfPassword = cfPasswordController.text.trim();
  bool isFormatEmail = false;
  bool pwLengt = false;
  bool isUppercase = false;
  bool isLowercase = false;
  bool isSpecial = false;
  bool isNum = false;

  RegExp regExpEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  RegExp regExpPassword =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  signUp() {
    if (password == cfPassword) {
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) => {
                print(user),
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.greenAccent,
                    content: Text("Register Success"),
                  ),
                ),
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(title: widget.title)),
                    (route) => false)
              })
          .catchError((error) {
        print(error);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Password and Confirm password not match"),
        ),
      );
    }
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
                            if (regExpEmail.hasMatch(value)) {
                              isFormatEmail = true;
                            } else {
                              isFormatEmail = false;
                            }
                          });
                        },
                        controller: emailController,
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
                        controller: passwordController,
                        onChanged: (value) {
                          setState(() {
                            //check length
                            if (value.length >= 8) {
                              pwLengt = true;
                            } else {
                              pwLengt = false;
                            }

                            //check uppercase
                            if (RegExp('(?=.*[A-Z])').hasMatch(value)) {
                              isUppercase = true;
                            } else {
                              isUppercase = false;
                            }

                            //check lowercase
                            if (RegExp('(?=.*[a-z])').hasMatch(value)) {
                              isLowercase = true;
                            } else {
                              isLowercase = false;
                            }

                            //check special characters
                            if (RegExp('(?=.*?[!@#\$&*~])').hasMatch(value)) {
                              isSpecial = true;
                            } else {
                              isSpecial = false;
                            }

                            //check num
                            if (RegExp('(?=.*?[0-9])').hasMatch(value)) {
                              isNum = true;
                            } else {
                              isNum = false;
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
                        controller: cfPasswordController,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Confirm password'),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    passwordController.text.trim() != ""
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
                              checkPassword(pwLengt, "Atlease 8 characters"),
                              checkPassword(isUppercase, "Atlease 1 Uppercase"),
                              checkPassword(isLowercase, "Atlease 1 Lowercase"),
                              checkPassword(
                                  isSpecial, "Atlease 1 Special characters"),
                              checkPassword(isNum, "Atlease 1 Number")
                            ],
                          ))
                        : Container(),
                    const SizedBox(
                      height: 30,
                    ),
                    isFormatEmail &&
                            pwLengt &&
                            isUppercase &&
                            isLowercase &&
                            isSpecial &&
                            isNum == true
                        ? InkWell(
                            onTap: () {
                              signUp();
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
