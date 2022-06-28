import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/presenter/ListMoviePresenter.dart';
import 'package:my_app/view/LoginPage.dart';
import 'package:my_app/view/MovieDetails.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../main.dart';

class ListMovies extends StatefulWidget {
  const ListMovies({Key? key, required this.title, required this.emailUser})
      : super(key: key);
  final String title;
  final String? emailUser;

  @override
  State<ListMovies> createState() => _ListMoviesState();
}

class _ListMoviesState extends State<ListMovies>
    implements ListMoviePresenterView {
  late ListMoviePresenter listMoviePresenter;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _ListMoviesState() {
    listMoviePresenter = ListMoviePresenter(this);
  }

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
        MaterialPageRoute(
            builder: (context) => LoginPage(title: widget.title)),
        (route) => false);
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
      body: Container(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<dynamic>(
            future: listMoviePresenter.fetchMovies(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var listMovie = listMoviePresenter.listMovie.results;
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            crossAxisSpacing: 20,
                            mainAxisExtent: 300),
                    itemCount: listMovie.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetails(
                                id: listMovie[index].id.toString(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  pic_url + listMovie[index].posterPath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 12,
                                child: CircularPercentIndicator(
                                  radius: 20.0,
                                  backgroundColor: const Color(0xFF1F4529),
                                  // fillColor: Colors.black,
                                  lineWidth: 5.0,
                                  percent: listMovie[index].voteAverage! / 10,
                                  center: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFF071C22),
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${listMovie[index].voteAverage!.toInt() * 10}",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                "%",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  progressColor: const Color(0xFF23BD70),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            })),
      ),
    );
  }
}
