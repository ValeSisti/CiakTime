import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';

class CastCard extends StatelessWidget {
  const CastCard({
    Key key,
    @required this.imageUrl,
    @required this.personName,
    @required this.character,
  }) : super(key: key);

  final String imageUrl;
  final String personName;
  final String character;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Stack(
            children: [
              Container(
                height: width * 0.3,
                width: width * 0.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  width: width * 0.25,
                  height: height * 0.12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                          stops: [
                        0.0,
                        1.0
                      ])),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          personName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.028,
                            fontFamily: 'Quicksand',
                            shadows: [
                              Shadow(
                                  offset: Offset(0.5, 0.5), color: Colors.black87),
                              Shadow(
                                  offset: Offset(-0.5, 0.5), color: Colors.black87),
                              Shadow(
                                  offset: Offset(0.5, -0.5), color: Colors.black87),
                              Shadow(
                                  offset: Offset(-0.5, -0.5), color: Colors.black87),
                            ],
                          ),
                        ),
                        Text(
                          character,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.028,
                            fontFamily: 'Quicksand',                            
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
