import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/model/LogInModel.dart';
import 'package:my_app/presenter/LogInPresenter.dart';
import 'package:my_app/view/LandingPage.dart';
import 'package:my_app/view/ListMovies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/view/LoginPage.dart';
import 'package:my_app/view/Register.dart';
import 'package:my_app/view/forgetPassword.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(
        title: 'TMDB',
      ),
    );
  }
}
