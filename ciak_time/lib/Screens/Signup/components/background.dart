import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    if (isDarkMode) {
      return Container(
        height: height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            widget.child,
          ],
        ),
      );
    } else {
      return Container(
        height: height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                "assets/images/main_top_reverse.png",
                width: width * 0.35,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_bottom.png",
                width: width * 0.25,
              ),
            ),
            widget.child,
          ],
        ),
      );
    }
  }
}
