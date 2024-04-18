import 'package:ciak_time/models/movie_details_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailsBloc {
  final _repository = Repository();
  String movieId = "";

  MovieDetailsBloc(String movieId) {
    this.movieId = movieId;
  }

  final _moviesFetcher = PublishSubject<MovieDetailsModel>();

  Stream<MovieDetailsModel> get movieDetails => _moviesFetcher.stream;

  fetchMovieDetailsResults() async {
    MovieDetailsModel movieModel =
        await _repository.fetchMovieDetailsResults(movieId);
    _moviesFetcher.sink.add(movieModel);
  }

  dispose() {
    _moviesFetcher.close();
  }
}
