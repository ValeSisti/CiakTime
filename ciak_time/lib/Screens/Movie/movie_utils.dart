import 'package:ciak_time/Services/db_api.dart';
import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';

Future<String> getWatchListTitle(movieSelectedFrom) async {
  int isContained =
      await checkMovieInList("watchList", userId, movieSelectedFrom.id);
  if (isContained == 1) {
    watchListTitle = language.remove_watchlist;
  } else {
    watchListTitle = language.add_watchlist;
  }

  return watchListTitle;
}

Future<String> getAlreadyWatchedListTitle(movieSelectedFrom) async {
  int isContained =
      await checkMovieInList("alreadyWatched", userId, movieSelectedFrom.id);
  if (isContained == 1) {
    alreadyWatchedListTitle = language.remove_already_watched;
  } else {
    alreadyWatchedListTitle = language.add_already_watched;
  }
  return alreadyWatchedListTitle;
}

Future<String> getFavouriteListTitle(movieSelectedFrom) async {
  int isContained =
      await checkMovieInList("favourite", userId, movieSelectedFrom.id);
  if (isContained == 1) {
    favouriteListTitle = language.remove_favourite;
  } else {
    favouriteListTitle = language.add_favourite;
  }
  return favouriteListTitle;
}

Future<String> isMovieSeen(movieSelectedFrom) async {
  String movieSeen = "";
  int isContained =
      await checkMovieInList("alreadyWatched", userId, movieSelectedFrom.id);
  if (isContained == 1) {
    movieSeen = language.watched;
  } else {
    movieSeen = language.not_watched;
  }
  return movieSeen;
}

Future<Color> isMovieSeenColor(movieSelectedFrom) async {
  Color movieSeenColor;
  int isContained =
      await checkMovieInList("alreadyWatched", userId, movieSelectedFrom.id);
  if (isContained == 1) {
    movieSeenColor = themePrimaryColor;
  } else {
    movieSeenColor = Colors.grey;
  }
  return movieSeenColor;
}

Future<IconData> isMovieSeenIcon(movieSelectedFrom) async {
  IconData movieSeenIcon;
  int isContained =
      await checkMovieInList("alreadyWatched", userId, movieSelectedFrom.id);
  if (isContained == 1) {
    movieSeenIcon = Icons.visibility;
  } else {
    movieSeenIcon = Icons.visibility_off;
  }
  return movieSeenIcon;
}
