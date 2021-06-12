import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/model/movie.dart';
import 'package:flutter_template/screens/detail_screen.dart';
import 'dart:convert';


var _titleTxt = new TextEditingController();

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SearchState();
  }
}

class _SearchState extends State<SearchPage> {
  //用来接收传过来数据
  List _list = [];
  List<Movie> movies;
  bool loadingVisible = false;
  FocusNode blankNode = FocusNode();

  @override
  Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
    //      centerTitle: true,
              title: TextFileWidget(),
              automaticallyImplyLeading: false,
              leading:IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _titleTxt.clear();
                  });
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    dioGetTest();
                    setState(() {
                      _titleTxt.clear();
                    });
                  },
                )
              ],
            ),
          //渲染数据
          body:
          GestureDetector(
            onTap: () {
              // 点击空白页面关闭键盘
              closeKeyboard(context);
            },
          child: ListView.separated(
              //数据的长度，有几个渲染几个，动态的进行渲染
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movie: movies[index]),
                        ),
                      );
                    },
                    title:Text(_list[index]["title"]),
                    leading: Image.network("https://image.tmdb.org/t/p/original/" + _list[index]['backdrop_path']),
                    subtitle: Text(_list[index]["release_date"]),
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

        ),


        );
  }


  //定义一个方法接收数据，异步异步异步
  dioGetTest() async {
    //可以指定Response类型，也可以使用var
    String path = 'https://api.themoviedb.org/3/search/movie?api_key=ca2ed587003ec9a4b8d8234c5868e889&query='+_titleTxt.text.toString();
    Response response = await Dio().get(path);
    //得到数据并转换格式
    Map<String, dynamic> responseData = json.decode(response.toString());
    print(responseData["results"]);
    setState(() {
      this._list = responseData["results"];
    });
    movies = (responseData["results"] as List).map((i) => new Movie.fromJson(i)).toList();
  }

  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }


}
///搜索控件widget
class TextFileWidget extends StatelessWidget {

  Widget buildTextField() {
    return TextField(
      controller: _titleTxt,
      cursorColor: Colors.white,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Movie Name",
          hintStyle: new TextStyle(fontSize: 14, color: Colors.white)),
      style: new TextStyle(fontSize: 14, color: Colors.white
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget editView() {
      return Container(
        //修饰黑色背景与圆角
        decoration: new BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0), //灰色的一层边框
          color: Colors.grey,
          borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
        ),
        alignment: Alignment.center,
        height: 36,
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        child: buildTextField(),
      );
    }

    return editView();

  }
}