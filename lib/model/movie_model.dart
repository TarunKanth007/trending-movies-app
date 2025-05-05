class Movie {
  final int id;
  final String title;
  final String backDropPath;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double? rating;

  Movie({
    required this.id,
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    this.rating,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] ?? 'No Id',
      title: map['title'] ?? 'No Title',
      backDropPath: map['backdrop_path'] ?? '',
      overview: map['overview'] ?? '',
      posterPath: map['poster_path'] ?? '',
      releaseDate: map['release_date'] ?? 'Unknown',
      rating: map['vote_average']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'title': title,
      'backDropPath': backDropPath,
      'overview': overview,
      'posterPath': posterPath,
      'releaseDate': releaseDate,
      'rating':rating,
    };
  }
}
