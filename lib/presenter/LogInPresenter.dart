import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class LogInView {
  checkAuth() {}
  loginError(String error) {}
}

class LogInPresenter {
  final LogInView _view;

  LogInPresenter(this._view);

  onClickLogin(FirebaseAuth auth, TextEditingController emailController,
      TextEditingController passwordController) {
    auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((user) {
      print(user.user?.email);
      print(auth.currentUser);
      _view.checkAuth();
    }).catchError((error) {
      _view.loginError(error.code);
      print('Email is ${emailController} Password is ${passwordController}');
      print(error.message);
    });
  }
}
