import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:my_app/model/ListMovieModel.dart';
import '../constants.dart';

abstract class ListMoviePresenterView {
   nextPage(int id);
   fetchMovies();
}

class ListMoviePresenter {
  late ListMovieModel listMovie;

  // view.fetchMovies() {
    
  // }

  Future<ListMovieModel> getListMoive() async {
    final response = await http.get(
        Uri.parse("${api_url}popular?api_key=$api_key&language=en-US&page=1"));
    // print(response.body);
    if (response.statusCode == 200) {
      listMovie = ListMovieModel.fromJson(jsonDecode(response.body));
      return listMovie;
    } else {
      throw Exception('Failed to load Data');
    }
  }
}
