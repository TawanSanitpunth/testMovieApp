import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/presenter/ListMoviePresenter.dart';
import 'package:my_app/view/MovieDetails.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff040f0f),
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
                                emailUser: widget.emailUser ?? "",
                                movieTitle: listMovie[index].title,
                                posterPath: listMovie[index].posterPath,
                                voteAverage: listMovie[index].voteAverage!,
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
