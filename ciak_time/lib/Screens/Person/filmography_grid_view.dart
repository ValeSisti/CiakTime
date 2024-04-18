import 'package:ciak_time/api_utils.dart';
import 'package:ciak_time/blocs/person_movies_bloc.dart';
import 'package:ciak_time/components/movie_card.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/models/person_movies_model.dart';
import 'package:ciak_time/utils/utils.dart';
import 'package:flutter/material.dart';

class FilmographyGridView extends StatefulWidget {
  final String personName;
  final String fromWhere;
  final int personId;
  const FilmographyGridView(
      {Key key,
      @required this.personName,
      @required this.fromWhere,
      @required this.personId})
      : super(key: key);

  @override
  _FilmographyGridViewState createState() => _FilmographyGridViewState();
}

class _FilmographyGridViewState extends State<FilmographyGridView> {
  PersonMoviesBloc bloc;
  @override
  void initState() {
    bloc = PersonMoviesBloc(widget.personId.toString());

    bloc.fetchPersonMoviesResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PersonMoviesModel>(
        stream: bloc.personMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(language.filmography),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                leadingWidth: 40,
              ),
              body: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: setGridNumber(),
                      childAspectRatio: setGridRatio()),
                  itemCount: snapshot.data.movies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (widget.fromWhere == "Home") {
                          movieSelectedFromHome = new Movie(
                              title: snapshot.data.movies[index].title,
                              overview: snapshot.data.movies[index].overview,
                              voteAverage:
                                  snapshot.data.movies[index].voteAverage,
                              id: snapshot.data.movies[index].id,
                              releaseDate:
                                  snapshot.data.movies[index].releaseDate,
                              posterPath:
                                  snapshot.data.movies[index].posterPath,
                              voteCount: snapshot.data.movies[index].voteCount,
                              popularity:
                                  snapshot.data.movies[index].popularity);
                        }
                        if (widget.fromWhere == "Search") {
                          movieSelectedFromSearch = new Movie(
                              title: snapshot.data.movies[index].title,
                              overview: snapshot.data.movies[index].overview,
                              voteAverage:
                                  snapshot.data.movies[index].voteAverage,
                              id: snapshot.data.movies[index].id,
                              releaseDate:
                                  snapshot.data.movies[index].releaseDate,
                              posterPath:
                                  snapshot.data.movies[index].posterPath,
                              voteCount: snapshot.data.movies[index].voteCount,
                              popularity:
                                  snapshot.data.movies[index].popularity);
                        }
                        if (widget.fromWhere == "User") {
                          movieSelectedFromUser = new Movie(
                              title: snapshot.data.movies[index].title,
                              overview: snapshot.data.movies[index].overview,
                              voteAverage:
                                  snapshot.data.movies[index].voteAverage,
                              id: snapshot.data.movies[index].id,
                              releaseDate:
                                  snapshot.data.movies[index].releaseDate,
                              posterPath:
                                  snapshot.data.movies[index].posterPath,
                              voteCount: snapshot.data.movies[index].voteCount,
                              popularity:
                                  snapshot.data.movies[index].popularity);
                        }
                        Navigator.pushNamed(context, '/movie',
                            arguments: ScreenArguments("Filmography"));
                      },
                      child: MovieCard(
                        imageUrl: getImagePath(
                            snapshot.data.movies[index].posterPath),
                        movieTitle: snapshot.data.movies[index].title,
                      ),
                    );
                  }),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          ));
        });
  }
}
