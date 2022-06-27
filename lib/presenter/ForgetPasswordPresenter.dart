import 'package:firebase_auth/firebase_auth.dart';

abstract class ForgetPasswordView {
  sendEmailSuccess() {}
}

class ForgetPasswordPresenter {
  final ForgetPasswordView _view;
  ForgetPasswordPresenter(this._view);

  onClickResetPassword(FirebaseAuth auth, String email) {
    auth.sendPasswordResetEmail(email: email);
    _view.sendEmailSuccess();
  }
}
