import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:watchmovie/model/cast.dart';
import 'package:watchmovie/model/genre.dart';
import 'package:watchmovie/model/movie.dart';
import 'package:watchmovie/model/movie_details.dart';
import 'package:watchmovie/model/movie_image.dart';
import 'package:watchmovie/model/person.dart';
import 'package:watchmovie/model/search.dart';

class ApiService{
  final Dio _dio=Dio();

  Future<List<Movie>> getNowPlayingMovie()async{
    try{
      print('api call');
      final response=await _dio.get('https://api.themoviedb.org/3/movie/now_playing?api_key=5fd5596fc3260b306edb5b3bd7a7a180');
      var movies=response.data['results'] as List;
      List<Movie> movieList=movies.map((e) => Movie.fromJson(e)).toList();
      return movieList;
    }
    catch(error,stacktrace){
      throw  Exception('Exception happened $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Genre>> getGenreList()async{
    try{
      print('api call');
      final response=await _dio.get('https://api.themoviedb.org/3/genre/movie/list?api_key=5fd5596fc3260b306edb5b3bd7a7a180');
      var movies=response.data['genres'] as List;
      List<Genre> movieList=movies.map((e) => Genre.fromJson(e)).toList();
      return movieList;
    }
    catch(error,stacktrace){
      throw  Exception('Exception happened $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Movie>> getMovieByGenre(int movieId)async{
    try{
      print('api call');
      final response=await _dio.get('https://api.themoviedb.org/3/discover/movie?api_key=5fd5596fc3260b306edb5b3bd7a7a180&with_genres=$movieId');
      var movies=response.data['results'] as List;
      List<Movie> movieList=movies.map((e) => Movie.fromJson(e)).toList();
      return movieList;
    }
    catch(error,stacktrace){
      throw  Exception('Exception happened $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Person>> getTrendingPerson() async {
    try {
      final response = await _dio.get('https://api.themoviedb.org/3/trending/person/week?api_key=5fd5596fc3260b306edb5b3bd7a7a180');
      var persons = response.data['results'] as List;
      List<Person> personList = persons.map((p) => Person.fromJson(p)).toList();
      return personList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    try {
      final response = await _dio.get('https://api.themoviedb.org/3/movie/$movieId?api_key=5fd5596fc3260b306edb5b3bd7a7a180');
      MovieDetail movieDetail = MovieDetail.fromJson(response.data);

      movieDetail.trailerId=await getYoutubeId(movieId);

      movieDetail.movieImage=await getMovieImage(movieId);

      movieDetail.castList = await getCastList(movieId);
      return movieDetail;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<String> getYoutubeId(int id)async{
  try{
    final response=await _dio.get('https://api.themoviedb.org/3/movie/$id/videos?api_key=5fd5596fc3260b306edb5b3bd7a7a180');
    var youtubeId=response.data['results'][0]['key']==null?'':response.data['results'][0]['key'];
    return youtubeId;
  }
  catch(error,stacktrace){
    throw Exception(
        'Exception accoured: $error with stacktrace: $stacktrace');
  }
  }

  Future<MovieImage> getMovieImage(int movieId) async {
    try {
      final response = await _dio.get('https://api.themoviedb.org/3/movie/$movieId/images?api_key=5fd5596fc3260b306edb5b3bd7a7a180');
      return MovieImage.fromJson(response.data);
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Cast>> getCastList(int movieId) async {
    try {
      final response =
      await _dio.get('https://api.themoviedb.org/3/movie/$movieId/credits?api_key=5fd5596fc3260b306edb5b3bd7a7a180');
      var list = response.data['cast'] as List;
      List<Cast> castList = list
          .map((c) => Cast(
          name: c['name'],
          profilePath: c['profile_path']==null?'':c['profile_path'],
          character: c['character']))
          .toList();
      return castList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Movie>> searchMovie(String query)async{
    try{
      print('api call');
      final response=await _dio.get('https://api.themoviedb.org/3/search/movie?api_key=5fd5596fc3260b306edb5b3bd7a7a180&language=en-US&query=${query==''?'a':query}&page=1&include_adult=false');
      var movies=response.data['results'] as List;
      List<Movie> movieList=movies.map((e) => Movie.fromJson(e)).toList();
      return movieList;
    }
    catch(error,stacktrace){
      throw  Exception('Exception happened $error with stacktrace: $stacktrace');
    }
  }

  }
