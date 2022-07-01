import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_app/view/ListMovies.dart';
import 'package:my_app/view/LoginPage.dart';
import 'package:my_app/view/PageScreen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          print("User is $user");
          if (user == null) {
            return LoginPage(title: title);
          } else {
            return PageScreen(title: title, emailUser: user.email);
          }
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
