import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';

class SectionDiv extends StatelessWidget {
  const SectionDiv({
    Key key,
    @required this.label,
    @required this.fontSize,
    @required this.colorDiv,
  }) : super(key: key);

  final String label;
  final num fontSize;
  final Color colorDiv;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
      width: width * 0.95,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              label,
              style: TextStyle(
                  color: themePrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Quicksand',
                  fontSize: width * fontSize),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: colorDiv,
        height: 1.5,
      ),
    );
  }
}
