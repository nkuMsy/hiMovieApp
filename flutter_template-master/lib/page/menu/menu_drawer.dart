import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/utils/xuifont.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/page/menu/login.dart';
import 'package:flutter_template/page/menu/settings.dart';
import 'package:flutter_template/utils/provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'favorite.dart';
import 'me.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProfile, AppStatus>(builder: (BuildContext context,
        UserProfile value, AppStatus status, Widget child) {
      return Drawer(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipOval(
                        // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                        child:Image.asset(
                          'assets/image/greyLogo.png',
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      value.nickName != null
                          ? value.nickName
                          : I18n.of(context).title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ))
                  ],
                ),
              ),
            ),
            MediaQuery.removePadding(
              context: context,
              // DrawerHeader consumes top MediaQuery padding.
              removeTop: true,
              child: ListView(
                shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
                physics: NeverScrollableScrollPhysics(), //禁用滑动事件
                scrollDirection: Axis.vertical, // 水平listView
                children: <Widget>[
                  //首页
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text(I18n.of(context).home),
                    onTap: () {
                      status.tabIndex = TAB_HOME_INDEX;
                      Navigator.pop(context);
                    },
                    selected: status.tabIndex == TAB_HOME_INDEX,
                  ),

                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(I18n.of(context).profile),
                    onTap: () {
                      // status.tabIndex = TAB_PROFILE_INDEX;
                      // Navigator.pop(context);
                      Get.to(() => MePage());
                    },
                    selected: status.tabIndex == TAB_PROFILE_INDEX,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(I18n.of(context).settings),
                    onTap: () {
                      Get.to(() => SettingsPage());
                    },
                  ),
                  //退出
                  Divider(height: 1.0, color: Colors.grey),
                  ListTile(
                    leading: Icon(XUIIcons.logout),
                    title: Text(I18n.of(context).logout),
                    onTap: () {
                      value.nickName = "";
                      Get.offAll(() => LoginPage());
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ));
    });
  }
}
