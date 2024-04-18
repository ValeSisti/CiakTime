import 'dart:async';
import 'dart:ui';
import 'package:ciak_time/blocs/popular_movies_bloc.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/models/movie_model.dart';
import 'package:ciak_time/utils/device_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:ciak_time/constants.dart';

class CarouselWidgetLandscape extends StatefulWidget {
  const CarouselWidgetLandscape({Key key, @required this.callback})
      : super(key: key);

  final Function callback;

  @override
  _CarouselWidgetLandscapeState createState() =>
      _CarouselWidgetLandscapeState();
}

class _CarouselWidgetLandscapeState extends State<CarouselWidgetLandscape> {
  int _currentPage = 0;
  double y;
  double appoggio = 0;
  final PageController pageController = PageController(viewportFraction: 0.5);
  bool hasChanged = false;
  bool canMove = true;
  StreamSubscription<AccelerometerEvent> _accelerometerListener;
  StreamSubscription<GyroscopeEvent> _gyroscopeListener;

  @override
  void initState() {
    bloc.fetchPopularMovies();
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    carouselLandscapeModeOnly();

    _accelerometerListener =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        y = event.y;
      });
    });

    _gyroscopeListener = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients) {
            if (event.z < -0.5 && y > 0 && canMove) {
              canMove = false;
              pageController
                  .animateToPage(_currentPage + 1,
                      duration: Duration(seconds: 1), curve: Curves.linear)
                  .then((value) => canMove = true);
            } else if (event.z > 0.5 && y < 0 && canMove) {
              canMove = false;
              pageController
                  .animateToPage(_currentPage - 1,
                      duration: Duration(seconds: 1), curve: Curves.linear)
                  .then((value) => canMove = true);
            }
          }
        });
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    enableRotation();
    _accelerometerListener.cancel();
    _gyroscopeListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: bloc.popularMovies,
        builder: (context, AsyncSnapshot<MovieModel> snapshot) {
          if (snapshot.hasData) {
            return _buildCarousel(context, snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          ));
        },
      ),
    );
  }

  Widget _buildCarousel(
      BuildContext context, AsyncSnapshot<MovieModel> snapshot) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Container(
            key: ValueKey<int>(snapshot.data.results[_currentPage].id),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://image.tmdb.org/t/p/w1280${snapshot.data.results[_currentPage].backdropPath}'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 10.0, sigmaY: 10.0, tileMode: TileMode.clamp),
              child: Container(
                height: 400,
                color: Colors.white.withOpacity(0.0),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      enableRotation();
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: width * 0.07,
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: pageController,
                itemCount: snapshot.data.results.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return AnimatedScale(
                    duration: Duration(milliseconds: 300),
                    scale: index == _currentPage ? 1 : 0.7,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 230,
                            width: 400,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w1280${snapshot.data.results[index].backdropPath}',
                                fit: BoxFit.cover,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                          onTap: () {
                            movieSelectedFromHome = new Movie(
                                title: snapshot.data.results[index].title,
                                overview: snapshot.data.results[index].overview,
                                voteAverage:
                                    snapshot.data.results[index].voteAverage,
                                id: snapshot.data.results[index].id,
                                releaseDate:
                                    snapshot.data.results[index].releaseDate,
                                posterPath:
                                    snapshot.data.results[index].posterPath,
                                voteCount:
                                    snapshot.data.results[index].voteCount,
                                popularity:
                                    snapshot.data.results[index].popularity);
                            Navigator.pushNamed(context, '/movie',
                                    arguments: ScreenArguments(language.home))
                                .then((value) {
                              widget.callback(false);
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.landscapeRight,
                                DeviceOrientation.landscapeLeft,
                              ]);
                            });
                            widget.callback(true);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 300,
                          child: Text(
                            snapshot.data.results[index].title.toUpperCase(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(-1.5, 1.5),
                                  color: Colors.black87,
                                )
                              ],
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
