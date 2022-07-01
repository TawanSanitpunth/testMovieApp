import 'package:my_app/model/ListMovieModel.dart';
import 'package:my_app/repository/repository.dart';

abstract class ListMoviePresenterView {}

class ListMoviePresenter {
  // late final ListMoviePresenterView view;
  late ListMovieModel listMovie;
  Repository repository = Repository();

  final ListMoviePresenterView _view;

  ListMoviePresenter(this._view);

  Future fetchMovies() async {
    listMovie = await repository.getListMovieFromAPI();
    return listMovie;
  }
}
