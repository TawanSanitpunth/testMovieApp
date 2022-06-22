import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_app/constants.dart';
import 'package:my_app/model/ListMovieModel.dart';
import 'package:my_app/model/MovieDetailModel.dart';

class Repository {
  Future<ListMovieModel> getListMovieFromAPI() async {
    final response = await http.get(
        Uri.parse("${api_url}popular?api_key=$api_key&language=en-US&page=1"));
    // print(response.body);
    if (response.statusCode == 200) {
      return ListMovieModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<MovieDetailModel> getMovieDetailFromAPI(String id) async {
    var response = await http
        .get(Uri.parse("$api_url$id?api_key=$api_key&language=en-US"));

    if (response.statusCode == 200) {
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }
}
