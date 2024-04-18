import 'package:ciak_time/models/movie_cast_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieCastBloc {
  final _repository = Repository();
  String movieId = "";

  MovieCastBloc(String movieId) {
    this.movieId = movieId;
  }

  final _moviesFetcher = PublishSubject<MovieCastModel>();

  Stream<MovieCastModel> get castList => _moviesFetcher.stream;

  fetchMovieCastResults() async {
    MovieCastModel movieModel =
        await _repository.fetchMovieCastResults(movieId);
    _moviesFetcher.sink.add(movieModel);
  }

  dispose() {
    _moviesFetcher.close();
  }
}
