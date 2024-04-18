import 'package:ciak_time/models/movie_videos_model.dart';
import 'package:ciak_time/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieVideosBloc {
  final _repository = Repository();
  String movieId = "";

  MovieVideosBloc(String movieId) {
    this.movieId = movieId;
  }

  final _videosFetcher = PublishSubject<VideosModel>();

  Stream<VideosModel> get videosList => _videosFetcher.stream;

  fetchMovieVideosResults() async {
    VideosModel videosModel = await _repository.fetchMovieVideosResults(movieId);
    _videosFetcher.sink.add(videosModel);
  }

  dispose() {
    _videosFetcher.close();
  }
}