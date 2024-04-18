import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  const ListCard({
    Key key,
    @required this.imageUrl,
    @required this.movieTitle,
  }) : super(key: key);

  final String imageUrl;
  final String movieTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Stack(
            children: [
              Container(
                height: width * 0.29,
                width: width * 0.2,
                
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
                  width: width * 0.20,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 4.0),
                        child: Text(
                          movieTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.035,
                            fontFamily: 'Quicksand-Regular',
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
                      ),
                    ],
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
