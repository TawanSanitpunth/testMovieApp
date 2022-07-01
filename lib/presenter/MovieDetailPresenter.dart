import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/model/MovieDetailModel.dart';
import 'package:my_app/repository/repository.dart';

abstract class MovieDetailView {
  onChangeFav(bool isfav);
  onClickFav() {}
  fetchFavMovie(bool isFav) {}
}

class MovieDetailPresenter {
  Repository repository = Repository();
  late MovieDetailModel movieDetail;
  final MovieDetailView _view;
  MovieDetailPresenter(this._view);

  Future fetchMovieDetail(String id) async {
    movieDetail = await repository.getMovieDetailFromAPI(id);
  }

  onClick(bool isfav) {
    _view.onChangeFav(isfav);
    print(isfav);
  }

  onClickFav() {
    _view.onClickFav();
  }

  fetchFavMovie(String emailUser, String movieId, bool isFav) async {
    FirebaseFirestore.instance
        .collection("Myfavorite")
        .doc(emailUser)
        .get()
        .then((DocumentSnapshot value) {
      final listMovies = value["listMovies"];
      for (var i = 0; i < listMovies.length; i++) {
        print(listMovies);
        if (listMovies[i]["movieId"].contains(movieId)) {
          print("${listMovies[i]["movieId"].contains(movieId)} is true");
          isFav = true;
          _view.fetchFavMovie(isFav);
        }
      }
    }).catchError((error) {
      print(error);
    });
  }
}
