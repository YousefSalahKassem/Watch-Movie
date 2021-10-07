import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:page_transition/page_transition.dart';
import 'package:watchmovie/constant/Constantcolors.dart';
import 'package:watchmovie/model/movie.dart';
import 'package:watchmovie/service/api_service.dart';
import 'package:watchmovie/ui/movie_details.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ConstantColors constantColors=ConstantColors();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: const Color(0xFF1D1D28),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: RichText(
              text: TextSpan(
                  text: 'Watch',
                  style: TextStyle(
                    fontFamily: 'muli',
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'Movie',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ])),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: const CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('images/logo.png'),
              ),
            )
          ],
        ),
        body:SingleChildScrollView(
        child: Column(
          children: [

            TypeAheadField<Movie?>(
                suggestionsCallback: ApiService().searchMovie,
                hideSuggestionsOnKeyboardHide: false,
                textFieldConfiguration:const TextFieldConfiguration(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    hintText: 'Search Movie',
                    hintStyle: TextStyle(color: Colors.grey)
                  )
                ),
                noItemsFoundBuilder: (context)=>const Text('No Items Found'),
                errorBuilder: (context,error)=>Text(error.toString()),
                itemBuilder: (context,Movie? suggestion){
              return ListTile(
                title: Text(suggestion!.title.toString()),
                subtitle: Text(suggestion.releaseDate),
                leading: Image.network('https://image.tmdb.org/t/p/w200${suggestion.posterPath}'),
              );
            }, onSuggestionSelected: (Movie? suggestion){
              Navigator.pushReplacement(context, PageTransition(child: MovieDetailScreen(movie: suggestion as Movie), type: PageTransitionType.leftToRight));
            }),
          ],
        ),
        )
      );
  }
}
