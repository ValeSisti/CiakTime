import 'package:ciak_time/Screens/Homescreen/carousel_widget.dart';
import 'package:ciak_time/components/upcoming_movie_list.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/utils/device_orientation.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
    @required this.callback,
  }) : super(key: key);

  final Function callback;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    enableRotation();    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselWidget(callback: widget.callback),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 25.0, 8.0, 0.0),
              child: Text(
                language.upcoming,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Quicksand',
                  fontSize: width * 0.07,
                  shadows: [
                    Shadow(offset: Offset(1, 1), color: shadowColor),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UpcomingMovieList(),
            ),
          ],
        ),
      ),
    );
  }
}
