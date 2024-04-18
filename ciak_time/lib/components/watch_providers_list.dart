import 'package:ciak_time/blocs/watch_providers_bloc.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/models/watch_providers_model.dart';
import 'package:flutter/material.dart';

class WatchProvidersList extends StatefulWidget {
  final Movie movieSelected;

  const WatchProvidersList({Key key, @required this.movieSelected})
      : super(key: key);

  @override
  State<WatchProvidersList> createState() => _WatchProvidersListState();
}

class _WatchProvidersListState extends State<WatchProvidersList> {
  WatchProvidersBloc bloc;
  @override
  void initState() {
    bloc = WatchProvidersBloc(widget.movieSelected.id.toString());
    bloc.fetchWatchProvidersResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.watchProviders,
      builder: (context, AsyncSnapshot<WatchProvidersModel> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return Center(
            child: CircularProgressIndicator(
          color: Colors.amber,
        ));
      },
    );
  }

  Widget buildList(AsyncSnapshot<WatchProvidersModel> snapshot) {
    CountryResults country_results;
    if (api_language == "en-US") {
      country_results = snapshot.data.results.uS;
    } else if (api_language == "it-IT") {
      country_results = snapshot.data.results.iT;
    }
    if (country_results != null) {
      return Container(
        height: width * 0.1,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: country_results.providers.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Container(
                    width: width * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://image.tmdb.org/t/p/w780${country_results.providers[index].logoPath}'),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                ],
              );
            }),
      );
    } else {
      return Text(
        language.no_provider,
        style: TextStyle(
          color: Colors.grey,
          fontSize: height * 0.02,
          fontWeight: FontWeight.w600,
          fontFamily: 'Quicksand',
        ),
      );
    }
  }
}
