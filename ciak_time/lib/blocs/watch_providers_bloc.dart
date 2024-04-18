import 'package:ciak_time/models/watch_providers_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class WatchProvidersBloc {
  final _repository = Repository();
  String movieId = "";

  WatchProvidersBloc(String movieId) {
    this.movieId = movieId;
  }

  final _moviesFetcher = PublishSubject<WatchProvidersModel>();

  Stream<WatchProvidersModel> get watchProviders => _moviesFetcher.stream;

  fetchWatchProvidersResults() async {
    WatchProvidersModel movieModel =
        await _repository.fetchWatchProvidersResults(movieId);
    _moviesFetcher.sink.add(movieModel);
  }

  dispose() {
    _moviesFetcher.close();
  }
}
