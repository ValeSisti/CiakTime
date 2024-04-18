class PersonMoviesModel {
  List<PersonMovie> movies;
  List<Crew> crew;
  int id;

  PersonMoviesModel({this.movies, this.crew, this.id});

  PersonMoviesModel.fromJson(Map<String, dynamic> json) {
    if (json['cast'] != null) {
      movies = [];
      json['cast'].forEach((v) {
        movies.add(new PersonMovie.fromJson(v));
      });
    }
    if (json['crew'] != null) {
      crew = [];
      json['crew'].forEach((v) {
        crew.add(new Crew.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.movies != null) {
      data['cast'] = this.movies.map((v) => v.toJson()).toList();
    }
    if (this.crew != null) {
      data['crew'] = this.crew.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class PersonMovie {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int voteCount;
  String originalLanguage;
  String originalTitle;
  String posterPath;
  String title;
  bool video;
  double voteAverage;
  int id;
  String overview;
  String releaseDate;
  double popularity;
  String character;
  String creditId;
  int order;

  PersonMovie(
      {this.adult,
      this.backdropPath,
      this.genreIds,
      this.voteCount,
      this.originalLanguage,
      this.originalTitle,
      this.posterPath,
      this.title,
      this.video,
      this.voteAverage,
      this.id,
      this.overview,
      this.releaseDate,
      this.popularity,
      this.character,
      this.creditId,
      this.order});

  PersonMovie.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    genreIds = json['genre_ids'].cast<int>();
    voteCount = json['vote_count'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    posterPath = json['poster_path'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    id = json['id'];
    overview = json['overview'];
    releaseDate = json['release_date'];
    popularity = json['popularity'];
    character = json['character'];
    creditId = json['credit_id'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['genre_ids'] = this.genreIds;
    data['vote_count'] = this.voteCount;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['poster_path'] = this.posterPath;
    data['title'] = this.title;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    data['id'] = this.id;
    data['overview'] = this.overview;
    data['release_date'] = this.releaseDate;
    data['popularity'] = this.popularity;
    data['character'] = this.character;
    data['credit_id'] = this.creditId;
    data['order'] = this.order;
    return data;
  }
}

class Crew {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;
  double popularity;
  String creditId;
  String department;
  String job;

  Crew(
      {this.adult,
      this.backdropPath,
      this.genreIds,
      this.id,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.posterPath,
      this.releaseDate,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount,
      this.popularity,
      this.creditId,
      this.department,
      this.job});

  Crew.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    genreIds = json['genre_ids'].cast<int>();
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    popularity = json['popularity'];
    creditId = json['credit_id'];
    department = json['department'];
    job = json['job'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['genre_ids'] = this.genreIds;
    data['id'] = this.id;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['overview'] = this.overview;
    data['poster_path'] = this.posterPath;
    data['release_date'] = this.releaseDate;
    data['title'] = this.title;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    data['popularity'] = this.popularity;
    data['credit_id'] = this.creditId;
    data['department'] = this.department;
    data['job'] = this.job;
    return data;
  }
}
