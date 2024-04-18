import 'package:ciak_time/models/movie_images_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieImagesBloc {
  final _repository = Repository();
  String movieId = "";

  MovieImagesBloc(String movieId) {
    this.movieId = movieId;
  }

  final _moviesFetcher = PublishSubject<MovieImagesModel>();

  Stream<MovieImagesModel> get moviesImages => _moviesFetcher.stream;

  fetchMovieImagesResults() async {
    MovieImagesModel movieModel =
        await _repository.fetchMovieImagesResults(movieId);
    _moviesFetcher.sink.add(movieModel);
  }

  dispose() {
    _moviesFetcher.close();
  }
}
