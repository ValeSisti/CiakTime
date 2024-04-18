import 'dart:ui';
import 'package:ciak_time/Screens/Homescreen/carousel_utils.dart';
import 'package:ciak_time/Screens/Homescreen/carousel_widget_landscape.dart';
import 'package:ciak_time/blocs/popular_movies_bloc.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/models/movie_model.dart';
import 'package:ciak_time/utils/device_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ciak_time/constants.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({Key key, @required this.callback}) : super(key: key);

  final Function callback;

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int _currentPage = 0;

  @override
  void initState() {
    bloc.fetchPopularMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
    );
  }

  Widget _buildCarousel(
      BuildContext context, AsyncSnapshot<MovieModel> snapshot) {
    PageController pageController =
        PageController(viewportFraction: setViewportFraction());
    return Stack(
      alignment: Alignment(-4.0, -4.0),
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Container(
            height: heightCarouselContainer(),
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
                  sigmaX: 8.0, sigmaY: 8.0, tileMode: TileMode.clamp),
              child: Container(
                decoration:
                    new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),
        ),
        Container(
          height: heightCarouselContainer(),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                  ],
                  stops: [
                    0.0,
                    1.0,
                  ])),
        ),
        Column(
          children: [
            Container(
              height: height * 0.12,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.transparent,
                  ],
                      stops: [
                    0.0,
                    1.0
                  ])),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 20.0, 8.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      language.popular_movies,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        fontSize: width * 0.07,
                        shadows: [
                          Shadow(offset: Offset(1, 1), color: Colors.black87),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    IconButton(
                      onPressed: () {
                        widget.callback(false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CarouselWidgetLandscape(
                                  callback: widget.callback);
                            },
                          ),
                        ).then((value) {
                          enableRotation();
                          widget.callback(true);
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown,
                          ]);
                        });
                      },
                      icon: Icon(
                        Icons.view_carousel_outlined,
                        size: width * 0.07,
                      ),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: heightSizedBox1()),
            SizedBox(
              height: heightSizedBox2(),
              child: Container(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: snapshot.data.results.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: AnimatedScale(
                        duration: Duration(milliseconds: 300),
                        scale: index == _currentPage ? 1 : setRatio(),
                        child: Stack(alignment: Alignment.center, children: [
                          Container(
                            height: heightCarousel(),
                            width: widthCarousel(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w1280${snapshot.data.results[index].backdropPath}',
                                fit: BoxFit.cover,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: heightBoxDecoration(),
                              width: widthCarousel(),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8),
                                    ],
                                    stops: [
                                      0.0,
                                      1.0
                                    ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            child: Container(
                              width: widthCarousel(),
                              child: Text(
                                snapshot.data.results[index].title,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Quicksand-Regular',
                                  shadows: [
                                    Shadow(
                                        offset: Offset(0.5, 0.5),
                                        color: Colors.black87),
                                    Shadow(
                                        offset: Offset(-0.5, 0.5),
                                        color: Colors.black87),
                                    Shadow(
                                        offset: Offset(0.5, -0.5),
                                        color: Colors.black87),
                                    Shadow(
                                        offset: Offset(-0.5, -0.5),
                                        color: Colors.black87),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      onTap: () {
                        movieSelectedFromHome = new Movie(
                          title: snapshot.data.results[index].title,
                          overview: snapshot.data.results[index].overview,
                          voteAverage: snapshot.data.results[index].voteAverage,
                          id: snapshot.data.results[index].id,
                          releaseDate: snapshot.data.results[index].releaseDate,
                          posterPath: snapshot.data.results[index].posterPath,
                          voteCount: snapshot.data.results[index].voteCount,
                          popularity: snapshot.data.results[index].popularity,
                        );
                        Navigator.pushNamed(context, '/movie',
                            arguments: ScreenArguments(language.home));
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
