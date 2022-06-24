import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/presenter/ListMoviePresenter.dart';
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

  _ListMoviesState() {
    listMoviePresenter = ListMoviePresenter(this);
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  signOut() {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(title: widget.title)),
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
            padding: EdgeInsets.only(right: 10),
            width: 150,
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    '${widget.emailUser}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
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
                onTap: () => signOut(),
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
                            // mainAxisSpacing: 15,
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
