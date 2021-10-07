import 'package:equatable/equatable.dart';
import 'package:watchmovie/model/genre.dart';
import 'package:watchmovie/model/movie.dart';
import 'package:watchmovie/model/person.dart';

abstract class PersonState extends Equatable{
  const PersonState();
  @override
  List<Object> get props => [];

}

class PersonLoading extends PersonState{}

class PersonLoaded extends PersonState{
  final List<Person> PersonList;
  const PersonLoaded(this.PersonList);

  @override
  List<Object> get props => [PersonList];
}

class PersonError extends PersonState{
}