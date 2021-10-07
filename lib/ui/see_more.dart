import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:watchmovie/bloc/genre_bloc/genre_bloc.dart';
import 'package:watchmovie/bloc/genre_bloc/genre_bloc_event.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc_state.dart';
import 'package:watchmovie/model/movie.dart';
import 'package:watchmovie/ui/home_screen.dart';

import 'movie_details.dart';

class SeeMore extends StatefulWidget {
final int selectedGenre;

SeeMore({required this.selectedGenre});

  @override
  _SeeMoreState createState() => _SeeMoreState();
}

class _SeeMoreState extends State<SeeMore> {
  late int selectedGenre;

  @override
  void initState() {
    selectedGenre=widget.selectedGenre;
    print(selectedGenre);
    super.initState();
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
      child: Scaffold(
        backgroundColor: const Color(0xFF1D1D28),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: InkWell(
            onTap: ()=>Navigator.pushReplacement(context, PageTransition(child: HomeScreen(), type: PageTransitionType.rightToLeft)),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: RichText(
              text: const TextSpan(
                  text: 'Watch',
                  style: TextStyle(
                    fontFamily: 'muli',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  children: <TextSpan>[
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
        body:
        BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (state is MovieLoaded) {
            List<Movie> movieList = state.movieList;
            movieList.sort((a, b) {
              return b.voteAverage
                  .toString()
                  .compareTo(a.voteAverage.toString());
            });
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                separatorBuilder: (context, index) => const VerticalDivider(
                  color: Colors.transparent,
                  width: 15,
                ),
                scrollDirection: Axis.vertical,
                itemCount: movieList.length,
                itemBuilder: (context, index) {
                  Movie movie = movieList[index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.start,
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
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
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
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Container(
                              width: 180,
                              child: Text(
                                movie.releaseDate.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'muli',
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 10,),
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
                          ],),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }
          else {
            return Container();
          }
        }),
      ),
    );
  }
}
