import 'dart:convert';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/models/movie_details_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:http/http.dart' as http;

fetchData(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}

pushData(String url) async {
  http.Response response = await http.post(Uri.parse(url));
  return response.body;
}

deleteData(String url) async {
  http.Response response = await http.delete(Uri.parse(url));
  return response.body;
}

Future<List<Movie>> getListFromDB(listName) async {
  List<Movie> list = [];
  String url = 'https://mauroficorella.pythonanywhere.com/' +
      listName +
      '?userId=' +
      userId;
  final _repository = Repository();
  var data = await fetchData(url);
  var decoded = await jsonDecode(data);

  for (var valentano in decoded[listName]) {
    MovieDetailsModel movieDetails =
        await _repository.fetchMovieDetailsResults(valentano['movieId']);
    Movie movie = new Movie(
        title: movieDetails.title,
        overview: movieDetails.overview,
        voteAverage: movieDetails.voteAverage,
        id: movieDetails.id,
        releaseDate: movieDetails.releaseDate,
        posterPath: movieDetails.posterPath,
        voteCount: movieDetails.voteCount,
        popularity: movieDetails.popularity);
    list.add(movie);
  }
  return list;
}

Future<List<List<Movie>>> getListsFromDB() async {
  List<Movie> alreadyWatchedList = [];
  List<Movie> favouriteList = [];
  List<Movie> watchList = [];
  String url = 'https://mauroficorella.pythonanywhere.com/' +
      "alreadyWatched" +
      '?userId=' +
      userId;
  final _repository = Repository();
  var data = await fetchData(url);
  var decoded = await jsonDecode(data);
  for (var valentano in decoded["alreadyWatched"]) {
    MovieDetailsModel movieDetails =
        await _repository.fetchMovieDetailsResults(valentano['movieId']);
    Movie movie = new Movie(
        title: movieDetails.title,
        overview: movieDetails.overview,
        voteAverage: movieDetails.voteAverage,
        id: movieDetails.id,
        releaseDate: movieDetails.releaseDate,
        posterPath: movieDetails.posterPath,
        voteCount: movieDetails.voteCount,
        popularity: movieDetails.popularity);
    alreadyWatchedList.add(movie);
  }
  url = 'https://mauroficorella.pythonanywhere.com/' +
      "favourite" +
      '?userId=' +
      userId;
  data = await fetchData(url);
  decoded = await jsonDecode(data);
  for (var valentano in decoded["favourite"]) {
    MovieDetailsModel movieDetails =
        await _repository.fetchMovieDetailsResults(valentano['movieId']);
    Movie movie = new Movie(
        title: movieDetails.title,
        overview: movieDetails.overview,
        voteAverage: movieDetails.voteAverage,
        id: movieDetails.id,
        releaseDate: movieDetails.releaseDate,
        posterPath: movieDetails.posterPath,
        voteCount: movieDetails.voteCount,
        popularity: movieDetails.popularity);
    favouriteList.add(movie);
  }
  url = 'https://mauroficorella.pythonanywhere.com/' +
      "watchList" +
      '?userId=' +
      userId;
  data = await fetchData(url);
  decoded = await jsonDecode(data);
  for (var valentano in decoded["watchList"]) {
    MovieDetailsModel movieDetails =
        await _repository.fetchMovieDetailsResults(valentano['movieId']);
    Movie movie = new Movie(
        title: movieDetails.title,
        overview: movieDetails.overview,
        voteAverage: movieDetails.voteAverage,
        id: movieDetails.id,
        releaseDate: movieDetails.releaseDate,
        posterPath: movieDetails.posterPath,
        voteCount: movieDetails.voteCount,
        popularity: movieDetails.popularity);
    watchList.add(movie);
  }
  return [watchList, alreadyWatchedList, favouriteList];
}

void addMovieToDBList(listName, userId, movieId, title, overview, voteAverage,
    releaseDate, posterPath, voteCount) async {
  String url =
      'https://mauroficorella.pythonanywhere.com/addMovie?listName=$listName&userId=$userId&movieId=$movieId&title=$title&overview=$overview&voteAverage=$voteAverage&releaseDate=$releaseDate&posterPath=$posterPath&voteCount=$voteCount';
  await pushData(url);
}

void deleteMovieFromDBList(listName, userId, movieId) async {
  String url =
      'https://mauroficorella.pythonanywhere.com/deleteMovie?listName=$listName&userId=$userId&movieId=$movieId';
  await deleteData(url);
}

Future<int> checkMovieInList(listName, userId, movieId) async {
  String url =
      'https://mauroficorella.pythonanywhere.com/checkMovieInList?listName=$listName&userId=$userId&movieId=$movieId';
  var data = await fetchData(url);
  var decoded = await jsonDecode(data);
  return decoded["isMovieInList"];
}
