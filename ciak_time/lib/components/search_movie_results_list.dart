import 'dart:async';
import 'package:ciak_time/Screens/Search/components/cards_widget.dart';
import 'package:ciak_time/Screens/Search/filters_utils.dart';
import 'package:ciak_time/blocs/search_results_bloc.dart';
import 'package:ciak_time/components/rating.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/models/person.dart';
import 'package:ciak_time/models/search_results_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchMovieResultsList extends StatefulWidget {
  final String queryString;

  const SearchMovieResultsList({Key key, @required this.queryString})
      : super(key: key);

  @override
  _SearchMovieResultsListState createState() => _SearchMovieResultsListState();
}

class _SearchMovieResultsListState extends State<SearchMovieResultsList> {
  StreamController<List<SearchResultsModel>> _streamController =
      StreamController<List<SearchResultsModel>>.broadcast();
  ScrollController _scrollController = ScrollController();

  int currentPage = 1;
  Stream<SearchResultsModel> stream;
  Stream<SearchResultsModel> oldStream;
  final RefreshController refreshController = RefreshController();

  SearchResultsBloc bloc;
  int totalPages;

  @override
  dispose() {
    _scrollController.dispose();
    _streamController.close();
    super.dispose();
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.queryString == "") {
      return CardsWidget();
    }
    bloc = SearchResultsBloc(widget.queryString, currentPage);

    bloc
        .fetchSearchResults()
        .then((response) => _streamController.add(response));

    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, AsyncSnapshot<List<SearchResultsModel>> snapshot) {
        if (snapshot.hasData) {
          SearchResultsModel res = mergeRes(snapshot, currentPage);
          totalPages = res.totalPages;
          return FutureBuilder(
            future: getResultsRating(res),
            builder: (context, AsyncSnapshot<List<Movie>> revSnap) {
              if (revSnap.hasData) {
                if (selected_most_recent ||
                    selected_most_added ||
                    selected_rate) {
                  sortSearchResults(revSnap);
                }
                return buildList(revSnap, res);
              }
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              ));
            },
          );
          //}
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
            child: CircularProgressIndicator(
          color: Colors.amber,
        ));
      },
    );
  }

  Future<List<Movie>> getResultsRating(SearchResultsModel snapshot) async {
    List<Movie> resultsRating = [];
    for (var index = 0; index < snapshot.results.length; index++) {
      double rating = await getRating(snapshot.results[index].id);
      Movie movie = new Movie(
        title: snapshot.results[index].title,
        overview: snapshot.results[index].overview,
        voteAverage: rating,
        id: snapshot.results[index].id,
        releaseDate: snapshot.results[index].releaseDate,
        posterPath: snapshot.results[index].posterPath,
        voteCount: snapshot.results[index].voteCount,
        popularity: snapshot.results[index].popularity,
      );
      resultsRating.add(movie);
    }

    return resultsRating;
  }

  Widget returnImage(snapshot, index) {
    if (snapshot[index].posterPath != null) {
      return Container(
        height: width * 0.45,
        width: width * 0.25,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            'https://image.tmdb.org/t/p/w185${snapshot[index].posterPath}',
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
          height: width * 0.45,
          width: width * 0.25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey),
          child: Icon(Icons.image));
    }
  }

  Widget buildList(
      AsyncSnapshot<List<Movie>> snapshot, SearchResultsModel personSnapshot) {
    if (snapshot.data == null || personSnapshot.results.isEmpty) {
      return Center(
          child: Text(
        'No results found for "${widget.queryString}".',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17.0,
        ),
      ));
    } else {
      int length;
      if (tabSelected == "Movie") {
        length = snapshot.data.length;
      } else {
        length = personSnapshot.results.length;
      }
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: SmartRefresher(
          controller: refreshController,
          enablePullUp: true,
          enablePullDown: false,
          onLoading: () async {
            if (currentPage > totalPages) {
              refreshController.loadNoData();
            } else {
              final result = await getSearchResults(widget.queryString);

              if (result) {
                refreshController.loadComplete();
              } else {
                refreshController.loadFailed();
              }
            }
          },
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: length,
              itemBuilder: (BuildContext context, int index) {
                if (tabSelected == "Movie") {
                  return getMovieResultSearch(snapshot.data, index, context);
                } else if (tabSelected == "Person") {
                  return getPersonResultsSearch(personSnapshot, index, context);
                } else {
                  return null;
                }
              }),
        ),
      );
    }
  }

  var id;

  Widget getMovieResultSearch(
      List<Movie> snapshot, int index, BuildContext context) {
    id = snapshot[index].id;

    return Container(
      height: height * 0.2,
      width: width * 0.05,
      child: GestureDetector(
        child: Card(
          child: Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
              child: returnImage(snapshot, index),
            ),
            SizedBox(width: width * 0.04),
            Container(
              width: width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: Text(
                      snapshot[index].title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: height * 0.025,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  FutureBuilder(
                    future: getRating(snapshot[index].id),
                    builder: (BuildContext context,
                        AsyncSnapshot<double> ratingSnapshot) {
                      return RatingUnclickable2(
                          unratedColor: ratingColor,
                          rating: ratingSnapshot.data);
                    },
                  ),
                ],
              ),
            ),
          ]),
        ),
        onTap: () {
          movieSelectedFromSearch = new Movie(
            title: snapshot[index].title,
            overview: snapshot[index].overview,
            voteAverage: snapshot[index].voteAverage,
            id: snapshot[index].id,
            releaseDate: snapshot[index].releaseDate,
            posterPath: snapshot[index].posterPath,
            voteCount: snapshot[index].voteCount,
            popularity: snapshot[index].popularity
          );

          Navigator.pushNamed(context, '/movie',
              arguments: ScreenArguments(language.search));
        },
      ),
    );
  }

  Widget getPersonResultsSearch(
      SearchResultsModel snapshot, int index, BuildContext context) {
    return Container(
      height: height * 0.15,
      child: GestureDetector(
        child: Card(
          child: Row(
            children: [
              SizedBox(
                width: width * 0.03,
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: width * 0.1,
                backgroundImage: NetworkImage(
                    getProfileImage(snapshot.results[index].profilePath)),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.results[index].name,
                    style: TextStyle(
                        fontFamily: 'Quicksand-Regular',
                        fontSize: width * 0.05),
                  ),
                  Text(
                    getKnownFor(snapshot, index),
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: width * 0.035,
                        color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          personSelectedFromSearch = new Person(
              id: snapshot.results[index].id,
              name: snapshot.results[index].name);
          Navigator.pushNamed(context, '/person',
              arguments: ScreenArguments(language.search));
        },
      ),
    );
  }

  String getProfileImage(String profilePath) {
    if (profilePath != null) {
      return 'https://image.tmdb.org/t/p/w185$profilePath';
    } else {
      return user_unknown;
    }
  }

  String getKnownFor(SearchResultsModel snapshot, index) {
    String knownFor;
    if (snapshot.results[index].knownForDepartment == 'Acting') {
      knownFor = language.occupation_actor;
    } else if (snapshot.results[index].knownForDepartment == 'Directing') {
      knownFor = language.occupation_directing;
    } else if (snapshot.results[index].knownForDepartment == "Writing") {
      knownFor = language.occupation_writer;
    } else if (snapshot.results[index].knownForDepartment == "Production") {
      knownFor = language.occupation_producer;
    } else if (snapshot.results[index].knownForDepartment == "Editing") {
      knownFor = language.occupation_editor;
    } else if (snapshot.results[index].knownForDepartment == "Costume & Make-Up") {
      knownFor = language.occupation_costume;
    } else if (snapshot.results[index].knownForDepartment == "Sound") {
      knownFor = language.occupation_composer;
    } else {
      knownFor = snapshot.results[index].knownForDepartment;
    }
    return knownFor;
  }

  Future<bool> getSearchResults(String queryString) async {
    bool loading = false;
    currentPage++;

    try {
      bloc = SearchResultsBloc(queryString, currentPage);
      await bloc.fetchSearchResults().then((response) {
        _streamController.add(response);
        loading = true;
      });
    } catch (e) {
      loading = false;
    }
    return loading;
  }
}

SearchResultsModel mergeRes(
    AsyncSnapshot<List<SearchResultsModel>> snapshot, currentPage) {
  List<SearchResults> results = [];
  int totalPages = 0;
  int totalResults = 0;
  SearchResultsModel model;
  for (int i = 0; i < snapshot.data.length; i++) {
    results = new List.from(results)..addAll(snapshot.data[i].results);
  }
  totalPages = snapshot.data[0].totalPages;
  totalResults = snapshot.data[0].totalResults;
  model = new SearchResultsModel(
    page: currentPage,
    results: results,
    totalPages: totalPages,
    totalResults: totalResults,
  );
  return model;
}
