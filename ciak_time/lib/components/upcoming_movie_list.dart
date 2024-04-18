import 'package:ciak_time/api_utils.dart';
import 'package:ciak_time/blocs/upcoming_movies_bloc.dart';
import 'package:ciak_time/components/movie_card.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/models/movie_model.dart';
import 'package:flutter/material.dart';

class UpcomingMovieList extends StatefulWidget {
  const UpcomingMovieList({
    Key key,
  }) : super(key: key);

  @override
  State<UpcomingMovieList> createState() => _UpcomingMovieListState();
}

class _UpcomingMovieListState extends State<UpcomingMovieList> {

  @override
  void initState() {
    bloc.fetchUpcomingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: bloc.upcomingMovies,
      builder: (context, AsyncSnapshot<MovieModel> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot, size);
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

  Widget buildList(AsyncSnapshot<MovieModel> snapshot, size) {
    return Container(
      height: 200,
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
                Navigator.pushNamed(context, '/movie',
                    arguments: ScreenArguments(language.home));
              },
            );
          }),
    );
  }
}
