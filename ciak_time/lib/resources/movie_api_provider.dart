import 'dart:async';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie_cast_model.dart';
import 'package:ciak_time/models/movie_details_model.dart';
import 'package:ciak_time/models/movie_images_model.dart';
import 'package:ciak_time/models/movie_model.dart';
import 'package:ciak_time/models/movie_videos_model.dart';
import 'package:ciak_time/models/person_details_model.dart';
import 'package:ciak_time/models/person_model.dart';
import 'package:ciak_time/models/person_movies_model.dart';
import 'package:ciak_time/models/reviews_model.dart';
import 'package:ciak_time/models/search_results_model.dart';
import 'package:ciak_time/models/watch_providers_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class MovieApiProvider {
  Client client = Client();
  final _apiKey = '2d5faa7cea05a407ab79da921919b5f3';

  Future<MovieModel> fetchPopularMovieList() async {
    final response = await client.get(Uri.parse(
        "http://api.themoviedb.org/3/movie/popular?api_key=$_apiKey&language=$api_language"));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return MovieModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load popular movies');
    }
  }

  Future<MovieModel> fetchUpcomingMovieList() async {
    final response = await client.get(Uri.parse(
        "http://api.themoviedb.org/3/movie/upcoming?api_key=$_apiKey&language=$api_language"));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return MovieModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<PersonModel> fetchPopularPeopleList() async {
    final response = await client.get(Uri.parse(
        "https://api.themoviedb.org/3/person/popular?api_key=$_apiKey&language=$api_language"));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return PersonModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load popular people');
    }
  }

  Future<MovieImagesModel> fetchMovieImagesList(movieId) async {
    final response = await client.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/$movieId/images?api_key=$_apiKey&language=$api_language&include_image_language=en"));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return MovieImagesModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load movie images');
    }
  }

  Future<MovieDetailsModel> fetchMovieDetailsList(movieId) async {
    final response = await client.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey&language=$api_language"));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return MovieDetailsModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load movie details');
    }
  }

  Future<WatchProvidersModel> fetchWatchProvidersList(movieId) async {
    final response = await client.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/$movieId/watch/providers?api_key=$_apiKey"));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return WatchProvidersModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load watch providers');
    }
  }

  Future<MovieCastModel> fetchMovieCastList(movieId) async {
    final response = await client.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$_apiKey&language=$api_language"));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return MovieCastModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load movie cast');
    }
  }

  Future<PersonDetailsModel> fetchPersonDetails(personId) async {
    final response = await client.get(Uri.parse(
        "https://api.themoviedb.org/3/person/$personId?api_key=$_apiKey&language=$api_language"));

    if (response.statusCode == 200) {
      PersonDetailsModel personDetailsModel =
          PersonDetailsModel.fromJson(json.decode(response.body));
      if (personDetailsModel.biography == "" || personDetailsModel.biography == null) {
        final responseEng = await client.get(Uri.parse(
            "https://api.themoviedb.org/3/person/$personId?api_key=$_apiKey&language=en-US"));
        if (response.statusCode == 200) {
          PersonDetailsModel personDetailsModelEng =
              PersonDetailsModel.fromJson(json.decode(responseEng.body));
          personDetailsModel.biography = personDetailsModelEng.biography;
        }
      }
      // If the call to the server was successful, parse the JSON
      return personDetailsModel;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load person details');
    }
  }

  Future<PersonMoviesModel> fetchPersonMoviesList(personId) async {
    final response = await client.get(Uri.parse(
        "https://api.themoviedb.org/3/person/$personId/movie_credits?api_key=$_apiKey&language=$api_language"));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return PersonMoviesModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load person movies');
    }
  }

  Future<ReviewsModel> fetchReviewsList(movieId) async {
    final response = await client.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=$_apiKey&language=$api_language"));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ReviewsModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load reviews');
    }
  }

  Future<List<SearchResultsModel>> fetchSearchResultsList(
      queryString, currentPage) async {
    List<SearchResultsModel> results = [];
    for (var i = 1; i <= currentPage; i++) {
      final response = await client.get(Uri.parse(
          "https://api.themoviedb.org/3/search/multi?api_key=$_apiKey&language=$api_language&query=$queryString&page=$i&include_adult=false"));
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        results.add(SearchResultsModel.fromJson(json.decode(response.body)));
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load search results');
      }
    }

    return results;
  }

  Future<VideosModel> fetchMovieVideosList(movieId) async {
    final response = await client.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$_apiKey&language=$api_language"));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return VideosModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load reviews');
    }
  }
}
