import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: width * 0.8,
      decoration: BoxDecoration(
        color: themeSecondaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}

class TextFieldContainer2 extends StatelessWidget {
  final Widget child;
  const TextFieldContainer2({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: width,
      decoration: BoxDecoration(
        color: themeSecondaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}
