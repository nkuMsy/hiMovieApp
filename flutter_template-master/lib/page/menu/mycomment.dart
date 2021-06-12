import 'dart:convert';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/utils/provider.dart';
import 'package:provider/provider.dart';
import 'editcomment.dart';


class MyCommentPage extends StatefulWidget {
  List list;
  String nickname;
  MyCommentPage({Key key, @required this.list, @required this.nickname}) : super(key: key);
  @override
  _MyCommentPageState createState() => _MyCommentPageState(list, nickname);
}

class _MyCommentPageState extends State<MyCommentPage> {
  List list;
  String nickname;
  _MyCommentPageState(this.list, this.nickname);
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    setState(() {
    });
  }
  cloudbase() async {
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
          title: Text(I18n
              .of(context)
              .comment),
        ),
        body:
        RefreshIndicator(
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
            Collection collection = db.collection('review');
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
            primary: true,
            itemBuilder: (context, index) {
              if(list[index]["review"] != null) {
                return ListTile(
                  title: Text(list[index]["review"]),
                  leading: Image.asset("assets/image/blackLogo.png"),
                  subtitle: Text(
                      list[index]["title"] + "\n" + list[index]["date"]
                  ),
                  trailing: new IconButton(
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
                        CloudBaseDatabase db = CloudBaseDatabase(core);
                        Collection collection = db.collection('review');
                        collection.where({
                          "username": value.nickName,
                          "movieid": list[index]["movieid"],
                          "date": list[index]["date"],
                        }).remove().then((res) {
                          collection.where({
                            "username": value.nickName,
                          }).get().then((res) {
                            setState(() {
                              list = res.data;
                            });
                          });
                        }).catchError((e) {
                          print("获取数据失败");
                        });
                      },
                      icon: Icon(Icons.delete)),
                  onLongPress: (){
                    Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context) => new editCommentPage(id: list[index]["movieid"], title: list[index]["title"], review: list[index]["review"])),
                    );
                  },


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
    );
  });
  }

}
