import 'package:ciak_time/blocs/movie_cast_bloc.dart';
import 'package:ciak_time/components/cast_card.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/models/movie_cast_model.dart';
import 'package:ciak_time/models/person.dart';
import 'package:flutter/material.dart';

class MovieCastList extends StatefulWidget {
  final Movie movieSelected;
  final String fromWhere;

  const MovieCastList(
      {Key key, @required this.movieSelected, @required this.fromWhere})
      : super(key: key);

  @override
  State<MovieCastList> createState() => _MovieCastListState();
}

class _MovieCastListState extends State<MovieCastList> {
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
    if (snapshot.data.cast[index].profilePath != null) {
      imagePath =
          'https://image.tmdb.org/t/p/w780${snapshot.data.cast[index].profilePath}';
    } else {
      imagePath = user_unknown;
    }
    return GestureDetector(
      onTap: () {
        Person person = new Person(
          id: snapshot.data.cast[index].id,
          name: snapshot.data.cast[index].name,
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
      child: CastCard(
        imageUrl: imagePath,
        personName: snapshot.data.cast[index].name,
        character: snapshot.data.cast[index].character,
      ),
    );
  }

  Widget buildList(AsyncSnapshot<MovieCastModel> snapshot) {
    if (snapshot.data.cast.length != 0) {
      return Container(
        height: height * 0.18,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.cast.length,
            itemBuilder: (BuildContext context, int index) {
              return returnImage(snapshot, index, context);
            }),
      );
    } else {
      return Text(
        language.no_cast,
        style: TextStyle(
          color: Colors.grey,
          fontSize: height * 0.02,
          fontFamily: 'Quicksand-Regular',
        ),
      );
    }
  }
}
