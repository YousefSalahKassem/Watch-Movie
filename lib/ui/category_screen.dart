import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:watchmovie/bloc/genre_bloc/genre_bloc.dart';
import 'package:watchmovie/bloc/genre_bloc/genre_bloc_event.dart';
import 'package:watchmovie/bloc/genre_bloc/genre_bloc_state.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc_state.dart';
import 'package:watchmovie/model/genre.dart';
import 'package:watchmovie/model/movie.dart';
import 'package:watchmovie/ui/movie_details.dart';
import 'package:watchmovie/ui/see_more.dart';

class BuildWidgetCategory extends StatefulWidget {
  final int selectedGenre = 28;

  const BuildWidgetCategory();

  @override
  _BuildWidgetCategoryState createState() => _BuildWidgetCategoryState();
}

class _BuildWidgetCategoryState extends State<BuildWidgetCategory> {
  late int selectedGenre;

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.selectedGenre;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<GenreBloc>(
            create: (_) => GenreBloc()..add(GenreEventStarted()),
          ),
          BlocProvider<MovieBloc>(
            create: (_) =>
                MovieBloc()..add(MovieEventStarted(selectedGenre, '')),
          ),
        ],
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          BlocBuilder<GenreBloc, GenreState>(builder: (context, state) {
            if (state is GenreLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GenreLoaded) {
              List<Genre> genres = state.GenreList;
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  height: 45,
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const VerticalDivider(
                      color: Colors.transparent,
                      width: 5,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: genres.length,
                    itemBuilder: (context, index) {
                      Genre genre = genres[index];
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Genre genre = genres[index];
                                selectedGenre = genre.id;
                                context
                                    .read<MovieBloc>()
                                    .add(MovieEventStarted(selectedGenre, ''));
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black45,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                color: (genre.id == selectedGenre)
                                    ? Colors.red
                                    : Colors.white,
                              ),
                              child: Text(
                                genre.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: (genre.id == selectedGenre)
                                      ? Colors.white
                                      : Colors.black45,
                                  fontFamily: 'muli',
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
          const SizedBox(
            height: 10,
          ),
          nowPlayingRow(context),
          const SizedBox(
            height: 15,
          ),
          nowPlayingContent(context),
        ]));
  }

  Widget nowPlayingRow(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            'new playing'.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'muli',
            ),
          ),
        ),
        Container(
          child: InkWell(
            onTap: (){Navigator.pushReplacement(context, PageTransition(child: SeeMore(selectedGenre: selectedGenre), type: PageTransitionType.leftToRight));},
            child: Text(
              'See All'.toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'muli',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget nowPlayingContent(BuildContext context){
    return  BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
      if (state is MovieLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is MovieLoaded) {
        List<Movie> movieList = state.movieList;
        movieList.sort((a, b) {
          return b.voteAverage
              .toString()
              .compareTo(a.voteAverage.toString());
        });
        return Container(
          height: 300,
          child: ListView.separated(
            separatorBuilder: (context, index) => const VerticalDivider(
              color: Colors.transparent,
              width: 15,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              Movie movie = movieList[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {Navigator.pushReplacement(context, PageTransition(child: MovieDetailScreen(movie: movie), type: PageTransitionType.leftToRight));},
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl:
                        'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            width: 180,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        placeholder: (context, url) => Container(
                          width: 180,
                          height: 250,
                          child: const Center(
                              child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 180,
                          height: 250,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'images/img_not_found.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 180,
                    child: Text(
                      movie.title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'muli',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 14,
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 14,
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 14,
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 14,
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          movie.voteAverage.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
