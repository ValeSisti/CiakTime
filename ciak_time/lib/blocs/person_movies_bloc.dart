
import 'package:ciak_time/models/person_movies_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class PersonMoviesBloc {
  final _repository = Repository();
  String personId = "";

  PersonMoviesBloc(String personId) {
    this.personId = personId;
  }

  final _personMoviesFetcher = PublishSubject<PersonMoviesModel>();

  Stream<PersonMoviesModel> get personMovies => _personMoviesFetcher.stream;

  fetchPersonMoviesResults() async {
    PersonMoviesModel personMoviesModel =
        await _repository.fetchPersonMoviesResults(personId);
    _personMoviesFetcher.sink.add(personMoviesModel);
  }

  dispose() {
    _personMoviesFetcher.close();
  }
}