import 'package:equatable/equatable.dart';
import 'package:watchmovie/model/genre.dart';
import 'package:watchmovie/model/movie.dart';

abstract class GenreState extends Equatable{
  const GenreState();
  @override
  List<Object> get props => [];

}

class GenreLoading extends GenreState{}

class GenreLoaded extends GenreState{
  final List<Genre> GenreList;
  const GenreLoaded(this.GenreList);

  @override
  List<Object> get props => [GenreList];
}

class GenreError extends GenreState{
}