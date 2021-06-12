import 'dart:convert';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'FriendCell.dart';
import 'friendmodel_entity.dart';
import 'package:flutter_template/style/theme.dart' as Style;

import 'newcomment.dart';

class CommentPage extends StatefulWidget {
  String img;
  String title;
  List list;
  int id;
  CommentPage({Key key, @required this.img, @required this.title, @required this.id, @required this.list}) : super(key: key);
  @override
  _CommentPageState createState() => _CommentPageState(img, title, id, list);
}

class _CommentPageState extends State<CommentPage> {
  String img;
  String title;
  List list;
  int id;
  _CommentPageState(this.img, this.title, this.id, this.list);
  ScrollController _scrollController = new ScrollController();

  @override
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
    Collection collection = db.collection('review');
    collection.where({
      "movieid": id,
    }).get().then((res) {
      setState(() {
        list = res.data;
      });
      print(list);
    }).catchError((e) {
      print("获取失败");
    });
  }


  @override
  Widget build(BuildContext context) {

    cloudbase();
    // print(list);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n
            .of(context)
            .comment),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Style.Colors.secondColor,
        child: Icon(Icons.add, color:Colors.white),
        //点击事件
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new NewCommentPage(id: id, title:title)),
          );
        },
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endFloat, -10, -20),
      // body: Stack(
      //   children: <Widget>[
      //
      //
      //   ],
      //
      //
      // ),
      body:Column(
          children :[
            // ListView(
            //   padding: EdgeInsets.only(top: 0),
            //   // controller: _scrollController,
            //   children: <Widget>[
                Container(
                  height: 220,
                  color: Color(0XFFFEFFFE),
                  child: Stack(
                    children: <Widget>[
                      // Text("mmmmmmmmm"),
                      Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,

                          child: Image.network("https://image.tmdb.org/t/p/original/" + img , fit: BoxFit.fill,)
                      ),
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: Text(title  ,
                          style: TextStyle(
                              fontSize: 16 ,
                              fontWeight: FontWeight.w600 ,
                              color: Colors.white ,
                              shadows:[
                                Shadow(color: Colors.black, offset: Offset(1, 1))
                              ]
                          ),
                        ),
                      )

                    ],
                  ),
                ),

            //   ],
            // ),
            RefreshIndicator(
              onRefresh: () async {
                cloudbase();
              },
            child:
            Container(
              height: 500,
              child:
                ListView.separated(
                  primary: true,
                  //数据的长度，有几个渲染几个，动态的进行渲染
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(list[index]["review"]),
                      leading: Image.asset("assets/image/blackLogo.png"),
                      subtitle: Text(
                          list[index]["username"] + "  " + list[index]["date"]
                      ),
                    );
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
          )
          ]
      )
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;    // X方向的偏移量
  double offsetY;    // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
