class ItemModel{
  late int page,total_pages,total_results;
  List<Result> results=[];

  ItemModel.fromJson(Map<String,dynamic> parseJson,bool isRecent){
    page=parseJson['page'];
    total_results=parseJson['total_results'];
    total_pages=parseJson['total_pages'];
    List<Result> temp=[];
    for(var i=0;i<parseJson['results'].length;i++){
      Result result=Result(parseJson['results'][i]);
      temp.add(result);
    }
    if(!isRecent){temp.sort((a,b){
      return b.popularity.compareTo(a.popularity);
    });}
    else{temp.sort((a,b){
      return DateTime.parse(b.release_date).compareTo(DateTime.parse(a.release_date));
    });}

    results=temp;
  }
}

class Result{
  late String vote_count,title,poster_path,backdrop_path,overview,release_date;
  late int id;
  late bool video,adult;
  late double popularity;
  var vote_average;
  List<int> genre_ids=[];

  Result(result){
    vote_count=result['vote_count'].toString();
    id=result['id'];
    video=result['video'];
    vote_average=result['vote_average'];
    title=result['title'].toString();
    popularity=result['popularity'];
    poster_path='http://image.tmdb.org/t/p/w185//'+result['poster_path'].toString();

    for(var i=0;i<result['genre_ids'].length;i++){
      genre_ids.add(result['genre_ids'][i]);
    }
    backdrop_path='http://image.tmdb.org/t/p/w185//'+result['backdrop_path'].toString();
    adult=result['adult'];
    overview=result['overview'];
    release_date=result['release_date'];
  }

  String get get_release_date=>release_date;
  String get get_overview=>overview;
  bool get get_adult=>adult;
  String get get_backdrop_path=>backdrop_path;
  List<int> get get_genre_ids=>genre_ids;
  String get get_poster_path=>poster_path;
  double get get_popularity=>popularity;
  String get get_title=>title;
  String get get_vote_average=>vote_average;
  bool get is_video=>video;
  String get get_vote_count=>vote_count;
  int get get_id=>id;

}