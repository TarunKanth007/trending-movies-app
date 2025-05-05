# Trending Movies App

A Flutter app that displays a list of trending movies fetched from The Movie Database (TMDB) API. This app features infinite scroll, a search bar, and displays detailed information about each movie on a separate screen.

## Features

### Home Screen:
- Fetches and displays a list of trending movies from TMDB API.
- Shows movie poster, title, and release date.
- Implements a shimmer loader for loading indicators.
- Includes a search bar for searching movies by title.
- Supports infinite scroll/pagination for loading more movies.

### Details Screen:
- Displays detailed information about a movie.
- Includes title, poster, trailer (via YouTube player), cast, overview, release date, and rating.
- Cast is shown in a horizontally scrollable list.

### Responsive Design:
- The app is fully responsive, supporting multiple screen sizes and orientations.

## Tech Stack

- **Language**: Dart
- **Framework**: Flutter
- **State Management**: Provider (or any other state management solution you prefer)
- **Networking**: HTTP package or Dio for API calls
- **UI**: Material Design widgets, Responsive Layout, Shimmer for loading states

### Dependencies:
- `provider` for state management
- `http` or `dio` for API requests
- `youtube_player_flutter` for embedding YouTube trailers
- `shimmer` for the loading state
- `cached_network_image` for optimized image loading

## Setup Instructions

### Prerequisites

- **Flutter**: Make sure you have Flutter installed on your machine. Follow the instructions on the official Flutter website to set up Flutter SDK:
    - [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

- **TMDB API Key**:
    - Sign up on [TMDB](https://www.themoviedb.org/) to get an API key. This will be used to fetch movie data.

### Clone the Repository

[git clone https://github.com/yourusername/trending-movies-app.git](https://github.com/TarunKanth007/trending-movies-app.git)
cd trending-movies-app

### Install Dependencies
Make sure you are in the project directory, then run:

flutter pub get

### Configure the API Key
In the lib/api/api.dart file, add your TMDB API key. Replace your_api_key_here with the actual API key.

class Api {
  final String _apiKey = '2cb0292b03fe9b2060d5bdfc7cc0c94b';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getTrendingMovies({int page = 1, String query = ''}) async {
    // Your API call logic
  }
}
  ### Run the App
To run the app on an emulator or a real device:

flutter run

### App Architecture
UI Layer:
The UI is built using Flutter's Material Design components and is responsive to screen sizes.

The app is divided into multiple screens: Home Screen, Movie Details Screen.

### Networking:
The API calls are handled by the Api class, which uses either the http or dio package to fetch data from the TMDB API.

### State Management:
Provider (or any other chosen state management solution) is used to manage the app state, such as fetching movie data, managing pagination, and updating the UI based on the fetched data.

### Movie Model:
The data model is Movie, which includes fields such as title, poster path, release date, etc., and is used to parse the response from the API.

Screens
1. Home Screen:
Displays a grid of movie posters, titles, and release dates.

Fetches trending movies from TMDB API with pagination.

A shimmer effect is shown while the data is being loaded.

A search bar allows users to filter movies by title.

2. Movie Details Screen:
Displays detailed information about the selected movie.

Shows a poster, title, release date, rating, and overview.

Displays a horizontally scrollable list of cast members.

Embeds a YouTube player to play the movie trailer.

### Libraries/Packages Used
http/dio: Used to handle API requests.

provider: A state management solution for handling the app state.

shimmer: For showing loading states while the movie data is being fetched.

youtube_player_flutter: For embedding YouTube trailers in the details screen.

cached_network_image: For caching and optimizing network images (e.g., movie posters).

### Screenshots
Home Screen:

Movie Details Screen:

License
This project is open source and available under the MIT License. See the LICENSE file for more information.

Additional Notes:
The UI is responsive and adjusts for different screen sizes (e.g., tablets, phones).

The app supports infinite scroll to fetch more movies as the user scrolls.

The movie details page provides an embedded YouTube trailer player and displays movie details including cast, rating, release date, etc.

Future Improvements
Error Handling: Improve error handling for network requests.

Unit Testing: Add unit tests for API requests and UI components.

Caching: Implement local storage for movie data to prevent unnecessary API calls on app restart.
### Home Screen
![Screenshot 2025-05-05 195908](https://github.com/user-attachments/assets/ce6d9f02-d703-4352-9df5-312101f21857)

### Details Screen 
![Screenshot 2025-05-05 195427](https://github.com/user-attachments/assets/9147b1f5-3989-47ae-9b39-e4a9821bf976)

### Watch Trailer
![Screenshot 2025-05-05 195442](https://github.com/user-attachments/assets/34557090-6e20-4226-bb91-51ded1027eef)

### Trailer Screen
![Screenshot 2025-05-05 195502](https://github.com/user-attachments/assets/51e21cc7-9946-491a-8073-1a8f59bfb3c7)
