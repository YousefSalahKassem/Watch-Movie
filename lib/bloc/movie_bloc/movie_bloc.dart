import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc_state.dart';
import 'package:watchmovie/model/movie.dart';
import 'package:watchmovie/service/api_service.dart';

class MovieBloc extends Bloc<MovieEvent,MovieState>{
  MovieBloc() : super(MovieLoading()) ;

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async*{
    if(event is MovieEventStarted){
      yield* _mapEventStableToState(event.movieId,event.query);
    }
  }
  Stream<MovieState> _mapEventStableToState(int movieId,String query)async*{
    final service=ApiService();
    yield MovieLoading();
    try{
     late List<Movie> movieList;
      if(movieId==0){
        movieList= await service.getNowPlayingMovie();
      }
      else{
     movieList = await service.getMovieByGenre(movieId);}
     yield MovieLoaded(movieList);
    }
    on Exception catch(e){
      print(e);
      yield MovieError();
    }
  }
}