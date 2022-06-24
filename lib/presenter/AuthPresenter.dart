abstract class AuthPresenterView {
  signIn() {}
}

class AuthPresenter {
  final AuthPresenterView _view;
  AuthPresenter(this._view);

  signInWithEmail() {
    _view.signIn();
  }
}
