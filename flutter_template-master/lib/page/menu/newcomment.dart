import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/loading_dialog.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/utils/provider.dart';
import 'package:provider/provider.dart';


class NewCommentPage extends StatefulWidget {
  int id;
  String title;
  NewCommentPage({Key key, @required this.id, @required this.title}) : super(key: key);

  @override
  NewCommentState createState() => NewCommentState(id, title);
}

class NewCommentState extends State<NewCommentPage> {
  int id;
  String title;
  NewCommentState(this.id, this.title);

// 响应空白处的焦点的Node
  bool _isShowPassWord = false;
  FocusNode blankNode = FocusNode();
  TextEditingController _reviewController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

      return WillPopScope(
          child: Scaffold(
            appBar: AppBar(
                leading: new IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              title: Text(I18n
                  .of(context)
                  .write),
            ),
            body: GestureDetector(
              onTap: () {
                // 点击空白页面关闭键盘
                closeKeyboard(context);
              },
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                child: buildForm(context),
              ),
            ),
          ),
          onWillPop: () async {
            return Future.value(false);
          });
  }

  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }


  //构建表单
  Widget buildForm(BuildContext context) {
    return Consumer2<UserProfile, AppStatus>(builder: (BuildContext context,
    UserProfile value, AppStatus status, Widget child) {
    return Form(
      key: _formKey, //设置globalKey，用于后面获取FormState
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: <Widget>[
          Center(
              heightFactor: 1.5,
              child: Image.asset(
                'assets/image/review.png',
                width: 50,
                height: 50,
              )),
          TextFormField(
            autofocus: false,
            controller: _reviewController,
            maxLines: 20,//最多多少行
            minLines: 1,//最少多少行
            style: TextStyle(fontSize: 16),//文字大小、颜色
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isCollapsed: true,//重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),//内容内边距，影响高度
              hintText: I18n
                  .of(context)
                  .reviewHint,
              hintStyle: TextStyle(fontSize: 16),
              ),
          ),

          // 提交按钮
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Builder(builder: (context) {
                  return ElevatedButton(
                    style: TextButton.styleFrom(
                        primary: Theme
                            .of(context)
                            .primaryColor,
                        padding: EdgeInsets.all(15.0)),
                    child: Text(I18n
                        .of(context)
                        .submit,
                        style: TextStyle(color: Colors.white)),

                    onPressed: () async {
                      print(_reviewController);
                      //由于本widget也是Form的子代widget，所以可以通过下面方式获取FormState
                      if (_reviewController != null) {
                        closeKeyboard(context);
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return LoadingDialog(
                                showContent: false,
                                backgroundColor: Colors.black38,
                                loadingView: SpinKitCircle(color: Colors.white),
                              );
                            });

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
                        DateTime dateTime= DateTime.now();
                        collection.add({
                          "title": title,
                          "movieid": id,
                          "username": value.nickName,
                          "review": _reviewController.text,
                          "date": dateTime.toString().substring(0,19),
                        }).then((res) {
                            print("发送成功");
                            Navigator.pop(context);
                            ToastUtils.toast(I18n
                                .of(context)
                                .submitSuccess);
                            Navigator.pop(context);
                        }).catchError((e) {
                          print("发送失败");
                          ToastUtils.error(I18n.of(context).submitError);
                          Navigator.pop(context);
                        });
                      }
                      else{
                        print("内容不能为空");
                        ToastUtils.error(I18n.of(context).reviewError);
                      }
                    },
                  );
                })),
              ],
            ),
          )
        ],
      ),
    );
    });
  }


}
