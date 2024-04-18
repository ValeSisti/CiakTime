import 'package:ciak_time/components/popular_movie_list.dart';
import 'package:ciak_time/components/popular_people_list.dart';
import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';

class CardsWidget extends StatelessWidget {
  const CardsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        children: [
          SizedBox(
            height: height * 0.025,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: getBodyContent(),
            ),
          ),
        ],
      ),
    );
  }

  Column getBodyContent() {
    if (tabSelected == "Movie") {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 2.0),
            child: Text(
              language.popular_movies_searches,
              style: TextStyle(
                  color: themePrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Quicksand',
                  fontSize: width * 0.062),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
            child: PopularMovieList(
              fromWhere: "Search",
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 2.0),
            child: Text(
              language.popular_people_searches,
              style: TextStyle(
                  color: themePrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Quicksand',
                  fontSize: width * 0.062),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
            child: PopularPeopleList(
              fromWhere: "Search",
            ),
          ),
        ],
      );
    }
  }
}
