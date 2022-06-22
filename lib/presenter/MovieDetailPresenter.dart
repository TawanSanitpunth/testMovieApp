import 'package:my_app/model/MovieDetailModel.dart';
import 'package:my_app/repository/repository.dart';

abstract class MovieDetailView {
  fetchMovieDetail(String id);
}

class MovieDetailPresenter implements MovieDetailView {
  Repository repository = Repository();
  late MovieDetailModel movieDetail;

  @override
  Future fetchMovieDetail(String id) async {
    movieDetail = await repository.getMovieDetailFromAPI(id);
  }
}
