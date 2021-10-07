
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchmovie/bloc/movie_details_bloc/state_details.dart';
import 'package:watchmovie/service/api_service.dart';

import 'event_details.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, DetailsState> {
  MovieDetailBloc() : super(DetailsLoading());

  @override
  Stream<DetailsState> mapEventToState(MovieDetailEvent event) async* {
    if (event is MovieDetailEventStated) {
      yield* _mapMovieEventStartedToState(event.id);
    }
  }

  Stream<DetailsState> _mapMovieEventStartedToState(int id) async* {
    final apiRepository = ApiService();
    yield DetailsLoading();
    try {
      final movieDetail = await apiRepository.getMovieDetail(id);

      yield DetailsLoaded(movieDetail);
    } on Exception catch (e) {
      print(e);
      yield DetailsError();
    }
  }
}