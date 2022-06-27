import 'package:flutter/material.dart';

class RegisterModel {
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
  String errorCode = "";

  RegExp regExpEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  RegExp regExpPassword =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
}
