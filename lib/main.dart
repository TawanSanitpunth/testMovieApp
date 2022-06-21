import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/controller/ListMovieController.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'view/MovieDetails.dart';

void main() {
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
      home: const MyHomePage(
        title: 'TMDB',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ListMovieController listMovieController = ListMovieController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff040f0f),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Color(0xFF7ccaab), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff022541),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
           
            Expanded(
              child: FutureBuilder<dynamic>(
                  future: listMovieController.getListMoive(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var listMovie = listMovieController.listMovie.results;
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
                                        backgroundColor:
                                            const Color(0xFF1F4529),
                                        // fillColor: Colors.black,
                                        lineWidth: 5.0,
                                        percent: listMovie[index]
                                                .voteAverage!
                                                .toDouble() /
                                            10,
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
            ),
          ],
        ),
      ),
    );
  }
}
