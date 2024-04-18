import 'package:ciak_time/models/person_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class PopularPersonBloc {
  final _repository = Repository();
  final _peopleFetcher = PublishSubject<PersonModel>();

  Stream<PersonModel> get popularPeople => _peopleFetcher.stream;

  fetchPopularPeople() async {
    PersonModel personModel = await _repository.fetchPopularPeople();
    _peopleFetcher.sink.add(personModel);
  }

  dispose() {
    _peopleFetcher.close();
  }
}

final bloc = PopularPersonBloc();
