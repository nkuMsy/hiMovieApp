import 'package:flutter/material.dart';
import 'package:flutter_template/init/splash.dart';
import 'package:flutter_template/screens/index.dart';
import 'package:flutter_template/page/menu/login.dart';
import 'package:flutter_template/page/menu/settings.dart';
import 'package:flutter_template/page/menu/favorite.dart';
import 'package:get/get.dart';

class RouteMap {
  static List<GetPage> getPages = [
    GetPage(name: '/', page: () => SplashPage()),
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/home', page: () => MainHomePage()),
    GetPage(name: '/menu/settings-page', page: () => SettingsPage()),
  ];

  /// 页面切换动画
  static Widget getTransitions(
      BuildContext context,
      Animation<double> animation1,
      Animation<double> animation2,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
              //1.0为右进右出，-1.0为左进左出
              begin: Offset(1.0, 0.0),
              end: Offset(0.0, 0.0))
          .animate(
              CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  }
}
