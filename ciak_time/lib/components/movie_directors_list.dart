import 'package:ciak_time/blocs/movie_cast_bloc.dart';
import 'package:ciak_time/components/director_card.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/models/movie_cast_model.dart';
import 'package:ciak_time/models/person.dart';
import 'package:flutter/material.dart';

class MovieDirectorsList extends StatefulWidget {
  final Movie movieSelected;
  final String fromWhere;

  const MovieDirectorsList({
    Key key,
    @required this.movieSelected,
    @required this.fromWhere,
  }) : super(key: key);

  @override
  State<MovieDirectorsList> createState() => _MovieDirectorsListState();
}

class _MovieDirectorsListState extends State<MovieDirectorsList> {
  MovieCastBloc bloc;
  @override
  void initState() {
    bloc = MovieCastBloc(widget.movieSelected.id.toString());
    bloc.fetchMovieCastResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.castList,
      builder: (context, AsyncSnapshot<MovieCastModel> snapshot) {
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

  Widget returnImage(snapshot, index, context) {
    String imagePath;
    if (snapshot.data.directors[index].profilePath != null) {
      imagePath =
          'https://image.tmdb.org/t/p/w780${snapshot.data.directors[index].profilePath}';
    } else {
      imagePath = user_unknown;
    }
    return GestureDetector(
      onTap: () {
        Person person = new Person(
          id: snapshot.data.directors[index].id,
          name: snapshot.data.directors[index].name,
        );
        String fromWhereArg;
        if (widget.fromWhere == "Home") {
          personSelectedFromHome = person;
          fromWhereArg = movieSelectedFromHome.title;
        }
        if (widget.fromWhere == "Search") {
          personSelectedFromSearch = person;
          fromWhereArg = movieSelectedFromSearch.title;
        }
        if (widget.fromWhere == "User") {
          personSelectedFromUser = person;
          fromWhereArg = movieSelectedFromUser.title;
        }

        Navigator.pushNamed(context, '/person',
            arguments: ScreenArguments(fromWhereArg));
      },
      child: DirectorCard(
          imageUrl: imagePath, personName: snapshot.data.directors[index].name),
    );
  }

  Widget buildList(AsyncSnapshot<MovieCastModel> snapshot) {
    if (snapshot.data.directors.length != 0) {
      return Container(
        height: height * 0.17,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.directors.length,
            itemBuilder: (BuildContext context, int index) {
              return returnImage(snapshot, index, context);
            }),
      );
    } else {
      return Text(
        language.no_movie_director,
        style: TextStyle(
          color: Colors.grey,
          fontSize: height * 0.02,
          fontFamily: 'Quicksand-Regular',
        ),
      );
    }
  }
}
