import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/main.dart';

abstract class RegisterView {
  registerSuccess() {}
  passwordNotMatch() {}
  registerError(String error) {}
}

class RegisterPresenter {
  final RegisterView _view;
  RegisterPresenter(this._view);

  onclickSignUp(
      FirebaseAuth auth, String email, String password, String cfPassword) {
    auth = FirebaseAuth.instance;
    if (password == cfPassword) {
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) => {_view.registerSuccess()})
          .catchError((error) {
        _view.registerError(error.code);
        print(error);
      });
    } else {
      _view.passwordNotMatch();
    }
  }
}
