import 'dart:convert';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/model/MovieDetailModel.dart';
import '../constants.dart';

class MovieDetailController extends ControllerMVC {
  late MovieDetailModel movieDetail;

  Future<MovieDetailModel> getDetailMovie(String id) async {
    final response = await http
        .get(Uri.parse("$api_url$id?api_key=$api_key&language=en-US"));
        if(response.statusCode == 200){
         movieDetail =  MovieDetailModel.fromJson(jsonDecode(response.body));
        return movieDetail;
        }else{
          throw Exception('Failed to load Data');
        }
  }
}
