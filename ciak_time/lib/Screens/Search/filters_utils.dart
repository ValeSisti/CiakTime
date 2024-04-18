import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/search_results_model.dart';

bool isFiltersApplied() {
  bool filterSelected = false;

  if (selected_rate ||
      selected_most_added ||
      selected_most_recent ||
      drama ||
      comedy ||
      action ||
      crime ||
      fantasy ||
      thriller ||
      family ||
      anime ||
      horror) {
    filterSelected = true;
  }

  return filterSelected;
}

void sortSearchResults(snapshot) {
  if (snapshot.data != null) {
    if (selected_most_recent) {
      snapshot.data.sort((a, b) {
        if (a.releaseDate == null || a.releaseDate == "") {
          return 1;
        } else if (b.releaseDate == null || b.releaseDate == "") {
          return -1;
        } else {
          var df1 = DateTime.tryParse(a.releaseDate);
          var df2 = DateTime.tryParse(b.releaseDate);
          return df2.compareTo(df1);
        }
      });
    } else if (selected_most_added) {
      snapshot.data.sort((a, b) {
        double p1 = a.popularity;
        double p2 = b.popularity;
        return p2.compareTo(p1);
      });
    } else if (selected_rate) {
      snapshot.data.sort((a, b) {
        double r1 = a.voteAverage;
        double r2 = b.voteAverage;
        return r2.compareTo(r1);
      });
    }
  }

  return snapshot;
}

void checkFilterResults(
    List<SearchResults> results, SearchResults searchResults, dynamic v) {
  if (drama == true) {
    if (v.values.toList()[2].contains(genresIds[0]["Drama"]) &&
        !filteredMoviesList.contains(searchResults.id)) {
      filteredMoviesList.add(searchResults.id);
      results.add(searchResults);
    }
  }
  if (comedy == true) {
    if (v.values.toList()[2].contains(genresIds[0]["Comedy"]) &&
        !filteredMoviesList.contains(searchResults.id)) {
      filteredMoviesList.add(searchResults.id);
      results.add(searchResults);
    }
  }
  if (action == true) {
    if (v.values.toList()[2].contains(genresIds[0]["Action"]) &&
        !filteredMoviesList.contains(searchResults.id)) {
      filteredMoviesList.add(searchResults.id);
      results.add(searchResults);
    }
  }
  if (crime == true) {
    if (v.values.toList()[2].contains(genresIds[0]["Crime"]) &&
        !filteredMoviesList.contains(searchResults.id)) {
      filteredMoviesList.add(searchResults.id);
      results.add(searchResults);
    }
  }
  if (fantasy == true) {
    if (v.values.toList()[2].contains(genresIds[0]["Fantasy"]) &&
        !filteredMoviesList.contains(searchResults.id)) {
      filteredMoviesList.add(searchResults.id);
      results.add(searchResults);
    }
  }
  if (thriller == true) {
    if (v.values.toList()[2].contains(genresIds[0]["Thriller"]) &&
        !filteredMoviesList.contains(searchResults.id)) {
      filteredMoviesList.add(searchResults.id);
      results.add(searchResults);
    }
  }
  if (family == true) {
    if (v.values.toList()[2].contains(genresIds[0]["Family"]) &&
        !filteredMoviesList.contains(searchResults.id)) {
      filteredMoviesList.add(searchResults.id);
      results.add(searchResults);
    }
  }
  if (anime == true) {
    if (v.values.toList()[2].contains(genresIds[0]["Animation"]) &&
        !filteredMoviesList.contains(searchResults.id)) {
      filteredMoviesList.add(searchResults.id);
      results.add(searchResults);
    }
  }
  if (horror == true) {
    if (v.values.toList()[2].contains(genresIds[0]["Horror"]) &&
        !filteredMoviesList.contains(searchResults.id)) {
      filteredMoviesList.add(searchResults.id);
      results.add(searchResults);
    }
  }
  if ((selected_most_added || selected_most_recent || selected_rate) &&
      (drama == false &&
          comedy == false &&
          action == false &&
          crime == false &&
          fantasy == false &&
          thriller == false &&
          family == false &&
          anime == false &&
          horror == false)) {
    results.add(searchResults);
  }
}
