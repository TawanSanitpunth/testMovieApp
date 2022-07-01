import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/model/MovieDetailModel.dart';
import 'package:my_app/repository/repository.dart';

abstract class MyFavoriteView {}

class MyFavoritePresenter {
  MyFavoriteView _view;
  MyFavoritePresenter(this._view);
  var movieLength;
  late MovieDetailModel movieDetail;
  fetchMovies(String emailUser) async {
    await FirebaseFirestore.instance
        .collection("Myfavorite")
        .doc(emailUser)
        .get()
        .then((DocumentSnapshot value) {
      print("value is ${value["listMovies"]}");
      movieLength = value["listMovies"];
      print(movieLength);
      return movieLength;
    }).catchError((error) {
      print(error);
    });
  }
}
