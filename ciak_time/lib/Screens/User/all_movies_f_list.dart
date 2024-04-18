import 'dart:async';
import 'package:ciak_time/Services/db_api.dart';
import 'package:ciak_time/api_utils.dart';
import 'package:ciak_time/components/movie_card.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/utils/utils.dart';
import 'package:flutter/material.dart';

class AllMoviesInFList extends StatefulWidget {
  const AllMoviesInFList({Key key}) : super(key: key);

  @override
  _AllMoviesInFListState createState() => _AllMoviesInFListState();
}

class _AllMoviesInFListState extends State<AllMoviesInFList> {
  List<Movie> favouriteList = [];

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getListFromDB("favourite"),
        builder:
            (BuildContext context, AsyncSnapshot<List<Movie>> snapshotown) {
          if (snapshotown.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(language.favourite),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Row(children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ]),
                ),
                leadingWidth: 40,
              ),
              body: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: setGridNumber(),
                      childAspectRatio: setGridRatio()),
                  itemCount: snapshotown.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: MovieCard(
                        imageUrl:
                            getImagePath(snapshotown.data[index].posterPath),
                        movieTitle: snapshotown.data[index].title,
                      ),
                      onTap: () {
                        movieSelectedFromUser = snapshotown.data[index];
                        Navigator.pushNamed(context, '/movie',
                                arguments: ScreenArguments("Favourite"))
                            .then(onGoBack);
                      },
                    );
                  }),
            );
          } else if (snapshotown.hasError) {
            return Text(snapshotown.error.toString());
          }

          return Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          ));
        });
  }
}
