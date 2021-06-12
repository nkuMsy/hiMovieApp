import 'dart:ui';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_template/bloc/get_movie_videos_bloc.dart';
import 'package:flutter_template/model/movie.dart';
import 'package:flutter_template/model/video.dart';
import 'package:flutter_template/model/video_response.dart';
import 'package:flutter_template/page/menu/comment.dart';
import 'package:flutter_template/style/theme.dart' as Style;
import 'package:flutter_template/utils/provider.dart';
import 'package:flutter_template/widgets/casts.dart';
import 'package:flutter_template/widgets/movie_info.dart';
import 'package:flutter_template/widgets/similar_movies.dart';
import 'package:provider/provider.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'video_player.dart';

class CollectDetailScreen extends StatefulWidget {
  final Movie movie;
  CollectDetailScreen({Key key, @required this.movie}) : super(key: key);
  @override
  _CollectDetailScreenState createState() => _CollectDetailScreenState(movie);
}

class _CollectDetailScreenState extends State<CollectDetailScreen> {
  final Movie movie;
  _CollectDetailScreenState(this.movie);
  var colors = Colors.red;
  var icons = Icons.favorite;
  List list = [];

  @override
  void initState() {
    super.initState();
    movieVideosBloc..getMovieVideos(movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideosBloc..drainStream();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProfile, AppStatus>(builder: (BuildContext context,
    UserProfile value, AppStatus status, Widget child) {
      return Scaffold(
        backgroundColor: Style.Colors.mainColor,
        body: new Builder(
          builder: (context) {
            return new SliverFab(
              floatingPosition: FloatingPosition(right: 20),
              floatingWidget: StreamBuilder<VideoResponse>(
                stream: movieVideosBloc.subject.stream,
                builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.error != null &&
                        snapshot.data.error.length > 0) {
                      return _buildErrorWidget(snapshot.data.error);
                    }
                    return _buildVideoWidget(snapshot.data);
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error);
                  } else {
                    return _buildLoadingWidget();
                  }
                },
              ),
              expandedHeight: 200.0,
              slivers: <Widget>[
                new SliverAppBar(
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(icons, size: 30, color: colors),
                      onPressed: () async {
                        //添加到腾讯云数据库
                        CloudBaseCore core = CloudBaseCore.init({
                          // 填写您的云开发 env
                          'env': 'msy-cloudbase-7gfbkzxjbdb5cdd8',
                          // 填写您的移动应用安全来源凭证
                          // 生成凭证的应用标识必须是 Android 包名或者 iOS BundleID
                          'appAccess': {
                            // 凭证
                            'key': '875f3415dda065fbab764a906c4d3c09',
                            // 版本
                            'version': '1'
                          }
                        });
                        CloudBaseAuth auth = CloudBaseAuth(core);
                        await auth.signInAnonymously().then((success) {
                          // 登录成功
                          print("连接上腾讯云 success");
                        }).catchError((err) {
                          // 登录失败
                          print(err);
                        });
                        // await auth.getUserInfo().then((userInfo) {
                        //   print(userInfo);
                        // }).catchError((err) {
                        //   // 获取用户信息失败
                        // });
                        CloudBaseDatabase db = CloudBaseDatabase(core);
                        Collection collection = db.collection('collection');

                          if (colors == Colors.brown[170]) {
                            setState(() {
                            colors = Colors.red;
                            icons = Icons.favorite;
                            });

                            collection.add({
                              "username": value.nickName,
                              "id": movie.id,
                              "title": movie.title,
                              "backPoster": movie.backPoster,
                              "rating": movie.rating,
                              "overview": movie.overview,
                              "popularity": movie.popularity,
                              "poster":movie.poster,
                            }).then((res) {
                                  print("收藏成功");
                            }).catchError((e) {
                                  print("收藏失败");
                            });


                          } else {
                            setState(() {
                            colors = Colors.brown[170];
                            icons = Icons.favorite_border;
                            });

                            collection.where({
                              "username": value.nickName,
                              "movieid": movie.id,
                            }).remove().then((res) {
                              print("取消收藏成功");
                            }).catchError((e) {
                              print("取消收藏失败");
                            });

                          }
                      },
                    )
                  ],
                  backgroundColor: Style.Colors.mainColor,
                  expandedHeight: 200.0,
                  pinned: true,
                  flexibleSpace: new FlexibleSpaceBar(
                      title: Text(
                        movie.title.length > 40
                            ? movie.title.substring(0, 37) + "..."
                            : movie.title,
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.normal),
                      ),
                      background: Stack(
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "https://image.tmdb.org/t/p/original/" +
                                          movie.backPoster)),
                            ),
                            child: new Container(
                              decoration: new BoxDecoration(
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  stops: [
                                    0.1,
                                    0.9
                                  ],
                                  colors: [
                                    Colors.black.withOpacity(0.9),
                                    Colors.black.withOpacity(0.0)
                                  ]),
                            ),
                          ),
                        ],
                      )),
                ),
                SliverPadding(
                    padding: EdgeInsets.all(0.0),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  movie.rating.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                RatingBar.builder(
                                  itemSize: 10.0,
                                  initialRating: movie.rating / 2,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  itemBuilder: (context, _) =>
                                      Icon(
                                        EvaIcons.star,
                                        color: Style.Colors.secondColor,
                                      ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                IconButton(
                                    onPressed:() async {
                                        //添加到腾讯云数据库
                                        CloudBaseCore core = CloudBaseCore.init({
                                          // 填写您的云开发 env
                                          'env': 'msy-cloudbase-7gfbkzxjbdb5cdd8',
                                          // 填写您的移动应用安全来源凭证
                                          // 生成凭证的应用标识必须是 Android 包名或者 iOS BundleID
                                          'appAccess': {
                                            // 凭证
                                            'key': '875f3415dda065fbab764a906c4d3c09',
                                            // 版本
                                            'version': '1'
                                          }
                                        });
                                        CloudBaseAuth auth = CloudBaseAuth(core);
                                        await auth.signInAnonymously().then((success) {
                                          // 登录成功
                                          print("连接上腾讯云 success");
                                        }).catchError((err) {
                                          // 登录失败
                                          print(err);
                                        });
                                        CloudBaseDatabase db = CloudBaseDatabase(core);
                                        Collection collection = db.collection('review');
                                        collection.where({
                                          "movieid": movie.id,
                                        }).get().then((res) {
                                          list = res.data;
                                          print(list);
                                        }).catchError((e) {
                                          print("获取失败");
                                        });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                          builder: (context) => CommentPage(img: movie.backPoster, title: movie.title, id: movie.id,  list: list),
                                      ),
                                      );
                                    },
                                    icon: Icon(
                                        Icons.message_outlined,
                                        size: 20,
                                        color: Colors.white),
                                ),

                              ],

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                            child: Text(
                              "OVERVIEW",
                              style: TextStyle(
                                  color: Style.Colors.titleColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              movie.overview,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  height: 1.5),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          MovieInfo(id: movie.id,),
                          Casts(
                            id: movie.id,
                          ),
                          SimilarMovies(id: movie.id)
                        ])))
              ],
            );
          },
        ),
      );
  });
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _buildVideoWidget(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
      backgroundColor: Style.Colors.secondColor,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              controller: YoutubePlayerController(
                initialVideoId: videos[0].key,
                flags: YoutubePlayerFlags(
                  autoPlay: true,
                  mute: true,
                ),
              ),
            ),
          ),
        );
      },
      child: Icon(Icons.play_arrow),
    );
  }
}
