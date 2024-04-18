import 'package:ciak_time/models/movie_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class PopularMoviesBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<MovieModel>();

  Stream<MovieModel> get popularMovies => _moviesFetcher.stream;

  fetchPopularMovies() async {
    MovieModel movieModel = await _repository.fetchPopularMovies();
    _moviesFetcher.sink.add(movieModel);
  }

  dispose() {
    _moviesFetcher.close();
  }
}

final bloc = PopularMoviesBloc();
