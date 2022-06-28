import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_app/presenter/ListMoviePresenter.dart';
import 'package:my_app/view/ListMovies.dart';
import 'package:my_app/view/LoginPage.dart';
import 'package:my_app/view/MovieDetails.dart';
import 'package:my_app/view/MyFavorite.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../constants.dart';

class PageScreen extends StatefulWidget {
  final String title;
  final String? emailUser;
  const PageScreen({Key? key, required this.title, this.emailUser})
      : super(key: key);

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen>
    implements ListMoviePresenterView {
  late ListMoviePresenter listMoviePresenter;
  _PageScreenState() {
    listMoviePresenter = ListMoviePresenter(this);
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  PageController pageController = PageController();
  int _selectIndex = 0;

  @override
  alertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xff022541),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text('Log out'),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF7ccaab),
                fontSize: 20),
            content: const Text('You will be returned to the login screen'),
            contentTextStyle: const TextStyle(
              color: Color(0xFF7ccaab),
            ),
            actions: [
              TextButton(
                onPressed: (() => Navigator.pop(context)),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: (() => listMoviePresenter.signOut(_auth)),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                      color: Color(0xFF7ccaab), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  @override
  backToLogIn() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(title: widget.title)),
        (route) => false);
  }

  _onTap(int index) {
    setState(() {
      _selectIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff040f0f),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    '${widget.emailUser}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF7ccaab),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
                onTap: () => listMoviePresenter.onClickLogOut(),
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.grey[300],
                )),
          )
        ],
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Color(0xFF7ccaab), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff022541),
      ),
      body: PageView(
        controller: pageController,
        children: [
          ListMovies(title: widget.title, emailUser: widget.emailUser),
          const MyFavorite()
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: BottomNavigationBar(
            currentIndex: _selectIndex,
            onTap: _onTap,
            selectedIconTheme:
                const IconThemeData(color: Color(0xFF7ccaab), size: 30),
            selectedItemColor: const Color(0xFF7ccaab),
            unselectedItemColor: Colors.grey,
            backgroundColor: const Color(0xff022541),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.movie_creation_outlined,
                  ),
                  label: "Movies"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite_border_outlined,
                  ),
                  label: "Favorite"),
            ]),
      ),
    );
  }
}
