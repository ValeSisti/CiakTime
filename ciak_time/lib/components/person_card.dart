import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({
    Key key,
    @required this.imageUrl,
    @required this.personName,
  }) : super(key: key);

  final String imageUrl;
  final String personName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: width * 0.18,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                imageUrl,
              ),
            ),
          ),
        ),
        Text(
          personName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: height * 0.016,
            fontFamily: 'Quicksand',
          ),
        ),
      ],
    );
  }
}
