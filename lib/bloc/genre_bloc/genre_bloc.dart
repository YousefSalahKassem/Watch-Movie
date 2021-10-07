import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc_state.dart';
import 'package:watchmovie/model/genre.dart';
import 'package:watchmovie/model/movie.dart';
import 'package:watchmovie/service/api_service.dart';

import 'genre_bloc_event.dart';
import 'genre_bloc_state.dart';

class GenreBloc extends Bloc<GenreEvent,GenreState>{
  GenreBloc() : super(GenreLoading()) ;

  @override
  Stream<GenreState> mapEventToState(GenreEvent event) async*{
    if(event is GenreEventStarted){
      yield* _mapEventStableToState();
    }
  }
  Stream<GenreState> _mapEventStableToState()async*{
    final service=ApiService();
    yield GenreLoading();
    try{
      late List<Genre> GenreList;
        GenreList= await service.getGenreList();
      yield GenreLoaded(GenreList);
    }
    on Exception catch(e){
      print(e);
      yield GenreError();
    }
  }
}