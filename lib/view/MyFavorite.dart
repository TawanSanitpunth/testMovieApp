import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/presenter/MyFavoritePresenter.dart';
import 'package:my_app/view/MovieDetails.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyFavorite extends StatefulWidget {
  final String? emailUser;
  const MyFavorite({Key? key, required this.emailUser}) : super(key: key);

  @override
  State<MyFavorite> createState() => _MyFavoriteState();
}

class _MyFavoriteState extends State<MyFavorite> implements MyFavoriteView {
  late MyFavoritePresenter myFavoritePresenter = MyFavoritePresenter(this);

  @override
  void initState() {
    myFavoritePresenter.fetchMovies(widget.emailUser ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff040f0f),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: FutureBuilder(
              future: myFavoritePresenter.fetchMovies(widget.emailUser ?? ""),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return 
                  // myFavoritePresenter.movieLength.isEmpty
                  //     ? Center(
                  //         child: Row(children: <Widget>[
                  //         Expanded(
                  //             child: Divider(
                  //           color: Colors.grey.withOpacity(0.2),
                  //           thickness: 1.5,
                  //           indent: 10,
                  //           endIndent: 10,
                  //         )),
                  //         const Text(
                  //           'No favorite Movies.',
                  //           style: TextStyle(color: Color(0xFF7ccaab)),
                  //         ),
                  //         Expanded(
                  //             child: Divider(
                  //           color: Colors.grey.withOpacity(0.2),
                  //           thickness: 1.5,
                  //           indent: 10,
                  //           endIndent: 10,
                  //         )),
                  //       ]))
                  //     : 
                      GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  crossAxisSpacing: 20,
                                  mainAxisExtent: 300),
                          itemCount: myFavoritePresenter.movieLength.length,
                          itemBuilder: (context, index) {
                            var movieDetail =
                                myFavoritePresenter.movieLength[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetails(
                                      id: movieDetail["movieId"],
                                      emailUser: widget.emailUser ?? "",
                                      movieTitle: movieDetail["movieName"],
                                      posterPath: movieDetail["posterPath"],
                                      voteAverage: movieDetail["voteAverage"],
                                    ),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        pic_url + movieDetail["posterPath"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 12,
                                      child: CircularPercentIndicator(
                                        radius: 20.0,
                                        backgroundColor:
                                            const Color(0xFF1F4529),
                                        // fillColor: Colors.black,
                                        lineWidth: 5.0,
                                        percent:
                                            movieDetail["voteAverage"] / 10,
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
                                                  "${movieDetail["voteAverage"].toInt() * 10}",
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
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
        ));
  }
}
