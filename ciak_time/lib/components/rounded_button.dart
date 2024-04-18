import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatefulWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double radius;
  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color,
    this.textColor,
    this.radius,
  }) : super(key: key);

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
          color: widget.color,
          onPressed: widget.press,
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor,
              fontSize: width * 0.05,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
