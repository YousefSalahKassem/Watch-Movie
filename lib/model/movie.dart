class Movie{
  late final String backdropPath;
  late final int id;
  late final String originalLanguage;
  late final String originalTitle;
  late final String overview;
  late final double popularity;
  late final String posterPath;
  late final String releaseDate;
  late final String title;
  late final bool video;
  late final int voteCount;
  var voteAverage;

  late String error;
  Movie(
      {
      required this.backdropPath,
      required this.id,
      required this.originalLanguage,
      required this.originalTitle,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      required this.releaseDate,
      required this.title,
      required this.video,
      required this.voteCount,
      required this.voteAverage,
      });



  factory Movie.fromJson(dynamic json){
      return Movie(
          backdropPath: json['backdrop_path']==null?'':json['backdrop_path'],
          id: json['id'],
          originalLanguage:json['original_language'] ,
          originalTitle: json['original_title'],
          overview: json['overview'],
          popularity: json['popularity'],
          posterPath: json['poster_path'],
          releaseDate: json['release_date']==null?'':json['release_date'],
          title: json['title'],
          video: json['video'],
          voteCount: json['vote_count'],
          voteAverage: json['vote_average'],
      );

  }
}