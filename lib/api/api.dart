import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/movie_model.dart';
import 'constants.dart';

class Api {
  final upComingApiUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  final popularApiUrl = "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  final topRatedApiUrl = "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(upComingApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((movie) => Movie.fromMap(movie)).toList();
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(popularApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((movie) => Movie.fromMap(movie)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(topRatedApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((movie) => Movie.fromMap(movie)).toList();
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<Movie>> getTrendingMovies({int page = 1, String query = ''}) async {
    final String url = query.isEmpty
        ? "https://api.themoviedb.org/3/trending/movie/week?api_key=$apiKey&page=$page"
        : "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=${Uri.encodeQueryComponent(query)}&page=$page";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((movie) => Movie.fromMap(movie)).toList();
    } else {
      throw Exception('Failed to load trending/search movies');
    }
  }

  /// ✅ Get YouTube Trailer Key for a Movie
  Future<String?> getMovieTrailer(int movieId) async {
    final url =
        "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List videos = data['results'];

      if (videos.isNotEmpty) {
        final trailer = videos.firstWhere(
              (video) =>
          video['site'] == 'YouTube' &&
              video['type'] == 'Trailer' &&
              video['key'] != null,
          orElse: () => null,
        );

        if (trailer != null) {
          return trailer['key']; // e.g., "tlLsFEDHtWs"
        }
      }
      return null;
    } else {
      throw Exception('Failed to fetch trailer');
    }
  }
  Future<List<String>> getMovieCast(int movieId) async {
    final url = Uri.parse('https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final castList = jsonData['cast'] as List;

      return castList.take(5).map<String>((castMember) => castMember['name'] as String).toList();
    } else {
      throw Exception('Failed to load cast data');
    }
  }


}
