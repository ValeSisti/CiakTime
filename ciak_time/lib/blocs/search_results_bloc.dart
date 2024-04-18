import 'dart:async';
import 'package:ciak_time/models/search_results_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchResultsBloc {
  final _repository = Repository();
  String queryString = "";
  int currentPage;

  SearchResultsBloc(String queryString, int currentPage) {
    this.queryString = queryString;
    this.currentPage = currentPage;
  }

  final _searchResultsFetcher = PublishSubject<List<SearchResultsModel>>();

  Stream<List<SearchResultsModel>> get searchResults => _searchResultsFetcher.stream;

  Future<List<SearchResultsModel>> fetchSearchResults() async {
    List<SearchResultsModel> searchResultsModel =
        await _repository.fetchSearchResults(queryString, currentPage);
    _searchResultsFetcher.sink.add(searchResultsModel);
    return searchResultsModel;
  }

  dispose() {
    _searchResultsFetcher.close();
  }
}
