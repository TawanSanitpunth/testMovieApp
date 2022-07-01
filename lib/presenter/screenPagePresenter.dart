import 'package:firebase_auth/firebase_auth.dart';

abstract class PageScreenView {
  backToLogIn() {}
  alertDialog() {}
}

class PageScreenPresenter {
  final PageScreenView _view;

  PageScreenPresenter(this._view);

  signOut(FirebaseAuth auth) {
    auth = FirebaseAuth.instance;
    auth.signOut();
    _view.backToLogIn();
  }

  onClickLogOut() {
    _view.alertDialog();
  }
}
