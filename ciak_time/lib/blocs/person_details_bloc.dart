import 'package:ciak_time/models/person_details_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class PersonDetailsBloc {
  final _repository = Repository();
  String personId = "";

  PersonDetailsBloc(String personId) {
    this.personId = personId;
  }

  final _personDetailsFetcher = PublishSubject<PersonDetailsModel>();

  Stream<PersonDetailsModel> get personDetails => _personDetailsFetcher.stream;

  fetchPersonDetailsResults() async {
    PersonDetailsModel personDetailsModel =
        await _repository.fetchPersonDetailsResults(personId);
    _personDetailsFetcher.sink.add(personDetailsModel);
  }

  dispose() {
    _personDetailsFetcher.close();
  }
}
