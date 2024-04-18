import 'package:ciak_time/api_utils.dart';
import 'package:ciak_time/blocs/popular_movies_bloc.dart';
import 'package:ciak_time/components/movie_card.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/models/movie_model.dart';
import 'package:flutter/material.dart';

class PopularMovieList extends StatefulWidget {
  final String fromWhere;

  const PopularMovieList({Key key, @required this.fromWhere}) : super(key: key);

  @override
  State<PopularMovieList> createState() => _PopularMovieListState();
}

class _PopularMovieListState extends State<PopularMovieList> {

  @override
  void initState() {
    bloc.fetchPopularMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return StreamBuilder(
        stream: bloc.popularMovies,
        builder: (context, AsyncSnapshot<MovieModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
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

  Widget buildList(AsyncSnapshot<MovieModel> snapshot) {
    return Container(
      height: height * 0.26,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.results.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: MovieCard(
                imageUrl:
                    getImagePath(snapshot.data.results[index].posterPath),
                movieTitle: snapshot.data.results[index].title,
              ),
              onTap: () {
                String fromWhereArg;
                if (widget.fromWhere == "Home") {
                  movieSelectedFromHome = new Movie(
                    title: snapshot.data.results[index].title,
                    overview: snapshot.data.results[index].overview,
                    voteAverage: snapshot.data.results[index].voteAverage,
                    id: snapshot.data.results[index].id,
                    releaseDate: snapshot.data.results[index].releaseDate,
                    posterPath: snapshot.data.results[index].posterPath,
                    voteCount: snapshot.data.results[index].voteCount,
                    popularity: snapshot.data.results[index].popularity,
                  );
                  fromWhereArg = language.home;
                }
                if (widget.fromWhere == "Search") {
                  movieSelectedFromSearch = new Movie(
                    title: snapshot.data.results[index].title,
                    overview: snapshot.data.results[index].overview,
                    voteAverage: snapshot.data.results[index].voteAverage,
                    id: snapshot.data.results[index].id,
                    releaseDate: snapshot.data.results[index].releaseDate,
                    posterPath: snapshot.data.results[index].posterPath,
                    voteCount: snapshot.data.results[index].voteCount,
                    popularity: snapshot.data.results[index].popularity,
                  );
                  fromWhereArg = language.search;
                }

                Navigator.pushNamed(context, '/movie',
                    arguments: ScreenArguments(fromWhereArg));
              },
            );
          }),
    );
  }
}
