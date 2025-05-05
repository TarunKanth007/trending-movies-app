import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_model.dart';
import '../api/api.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  String? trailerKey;
  bool isLoading = true;
  List<String> cast = [];

  @override
  void initState() {
    super.initState();
    _fetchTrailerAndCast();
  }

  Future<void> _fetchTrailerAndCast() async {
    try {
      final key = await Api().getMovieTrailer(widget.movie.id);
      cast = await Api().getMovieCast(widget.movie.id);

      if (key != null && key.isNotEmpty) {
        trailerKey = key.trim();
      }
    } catch (e) {
      debugPrint("Failed to fetch data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Launch the trailer URL in the system browser
  void _launchTrailer() async {
    if (trailerKey != null && trailerKey!.isNotEmpty) {
      final url = 'https://www.youtube.com/embed/$trailerKey';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(movie.title),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: isWideScreen ? _buildWideLayout(movie) : _buildMobileLayout(movie),
      ),
    );
  }

  Widget _buildWideLayout(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                width: 300,
                height: 450,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(child: _buildMovieDetails(movie)),
          ],
        ),
        const SizedBox(height: 24),
        if (trailerKey != null) _buildTrailerThumbnail(600),
      ],
    );
  }

  Widget _buildMobileLayout(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            "https://image.tmdb.org/t/p/w500${movie.posterPath}",
            width: double.infinity,
            height: 400,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          ),
        ),
        const SizedBox(height: 16),
        _buildMovieDetails(movie),
        const SizedBox(height: 16),
        if (trailerKey != null) _buildTrailerThumbnail(300),
      ],
    );
  }

  Widget _buildMovieDetails(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal scroll for cast
        Text(
          "Cast: ",
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cast.map((actor) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Chip(
                  label: Text(
                    actor,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),
        const Text(
          'Overview',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        const SizedBox(height: 8),
        Text(
          movie.overview,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Text('Release Date: ${movie.releaseDate}', style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        Text('Rating: ${movie.rating?.toStringAsFixed(1) ?? 'N/A'}', style: const TextStyle(color: Colors.white)),
      ],
    );
  }



  Widget _buildTrailerThumbnail(double height) {
    final thumbnailUrl = 'https://img.youtube.com/vi/$trailerKey/0.jpg'; // Thumbnail URL based on trailer key

    return Column(
      children: [
        // Title "Watch Trailer"
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Watch Trailer',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Thumbnail with GestureDetector
        GestureDetector(
          onTap: _launchTrailer, // Open the trailer in the browser
          child: Center( // Center the thumbnail
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4), // Shadow position
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(thumbnailUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9, // Standard video aspect ratio
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


}
