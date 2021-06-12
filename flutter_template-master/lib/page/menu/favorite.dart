import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/model/movie.dart';
import 'package:flutter_template/screens/collect_detail_screen.dart';
import 'package:flutter_template/screens/detail_screen.dart';
import 'package:flutter_template/utils/provider.dart';
import 'package:provider/provider.dart';


class FavoritePage extends StatefulWidget {
  List list = [];
  String nickname;
  FavoritePage({Key key, @required this.list, @required this.nickname}) : super(key: key);
  @override
  _FavoritePageState createState() => _FavoritePageState(list, nickname);
}

class _FavoritePageState extends State<FavoritePage> {

  List list = [];
  String nickname;
  Movie movies;
  _FavoritePageState(this.list, this.nickname);

  void initState() {
    super.initState();
    setState(() {});
  }
  Future<void> cloudbase() async {
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
    Collection collection = db.collection('collection');
    if(nickname != null) {
      collection.where({
        "username": nickname
      }).get().then((res) {
        print(res.data);
        setState(() {
          this.list = res.data;
        });
        print(list);
      }).catchError((e) {
        print("获取数据失败");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    cloudbase();
    return Consumer2<UserProfile, AppStatus>(builder: (BuildContext context,
        UserProfile value, AppStatus status, Widget child) {

      return Scaffold(
          appBar: AppBar(
            title: Text(I18n.of(context).star),
          ),
          body:RefreshIndicator(
            onRefresh: () async {
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
              Collection collection = db.collection('collection');
                collection.where({
                  "username": value.nickName
                }).get().then((res) {
                  print(res.data);
                  setState(() {
                    this.list = res.data;
                  });
                  print(list);
                }).catchError((e) {
                  print("获取数据失败");
                });
            },
            child:
                ListView.separated(
                  //数据的长度，有几个渲染几个，动态的进行渲染
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    if(list[index]['backPoster'] != null) {
                    return ListTile(
                      onTap: () async {
                        String path = 'https://api.themoviedb.org/3/movie/' + list[index]["id"].toString() + '?api_key=ca2ed587003ec9a4b8d8234c5868e889&language=en-US';
                        print(path);
                        Response response = await Dio().get(path);
                        // 得到数据并转换格式
                        print(response.data);
                        movies = new Movie.fromJson(response.data);
                        print(movies);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CollectDetailScreen(movie: movies),
                          ),
                        );
                      },
                      title: Text(list[index]["title"]),
                      leading: Image.network("https://image.tmdb.org/t/p/original/" + list[index]['backPoster']),
                      subtitle: Text(list[index]["rating"].toString()),
                    );
                    }
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: .5,
                      indent: 75,
                      color: Color(0xFFDDDDDD),
                    );
                  },
                ),
          )
          // )
      );
  });
  }

}
