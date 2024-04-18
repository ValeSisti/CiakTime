import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:ciak_time/constants.dart';

class BornInfo extends StatelessWidget {
  const BornInfo({
    Key key,
    @required this.date,
    @required this.place,
  }) : super(key: key);
  final String date;
  final String place;

  @override
  Widget build(BuildContext context) {
    if (date != null && place != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language.born,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: 'Quicksand',
                fontSize: height * 0.02),
          ),
          Expanded(
            child: Text(
              DateFormat.yMMMd(api_language).format(DateTime.parse(date)) +
                  ", \n" + 
                  place,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Quicksand',
                  fontSize: height * 0.02),
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}

class DeathInfo extends StatelessWidget {
  const DeathInfo({
    Key key,
    @required this.date,
  }) : super(key: key);
  final String date;

  @override
  Widget build(BuildContext context) {
    if (date != null) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                language.died,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Quicksand',
                    fontSize: height * 0.02),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMd(api_language).format(DateTime.parse(date)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Quicksand',
                      fontSize: height * 0.02),
                ),
              )
            ],
          ),
          SizedBox(height: height * 0.01)
        ],
      );
    } else {
      return Container();
    }
  }
}

class OccupationInfo extends StatelessWidget {
  const OccupationInfo({
    Key key,
    @required this.know_for,
  }) : super(key: key);
  final String know_for;

  @override
  Widget build(BuildContext context) {
    String occupation;

    if (know_for == "Acting") {
      occupation = language.occupation_actor;
    } else if (know_for == "Directing") {
      occupation = language.occupation_directing;
    } else if (know_for == "Writing") {
      occupation = language.occupation_writer;
    } else if (know_for == "Production") {
      occupation = language.occupation_producer;
    } else if (know_for == "Editing") {
      occupation = language.occupation_editor;
    } else if (know_for == "Costume & Make-Up") {
      occupation = language.occupation_costume;
    } else if (know_for == "Sound") {
      occupation = language.occupation_composer;
    } else if (know_for == null) {
      occupation = "";
    } else {
      occupation = know_for;
    }

    if (occupation != "") {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language.occupation,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: 'Quicksand',
                fontSize: height * 0.02),
          ),
          Expanded(
            child: Text(
              occupation,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Quicksand',
                  fontSize: height * 0.02),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class Biography extends StatelessWidget {
  const Biography({
    Key key,
    @required this.biography,
  }) : super(key: key);
  final String biography;

  @override
  Widget build(BuildContext context) {
    if (biography != "") {
      return ReadMoreText(
        biography,
        trimLines: 5,
        delimiter: '',
        colorClickableText: themePrimaryColor,
        trimMode: TrimMode.Line,
        trimCollapsedText: language.read_more,
        trimExpandedText: language.show_less,
        moreStyle: TextStyle(
            fontSize: width * 0.04,
            fontWeight: FontWeight.bold,
            color: themePrimaryColor),
        style: TextStyle(
          fontSize: height * 0.02,
          fontWeight: FontWeight.w600,
          fontFamily: 'Quicksand',
        ),
      );
    } else {
      return Text(
        language.no_biography,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: height * 0.02,
          fontFamily: 'Quicksand',
        ),
      );
    }
  }
}
