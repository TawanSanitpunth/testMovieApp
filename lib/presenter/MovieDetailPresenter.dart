import 'package:my_app/model/MovieDetailModel.dart';
import 'package:my_app/repository/repository.dart';

abstract class MovieDetailView {
  onClickFav(bool isfav);
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
    _view.onClickFav(isfav);
    print(isfav);
  }
}
