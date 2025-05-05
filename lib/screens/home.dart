import 'package:flutter/material.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/screens/details.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Movie> movies = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  String query = '';
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTrendingMovies();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchTrendingMovies() async {
    if (isLoading || !hasMore) return;
    setState(() => isLoading = true);

    final List<Movie> fetchedMovies =
    await Api().getTrendingMovies(page: currentPage, query: query);
    setState(() {
      currentPage++;
      movies.addAll(fetchedMovies);
      isLoading = false;
      if (fetchedMovies.isEmpty) hasMore = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      fetchTrendingMovies();
    }
  }

  void _onSearchChanged(String newQuery) {
    setState(() {
      query = newQuery;
      currentPage = 1;
      movies.clear();
      hasMore = true;
    });
    fetchTrendingMovies();
  }

  Widget _buildShimmer() => GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.75,
    ),
    itemCount: 6,
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  Widget _buildMovieCard(Movie movie) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageHeight = screenWidth > 600 ? 350 : 200; // Adjusted height for larger screens

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.grey[850],
      elevation: 8, // Added elevation for depth
      shadowColor: Colors.black.withOpacity(0.5), // Shadow color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Tile
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              "https://image.tmdb.org/t/p/w500${movie.posterPath}",
              fit: BoxFit.cover,
              height: imageHeight,
              width: double.infinity,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),

          // Title and Release Date Tile wrapped in an Expanded widget
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                // Release Date
                SizedBox(height: 4), // Add some space between the title and release date
                Text(
                  movie.releaseDate ?? 'No Date',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Trending Movies"),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search movies...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Dynamically adjust the number of columns based on screen width
                int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

                return GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75, // Adjust aspect ratio for better appearance
                  ),
                  itemCount: movies.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < movies.length) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsScreen(movie: movie),
                            ),
                          );
                        },
                        child: _buildMovieCard(movie),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
