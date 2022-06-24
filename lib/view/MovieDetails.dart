import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/presenter/MovieDetailPresenter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MovieDetails extends StatefulWidget {
  final String id;
  const MovieDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails>
    implements MovieDetailView {
  late MovieDetailPresenter movieDetailPresenter;

  _MovieDetailsState() {
    movieDetailPresenter = MovieDetailPresenter(this);
  }
  bool _isfav = false;

  @override
  onClickFav(bool isfav) {
    setState(() {
      _isfav = !_isfav;
    });
    isfav = _isfav;
    // print(_isfav);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff040f0f),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'TMDB',
          style:
              TextStyle(color: Color(0xFF7ccaab), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff022541),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<dynamic>(
            future: movieDetailPresenter.fetchMovieDetail(widget.id),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var movieDetail = movieDetailPresenter.movieDetail;
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.7), BlendMode.darken),
                        image: NetworkImage(
                          pic_url + movieDetail.backdropPath,
                        ),
                        fit: BoxFit.fill),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            pic_url + movieDetail.posterPath,
                            height: 250,
                            width: 200,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        movieDetail.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Release Date: ${movieDetail.releaseDate}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularPercentIndicator(
                            radius: 35.0,
                            backgroundColor: const Color(0xFF423D0F),
                            lineWidth: 5.0,
                            percent: movieDetail.voteAverage.toDouble() / 10,
                            center: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF071C22),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${movieDetail.voteAverage.toInt() * 10}",
                                      style: const TextStyle(
                                          fontSize: 20,
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
                                              fontSize: 14),
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
                            progressColor: const Color(0xFFD2D530),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'User Score',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "(${movieDetail.voteCount} Voted.)",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            // padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                                color: Color(0xff022541),
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () =>
                                    movieDetailPresenter.onClick(!_isfav),
                                icon: Icon(Icons.favorite,
                                    color: _isfav != true
                                        ? Colors.white
                                        : Colors.pink)),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        children: List.generate(
                            movieDetail.genres.length,
                            (i) => movieDetail.genres[i] ==
                                    movieDetail.genres[0]
                                ? Text(
                                    movieDetail.genres[i].name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey[300]),
                                  )
                                : Text(
                                    ", ${movieDetail.genres[i].name}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey[300]),
                                  )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        movieDetail.tagline,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            color: Colors.grey[300]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Text('Overview',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        movieDetail.overview,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            })),
      ),
    );
  }
}
