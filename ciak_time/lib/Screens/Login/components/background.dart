import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isDarkMode) {
      return Container(
        width: double.infinity,
        height: height,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            child,
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: height,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                width: width * 0.35,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/images/login_bottom.png",
                width: width * 0.4,
              ),
            ),
            child,
          ],
        ),
      );
    }
  }
}
