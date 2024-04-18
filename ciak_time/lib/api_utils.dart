import 'package:ciak_time/blocs/movie_details_bloc.dart';
import 'package:ciak_time/blocs/movie_videos_bloc.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie_details_model.dart';
import 'package:ciak_time/models/movie_videos_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

String durationToString(int minutes) {
  if (minutes != null) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0]} h ${parts[1].padLeft(2, '0')} min';
  } else {
    return language.no_duration;
  }
}

Widget GetGenresNames(List<Genres> genres) {
  if (genres.length != 0) {
    String allGenres = '';
    for (var i = 0; i < genres.length; i++) {
      allGenres = allGenres + genres[i].name;
      if (i != genres.length - 1) {
        allGenres = allGenres + ", ";
      }
    }
    return Container(
      width: width * 0.67,
      child: Text(
        allGenres,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: Colors.white,
          fontSize: height * 0.02,
          fontFamily: 'Quicksand-Regular',
        ),
      ),
    );
  } else {
    return Container(
      width: width * 0.4,
      child: Text(
        language.no_genre,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: Colors.white,
          fontSize: height * 0.02,
          fontFamily: 'Quicksand-Regular',
        ),
      ),
    );
  }
}

Widget GetReleaseDate(releaseDate) {
  if (releaseDate != "") {
    return Text(
      DateFormat.yMMMd(api_language).format(DateTime.parse(releaseDate)),
      style: TextStyle(
        fontSize: height * 0.02,
        fontFamily: 'Quicksand-Regular',
      ),
    );
  } else if (releaseDate == "") {
    return Text(
      language.no_date,
      style: TextStyle(
        color: Colors.grey,
        fontSize: height * 0.02,
        fontFamily: 'Quicksand-Regular',
      ),
    );
  } else {
    return Text(
      language.no_date,
      style: TextStyle(
        color: Colors.grey,
        fontSize: height * 0.02,
        fontFamily: 'Quicksand-Regular',
      ),
    );
  }
}

class MovieOverviewWidget extends StatefulWidget {
  const MovieOverviewWidget({@required this.movieId, Key key }) : super(key: key);
  final int movieId;
 

  @override
  State<MovieOverviewWidget> createState() => _MovieOverviewWidgetState();
}

class _MovieOverviewWidgetState extends State<MovieOverviewWidget> {
  MovieDetailsBloc bloc;
  @override
  void initState() {
    bloc = MovieDetailsBloc(widget.movieId.toString());
    bloc.fetchMovieDetailsResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.movieDetails,
      builder: (context, AsyncSnapshot<MovieDetailsModel> snapshot) {
        if (snapshot.hasData) {
          return getOverview(snapshot.data);
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
}

Widget getOverview(movieSelectedFrom) {
  if (movieSelectedFrom.overview != null && movieSelectedFrom.overview != "") {
    return ReadMoreText(
      movieSelectedFrom.overview,
      trimLines: 3,
      delimiter: '',
      colorClickableText: themePrimaryColor,
      trimMode: TrimMode.Line,
      trimCollapsedText: language.read_more,
      trimExpandedText: language.show_less,
      moreStyle: TextStyle(
          fontSize: width * 0.04,
          fontWeight: FontWeight.bold,
          color: themePrimaryColor),
      style: TextStyle(
        fontSize: height * 0.02,
        fontWeight: FontWeight.w600,
        fontFamily: 'Quicksand',
      ),
    );
  } else {
    return Text(
      language.no_plot,
      style: TextStyle(
        color: Colors.grey,
        fontSize: height * 0.02,
        fontWeight: FontWeight.w600,
        fontFamily: 'Quicksand',
      ),
    );
  }
}





class TrailerWidget extends StatefulWidget {
  const TrailerWidget({@required this.movieId, Key key}) : super(key: key);
  final int movieId;

  @override
  State<TrailerWidget> createState() => _TrailerWidgetState();
}

class _TrailerWidgetState extends State<TrailerWidget> {
  MovieVideosBloc bloc;
  @override
  void initState() {
    bloc = MovieVideosBloc(widget.movieId.toString());

    bloc.fetchMovieVideosResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.videosList,
      builder: (context, AsyncSnapshot<VideosModel> snapshot) {
        if (snapshot.hasData) {
          VideoResults trailer = null;
          for (var i = 0; i < snapshot.data.results.length; i++) {
            if (snapshot.data.results[i].type == "Trailer") {
              trailer = snapshot.data.results[i];
              break;
            }
          }
          return buildTrailer(trailer);
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

  Widget buildTrailer(VideoResults trailer) {
    if (trailer != null) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: height * 0.01,
        ),
        Divider(color: themeDividerColor),
        Text(language.trailer,
            style: TextStyle(
                color: themePrimaryColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Quicksand',
                fontSize: height * 0.025)),
        SizedBox(
          height: height * 0.01,
        ),
        YouTubeTrailer(trailer: trailer),
      ]);
    } else {
      return Container();
    }
  }
}

class YouTubeTrailer extends StatefulWidget {
  const YouTubeTrailer({@required this.trailer, Key key}) : super(key: key);
  final VideoResults trailer;

  @override
  _YouTubeTrailerState createState() => _YouTubeTrailerState();
}

class _YouTubeTrailerState extends State<YouTubeTrailer> {
  YoutubePlayerController _controller;
  bool fullScreen = false;
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.trailer.key,
      params: YoutubePlayerParams(
        mute: false,
        showFullscreenButton: true,
        autoPlay: true,
        loop: false,
        enableCaption: true,
        interfaceLanguage: locale.toString(),
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    };
    _controller.onExitFullscreen = () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: YoutubePlayerIFrame(
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
        aspectRatio: 16 / 9,
      ),
    );
  }
}

String getImagePath(String posterPath) {
  if (posterPath == null) {
    return "http://www.persefone.it/blog/wp-content/themes/photobook/images/blank.png";
  } else {
    return 'https://image.tmdb.org/t/p/w780$posterPath';
  }
}
