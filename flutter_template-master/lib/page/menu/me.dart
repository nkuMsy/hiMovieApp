import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/page/menu/language.dart';
import 'package:flutter_template/utils/provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'favorite.dart';
import 'mycomment.dart';

class MePage extends StatefulWidget {
  @override
  MePageState createState() => MePageState();
}

class MePageState extends State<MePage> {
  List _list = [];
  List _list1 = [];
  String nickname;

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProfile, AppStatus>(builder: (BuildContext context,
        UserProfile value, AppStatus status, Widget child) {
    return Scaffold(
        appBar: AppBar(title: Text(I18n
            .of(context)
            .profile)),
        body: SingleChildScrollView(
            child: ListBody(children: <Widget>[
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.favorite_border),
                title: Text(I18n
                    .of(context)
                    .star),
                trailing: Icon(Icons.keyboard_arrow_right),
                contentPadding: EdgeInsets.only(left: 20, right: 10),
                onTap: () async {

                  // 添加到腾讯云数据库
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
                      this._list1 = res.data;
                      this.nickname = value.nickName;
                    });
                    print(_list1);
                  }).catchError((e) {
                    print("获取数据失败");
                  });

                  // Get.to(() => FavoritePage());
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new FavoritePage(list: _list1, nickname: nickname)),
                  );

                },
              ),
              ListTile(
                leading: Icon(Icons.message_outlined),
                title: Text(I18n
                    .of(context)
                    .comment),
                trailing: Icon(Icons.keyboard_arrow_right),
                contentPadding: EdgeInsets.only(left: 20, right: 10),
                onTap: () async {

                  // 添加到腾讯云数据库
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
                      this._list = res.data;
                    });
                    print(_list);
                  }).catchError((e) {
                    print("获取数据失败");
                  });

                  // Get.to(() => FavoritePage());
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new MyCommentPage(list: _list, nickname: nickname, )),
                  );

                },
              ),
            ])
        )
    );
  });
  }
}
