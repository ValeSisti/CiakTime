import 'package:ciak_time/models/movie_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class UpcomingMoviesBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<MovieModel>();

  Stream<MovieModel> get upcomingMovies => _moviesFetcher.stream;

  fetchUpcomingMovies() async {
    MovieModel movieModel = await _repository.fetchUpcomingMovies();
    _moviesFetcher.sink.add(movieModel);
  }

  dispose() {
    _moviesFetcher.close();
  }
}

final bloc = UpcomingMoviesBloc();
