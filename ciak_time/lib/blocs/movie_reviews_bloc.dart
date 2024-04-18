import 'package:ciak_time/models/reviews_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieReviewsBloc {
  final _repository = Repository();
  String movieId = "";

  MovieReviewsBloc(String movieId) {
    this.movieId = movieId;
  }

  final _reviewsFetcher = PublishSubject<ReviewsModel>();

  Stream<ReviewsModel> get reviewsList => _reviewsFetcher.stream;

  fetchMovieReviewsResults() async {
    ReviewsModel reviewsModel = await _repository.fetchReviewsResults(movieId);
    _reviewsFetcher.sink.add(reviewsModel);
  }

  dispose() {
    _reviewsFetcher.close();
  }
}
