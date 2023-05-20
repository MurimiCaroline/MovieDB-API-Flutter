import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Displaying API reponse in ListView
void main() => runApp(MoviesApp());

//App level widget
class MoviesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //movie listing stateful widget
      home: MoviesListing(),
    );
  }
}

class MoviesProvider {
  static final String imagePathPrefix = 'https://image.tmdb.org/t/p/w500/';

  //REPLACE: Don't forget to replace with your own API key
  static final apiKey = "72e0b0e05949098585fedd3d1a103818";

  //Returns JSON formatted response as Map
  static Future<Map> getJson() async {
    final apiEndPoint =
        "http://api.themoviedb.org/3/discover/movie?api_key=${apiKey}&sort_by=popularity.desc";
    final apiResponse = await http.get(apiEndPoint as Uri);
    return json.decode(apiResponse.body);
  }
}

class MoviesListing extends StatefulWidget {
  @override
  _MoviesListingState createState() => _MoviesListingState();
}

class _MoviesListingState extends State<MoviesListing> {
  var movies;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  fetchMovies() async {
    var data = await MoviesProvider.getJson();

    //Updating data and requesting to rebuild widget
    setState(() {
      //storing movie list in `movies` variable
      movies = data['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: movies == null ? 0 : movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(movies[index]["title"]),
          );
        },
      ),
    );
  }
}

