import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc_state.dart';
import 'package:watchmovie/bloc/person_bloc/person_bloc_event.dart';
import 'package:watchmovie/bloc/person_bloc/person_bloc_state.dart';
import 'package:watchmovie/model/genre.dart';
import 'package:watchmovie/model/movie.dart';
import 'package:watchmovie/model/person.dart';
import 'package:watchmovie/service/api_service.dart';


class PersonBloc extends Bloc<PersonEvent,PersonState>{
  PersonBloc() : super(PersonLoading()) ;

  @override
  Stream<PersonState> mapEventToState(PersonEvent event) async*{
    if(event is PersonEventStarted){
      yield* _mapEventStableToState();
    }
  }
  Stream<PersonState> _mapEventStableToState()async*{
    final service=ApiService();
    yield PersonLoading();
    try{
      late List<Person> PersonList;
      PersonList= await service.getTrendingPerson();
      yield PersonLoaded(PersonList);
    }
    on Exception catch(e){
      print(e);
      yield PersonError();
    }
  }
}