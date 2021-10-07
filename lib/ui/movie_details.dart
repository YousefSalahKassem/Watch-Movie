import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watchmovie/bloc/movie_details_bloc/details_bloc.dart';
import 'package:watchmovie/bloc/movie_details_bloc/event_details.dart';
import 'package:watchmovie/bloc/movie_details_bloc/state_details.dart';
import 'package:watchmovie/model/cast.dart';
import 'package:watchmovie/model/movie.dart';
import 'package:watchmovie/model/movie_details.dart';
import 'package:watchmovie/model/screen_shot.dart';
import 'package:watchmovie/ui/control_screen.dart';
import 'package:watchmovie/ui/home_screen.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_)=>MovieDetailBloc()..add(MovieDetailEventStated(movie.id)),
    child: WillPopScope(
        child: Scaffold(
          backgroundColor: const Color(0xFF1D1D28),
          body: bodyDetails(context),),
        onWillPop: ()async=>true),
    );
  }
}

Widget bodyDetails(BuildContext context){
  return SingleChildScrollView(
    child: BlocBuilder<MovieDetailBloc,DetailsState>(builder: (context,state){
      if(state is DetailsLoading){return const Center(child:CircularProgressIndicator() ,);}
      else if(state is DetailsLoaded){
        MovieDetail movieDetail=state.details;
        return Stack(children: [
          backgroundImage(context, movieDetail),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Container(
                padding: EdgeInsets.only(top: 120),
                child: GestureDetector(
                  onTap: () async {
                    final youtubeUrl =
                        'https://www.youtube.com/embed/${movieDetail.trailerId}';
                    if (!await canLaunch(youtubeUrl)) {
                      await launch(youtubeUrl);
                    }
                  },
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        const Icon(
                          Icons.play_circle_outline,
                          color: Colors.red,
                          size: 65,
                        ),
                        Text(
                          movieDetail.title.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'muli',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 160,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                            Text(
                            'Overview'.toUpperCase(),

                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                              color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            ),
                                ],)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      movieDetail.overview,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: 'muli',color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                             Text(
                            'Release date'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                              fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'muli',
                            ),
                            ),
                            Text(
                            movieDetail.releaseDate,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                            color: Colors.red,
                            fontSize: 18,
                            fontFamily: 'muli',
                            ),
                            ),
                            ],),
                            Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Average Rate'.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'muli',
                              ),
                            ),
                            Row(children: [
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              const SizedBox(width: 5,),
                              Text(
                                movieDetail.voteAverage.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontFamily: 'muli',
                                ),
                              ),
                            ],)

                          ],
                        ),
                            Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'budget'.toUpperCase(),
                              textAlign: TextAlign.center,

                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'muli',
                              ),
                            ),
                            Text(
                              movieDetail.budget+'\$',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                color: Colors.red,
                                fontSize: 18,
                                fontFamily: 'muli',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Screenshots'.toUpperCase(),
                  style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'muli',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(height: 155,
                child: ListView.separated(scrollDirection: Axis.horizontal,separatorBuilder: (context,index){
                  return const VerticalDivider(color: Colors.transparent,width: 5,);
                }, itemCount: movieDetail.movieImage.backdrops.length, itemBuilder: (BuildContext context, int index) {     Screenshot image =
                movieDetail.movieImage.backdrops[index];
                return Container(
                  child: Card(
                    elevation: 3,
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const Center(
                          child:  CircularProgressIndicator()

                        ),
                        imageUrl:
                        'https://image.tmdb.org/t/p/w500${image.imagePath}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ); },),),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Casts'.toUpperCase(),
                  style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'muli',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  height: 110,
                child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) =>
                const VerticalDivider(
                color: Colors.transparent,
                width: 5,
                ),
                itemCount: movieDetail.castList.length,
                itemBuilder: (context, index) {
                Cast cast = movieDetail.castList[index];
                return Container(
                child: Column(
                children: <Widget>[
                Card(
                shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(100),
                ),
                elevation: 3,
                child: ClipRRect(
                child: CachedNetworkImage(
                imageUrl:
                'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                imageBuilder:
                (context, imageBuilder) {
                return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                Radius.circular(100)),
                image: DecorationImage(
                image: imageBuilder,
                fit: BoxFit.cover,
                ),
                ),
                );
                },
                placeholder: (context, url) =>
                Container(
                width: 80,
                height: 80,
                child:const  Center(
                child: CircularProgressIndicator()

                ),
                ),
                errorWidget: (context, url, error) =>
                Container(
                width: 80,
                height: 80,
                decoration:const  BoxDecoration(
                image: DecorationImage(
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
                cast.name.toUpperCase(),
                style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontFamily: 'muli',
                ),
                ),
                ),
                ),
                Container(
                child: Center(
                child: Text(
                cast.character.toUpperCase(),
                style:const TextStyle(
                color: Colors.white,
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
                ),
              ),
              ],
          ),
          Positioned(left: 20,top: 50,child: InkWell(child: const Icon(Icons.arrow_back_ios,color: Colors.white,),onTap: (){Navigator.pushReplacement(context, PageTransition(child: const ControllScreen(), type: PageTransitionType.rightToLeft));},)),
        ],);
      }
      else{return Container();}
    }),
  );
}

Widget backgroundImage(BuildContext context,MovieDetail movieDetail){
  return ClipPath(
    child: ClipRRect(
      child: CachedNetworkImage(imageUrl: 'https://image.tmdb.org/t/p/original/${movieDetail.backdropPath}',
        height: MediaQuery.of(context).size.height/2,
        width: double.infinity,
        fit: BoxFit.cover,
        errorWidget: (context,url,error)=>Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/img_not_found.png'))),),
        placeholder: (context,url)=>const CircularProgressIndicator(),),
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
    ),
  );
}

