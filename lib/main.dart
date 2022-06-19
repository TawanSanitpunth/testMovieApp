import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'MovieDetails.dart';

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
  String _apiKey = "a678a709d309e5ebd4e6524290d9d310";

  Future<dynamic> getListMoive() async {
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey&language=en-US&page=1"));
    // print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Data');
    }
  }

  @override
  void initState() {
    getListMoive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: const Text(
                'What\'s Popular',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Expanded(
              child: FutureBuilder<dynamic>(
                  future: getListMoive(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          itemCount: snapshot.data["results"].length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetails(
                                      id: snapshot.data["results"][index]["id"].toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        'https://image.tmdb.org/t/p/w500' +
                                            snapshot.data["results"][index]
                                                ["poster_path"],
                                        height: 150,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data["results"][index]["title"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      snapshot.data["results"][index]
                                          ["release_date"],
                                      style: TextStyle(color: Colors.grey[600]),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }));
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })),
            ),

            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 2,
            //     itemBuilder: (context, index) {
            //       return Container(
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.circular(20),
            //           child: Image.network(
            //             'https://image.tmdb.org/t/p/w500/gG9fTyDL03fiKnOpf2tr01sncnt.jpg',
            //             height: 300,
            //             width: 50,
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
