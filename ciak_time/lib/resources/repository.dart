import 'dart:async';
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

import 'movie_api_provider.dart';

class Repository {
  final moviesApiProvider = MovieApiProvider();
  String queryString = "";

  Future<MovieModel> fetchPopularMovies() =>
      moviesApiProvider.fetchPopularMovieList();
  Future<MovieModel> fetchUpcomingMovies() =>
      moviesApiProvider.fetchUpcomingMovieList();
  Future<PersonModel> fetchPopularPeople() =>
      moviesApiProvider.fetchPopularPeopleList();
  Future<MovieImagesModel> fetchMovieImagesResults(movieId) =>
      moviesApiProvider.fetchMovieImagesList(movieId);
  Future<MovieDetailsModel> fetchMovieDetailsResults(movieId) =>
      moviesApiProvider.fetchMovieDetailsList(movieId);
  Future<WatchProvidersModel> fetchWatchProvidersResults(movieId) =>
      moviesApiProvider.fetchWatchProvidersList(movieId);
  Future<MovieCastModel> fetchMovieCastResults(movieId) =>
      moviesApiProvider.fetchMovieCastList(movieId);
  Future<PersonDetailsModel> fetchPersonDetailsResults(personId) =>
      moviesApiProvider.fetchPersonDetails(personId);
  Future<PersonMoviesModel> fetchPersonMoviesResults(personId) =>
      moviesApiProvider.fetchPersonMoviesList(personId);
  Future<ReviewsModel> fetchReviewsResults(movieId) =>
      moviesApiProvider.fetchReviewsList(movieId);
  Future<List<SearchResultsModel>> fetchSearchResults(
          queryString, currentPage) =>
      moviesApiProvider.fetchSearchResultsList(queryString, currentPage);
  Future<VideosModel> fetchMovieVideosResults(movieId) =>
      moviesApiProvider.fetchMovieVideosList(movieId);
}
