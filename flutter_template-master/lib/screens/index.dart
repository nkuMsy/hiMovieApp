import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/click.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/utils/provider.dart';
import 'package:flutter_template/widgets/best_movies.dart';
import 'package:flutter_template/widgets/genres.dart';
import 'package:flutter_template/widgets/now_playing.dart';
import 'package:flutter_template/widgets/persons.dart';
import 'package:flutter_template/widgets/search.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_template/style/theme.dart' as Style;
import '../page/menu/menu_drawer.dart';

class MainHomePage extends StatefulWidget {
  MainHomePage({Key key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
      return WillPopScope(
          child: Scaffold(
            backgroundColor: Style.Colors.mainColor,
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(I18n
                  .of(context)
                  .title),
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      Get.to(() => SearchPage());
                    },
                    icon: Icon(Icons.search, color: Colors.white,)
                )
              ],
            ),

            drawer: MenuDrawer(),
            body: ListView(
              children: <Widget>[
                NowPlaying(),
                GenresScreen(),
                PersonsList(),
                BestMovies(),

              ],
            ),
          ),
          //监听导航栏返回,类似onKeyEvent
          onWillPop: () =>
              ClickUtils.exitBy2Click(status: _scaffoldKey.currentState));
  }
}
