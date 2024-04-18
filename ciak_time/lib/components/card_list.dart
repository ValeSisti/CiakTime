import 'dart:async';
import 'package:ciak_time/components/list_card.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/utils/utils.dart';
import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  const CardList({
    Key key,
    this.title,
    this.number,
    this.list,
    @required this.onGoBack,
  }) : super(key: key);

  final String title;
  final int number;
  final FutureOr onGoBack;

  final List<Movie> list;

  Widget getViewAllButton(context) {
    if (list.isNotEmpty) {
      return ViewAllButton(
        listName: title,
        onGoBack: onGoBack,
      );
    } else {
      return Container();
    }
  }

  Widget getListContent(context) {
    if (list.isNotEmpty) {
      return Row(
        children: [
          Container(
            height: height * 0.17,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: setLenght(list),
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.all(3.0),
                child: GestureDetector(
                  child: ListCard(
                    movieTitle: list[index].title,
                    imageUrl:
                        'https://image.tmdb.org/t/p/w780${list[index].posterPath}',
                  ),
                  onTap: () {
                    movieSelectedFromUser = list[index];
                    Navigator.pushNamed(context, '/movie',
                            arguments: ScreenArguments(language.user))
                        .then(onGoBack);
                  },
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 12.0),
        child: Text(
          language.no_movie_added,
          style: TextStyle(
            fontSize: height * 0.02,
            fontFamily: 'Quicksand',
            color: Colors.grey,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: width * 0.025,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: themePrimaryColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Quicksand',
                    fontSize: height * 0.025,
                  ),
                ),
              ],
            ),
            getViewAllButton(context),
          ],
        ),
        getListContent(context),
      ],
    );
  }
}

class ViewAllButton extends StatefulWidget {
  const ViewAllButton({Key key, @required this.listName, @required this.onGoBack}) : super(key: key);

  final String listName;
  final FutureOr onGoBack;

  @override
  State<ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<ViewAllButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        if (widget.listName == language.watchlist) {
          Navigator.pushNamed(context, '/watchlist').then(widget.onGoBack);
        }
        if (widget.listName == language.already_watched) {
          Navigator.pushNamed(context, '/alreadywatchedlist').then(widget.onGoBack);
        }
        if (widget.listName == language.favourite) {
          Navigator.pushNamed(context, '/favouritelist').then(widget.onGoBack);
        }
      },
      label: Icon(Icons.arrow_forward, color: themePrimaryColor),
      icon: Text(
        language.view_all,
        style: TextStyle(
            color: themePrimaryColor,
            fontSize: height * 0.02,
            fontWeight: FontWeight.w800,
            fontFamily: 'Quicksand'),
      ),
    );
  }
}
