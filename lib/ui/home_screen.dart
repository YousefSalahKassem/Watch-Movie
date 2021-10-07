import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:watchmovie/bloc/movie_bloc/movie_bloc_state.dart';
import 'package:watchmovie/bloc/person_bloc/person_bloc.dart';
import 'package:watchmovie/bloc/person_bloc/person_bloc_event.dart';
import 'package:watchmovie/bloc/person_bloc/person_bloc_state.dart';
import 'package:watchmovie/constant/Constantcolors.dart';
import 'package:watchmovie/model/movie.dart';
import 'package:watchmovie/model/person.dart';

import 'category_screen.dart';
import 'movie_details.dart';

class HomeScreen extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MovieBloc>(
              create: (_) => MovieBloc()..add(const MovieEventStarted(0, ''))),
          BlocProvider<PersonBloc>(
              create: (_) => PersonBloc()..add(const PersonEventStarted())),
        ],
        child: Scaffold(
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
          body: content(context),
        ));
  }
}

Widget content(BuildContext context) {
  return SingleChildScrollView(
    child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else if (state is MovieLoaded) {
                    List<Movie> movies = state.movieList;
                    return Column(
                      children: [
                        slider(context, movies),
                        trendingPerson(context),
                      ],
                    );
                  }
                  else {
                    return Container(
                      child: const Text('Something went wrong!!!'),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget slider (BuildContext context,List<Movie> movies){
  return CarouselSlider.builder(
    itemCount: movies.length,
    itemBuilder:
        (BuildContext context, int index, int ind) {
      Movie movie = movies[index];
      return GestureDetector(
        onTap: () {Navigator.pushReplacement(context, PageTransition(child: MovieDetailScreen(movie:movie), type: PageTransitionType.leftToRight));},
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            ClipRRect(
              child: CachedNetworkImage(
                imageUrl:
                'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                height:
                MediaQuery.of(context).size.height /
                    3,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'images/img_not_found.png'),
                        ),
                      ),
                    ),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 15,
                left: 15,
              ),
              child: Text(
                movie.title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'muli',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    },
    options: CarouselOptions(
      enableInfiniteScroll: true,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 5),
      autoPlayAnimationDuration:
      const Duration(milliseconds: 800),
      pauseAutoPlayOnTouch: true,
      viewportFraction: 0.8,
      enlargeCenterPage: true,
    ),
  );
}

Widget trendingPerson(BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BuildWidgetCategory(),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Trending persons on this week',
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'muli',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: <Widget>[
            BlocBuilder<PersonBloc, PersonState>(
              builder: (context, state) {
                if (state is PersonLoading) {
                  return Center();
                } else if (state is PersonLoaded) {
                  List<Person> personList =
                      state.PersonList;
                  personList.sort((a, b) {
                    return b.popularity
                        .toString()
                        .compareTo(a.popularity.toString());});

                  return Container(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: personList.length,
                      separatorBuilder:
                          (context, index) =>
                      const VerticalDivider(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      itemBuilder: (context, index) {
                        Person person = personList[index];
                        return Container(
                          child: Column(
                            children: <Widget>[
                              Card(
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(100),
                                ),
                                elevation: 3,
                                child: ClipRRect(
                                  child:
                                  CachedNetworkImage(
                                    imageUrl:
                                    'https://image.tmdb.org/t/p/w200${person.profilePath}',
                                    imageBuilder: (context,
                                        imageProvider) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        decoration:
                                        BoxDecoration(
                                          borderRadius:
                                          const BorderRadius
                                              .all(
                                            Radius
                                                .circular(
                                                100),
                                          ),
                                          image:
                                          DecorationImage(
                                            image:
                                            imageProvider,
                                            fit: BoxFit
                                                .cover,
                                          ),
                                        ),
                                      );
                                    },
                                    placeholder:
                                        (context, url) =>
                                        Container(
                                          width: 80,
                                          height: 80,
                                          child: const Center(
                                              child:
                                              CircularProgressIndicator()),
                                        ),
                                    errorWidget: (context,
                                        url, error) =>
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration:
                                          const BoxDecoration(
                                            image:
                                            DecorationImage(
                                              image: AssetImage(
                                                  'images/img_not_found.png'),
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Center(
                                  child: Text(
                                    person.name
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color:
                                      Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Center(
                                  child: Text(
                                    person
                                        .knowForDepartment
                                        .toUpperCase(),
                                    style:
                                    const TextStyle(
                                      color:
                                      Colors.white,
                                      fontSize: 8,
                                      fontFamily: 'muli',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ],
    ),
  );
}