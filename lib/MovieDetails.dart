import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_app/constants.dart';

class MovieDetails extends StatefulWidget {
  final String id;
  const MovieDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {

  Future<dynamic> getDetailMovie() async {
    final response = await http.get(Uri.parse(
        "$api_url" +
            widget.id +
            "?api_key=$api_key&language=en-US"));
    // print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff022541),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'TMDB',
          style:
              TextStyle(color: Color(0xFF7ccaab), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff022541),
      ),
      body: FutureBuilder<dynamic>(
          future: getDetailMovie(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final  image_url = 'https://image.tmdb.org/t/p/w500';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.7), BlendMode.darken),
                          image: NetworkImage(
                            image_url +
                                snapshot.data["backdrop_path"],
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                             image_url +
                                  snapshot.data["poster_path"],
                              height: 250,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          snapshot.data["title"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              snapshot.data["release_date"],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Row(
                              children: List.generate(
                                snapshot.data["genres"].length,
                                (i) => Text(
                                  " " + snapshot.data["genres"][i]["name"],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          snapshot.data["tagline"],
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
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          snapshot.data["overview"],
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          })),
    );
  }
}
