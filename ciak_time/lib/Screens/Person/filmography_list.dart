import 'package:ciak_time/api_utils.dart';
import 'package:ciak_time/blocs/person_movies_bloc.dart';
import 'package:ciak_time/components/list_card.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/models/person_movies_model.dart';
import 'package:ciak_time/utils/utils.dart';
import 'package:flutter/material.dart';

class FilmographyList extends StatefulWidget {
  const FilmographyList({
    Key key,
    @required this.fromWhere,
  }) : super(key: key);

  final String fromWhere;

  @override
  State<FilmographyList> createState() => _FilmographyListState();
}

class _FilmographyListState extends State<FilmographyList> {
  PersonMoviesBloc bloc;
  @override
  void initState() {
    if (widget.fromWhere == "Home") {
      bloc = PersonMoviesBloc(personSelectedFromHome.id.toString());
    }
    if (widget.fromWhere == "Search") {
      bloc = PersonMoviesBloc(personSelectedFromSearch.id.toString());
    }
    if (widget.fromWhere == "User") {
      bloc = PersonMoviesBloc(personSelectedFromUser.id.toString());
    }
    bloc.fetchPersonMoviesResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedPersonMoviesFromHome = [];
    selectedPersonMoviesFromSearch = [];
    selectedPersonMoviesFromUser = [];

    return StreamBuilder(
      stream: bloc.personMovies,
      builder: (context, AsyncSnapshot<PersonMoviesModel> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.movies.length != 0) {
            for (var i = 0; i < snapshot.data.movies.length; i++) {
              Movie movie = new Movie(
                  title: snapshot.data.movies[i].title,
                  overview: snapshot.data.movies[i].overview,
                  voteAverage: snapshot.data.movies[i].voteAverage,
                  id: snapshot.data.movies[i].id,
                  releaseDate: snapshot.data.movies[i].releaseDate,
                  posterPath: snapshot.data.movies[i].posterPath,
                  voteCount: snapshot.data.movies[i].voteCount,
                  popularity: snapshot.data.movies[i].popularity);
              if (widget.fromWhere == "Home") {
                selectedPersonMoviesFromHome.add(movie);
              }
              if (widget.fromWhere == "Search") {
                selectedPersonMoviesFromSearch.add(movie);
              }
              if (widget.fromWhere == "User") {
                selectedPersonMoviesFromUser.add(movie);
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.filmography,
                        style: TextStyle(
                            color: themePrimaryColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Quicksand',
                            fontSize: height * 0.025)),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/filmography');
                      },
                      label:
                          Icon(Icons.arrow_forward, color: themePrimaryColor),
                      icon: Text(
                        language.view_all,
                        style: TextStyle(
                            color: themePrimaryColor,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Quicksand'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                buildFilmography(snapshot),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language.filmography,
                    style: TextStyle(
                        color: themePrimaryColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        fontSize: height * 0.025)),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  language.no_filmography,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: height * 0.02,
                    fontFamily: 'Quicksand',
                  ),
                ),
              ],
            );
          }
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

  Widget buildFilmography(AsyncSnapshot<PersonMoviesModel> snapshot) {
    return Container(
      height: height * 0.17,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: setLenght(snapshot.data.movies),
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.all(3.0),
          child: GestureDetector(
            child: ListCard(
              movieTitle: snapshot.data.movies[index].title,
              imageUrl: getImagePath(snapshot.data.movies[index].posterPath),
            ),
            onTap: () {
              Movie movie = new Movie(
                  title: snapshot.data.movies[index].title,
                  overview: snapshot.data.movies[index].overview,
                  voteAverage: snapshot.data.movies[index].voteAverage,
                  id: snapshot.data.movies[index].id,
                  releaseDate: snapshot.data.movies[index].releaseDate,
                  posterPath: snapshot.data.movies[index].posterPath,
                  voteCount: snapshot.data.movies[index].voteCount,
                  popularity: snapshot.data.movies[index].popularity);
              String fromWhereArg;
              if (widget.fromWhere == "Home") {
                movieSelectedFromHome = movie;
                fromWhereArg = personSelectedFromHome.name;
              }
              if (widget.fromWhere == "Search") {
                movieSelectedFromSearch = movie;
                fromWhereArg = personSelectedFromSearch.name;
              }
              if (widget.fromWhere == "User") {
                movieSelectedFromUser = movie;
                fromWhereArg = personSelectedFromUser.name;
              }
              Navigator.pushNamed(context, '/movie',
                  arguments: ScreenArguments(fromWhereArg));
            },
          ),
        ),
      ),
    );
  }
}
