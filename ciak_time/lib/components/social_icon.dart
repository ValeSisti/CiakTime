import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIcon extends StatelessWidget {
  final String iconSrc;
  final bool socialFlag;
  final Function press;
  const SocialIcon({
    Key key,
    this.iconSrc,
    this.press, @required this.socialFlag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: themeSecondaryColor,
          ),
          color: setColor(socialFlag),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          iconSrc,
          height: 30,
          width: 30,
        ),
      ),
    );
  }
  Color setColor(socialFlag) {
    Color socialColor;
    if (!socialFlag) {
      socialColor = Colors.transparent;
    } else {
      socialColor = themeSecondaryColor;
    }
    return socialColor;
  }
}
