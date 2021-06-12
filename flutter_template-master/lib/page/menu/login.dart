import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/loading_dialog.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/screens/index.dart';
import 'package:flutter_template/page/menu/register.dart';
import 'package:flutter_template/utils/provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 响应空白处的焦点的Node
  bool _isShowPassWord = false;
  FocusNode blankNode = FocusNode();
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
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
            // leading: _leading(context),
            title: Text(I18n
                .of(context)
                .login),
            actions: <Widget>[
              TextButton(
                child: Text(I18n
                    .of(context)
                    .register,
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Get.to(() => RegisterPage());
                },
              )
            ],
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

  //构建表单
  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey, //设置globalKey，用于后面获取FormState
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: <Widget>[
          Center(
              heightFactor: 1.5,
              child: Image.asset(
                'assets/image/blackLogo.png',
                width: 80,
                height: 80,
              )),
          TextFormField(
              autofocus: false,
              controller: _unameController,
              decoration: InputDecoration(
                  labelText: I18n
                      .of(context)
                      .loginName,
                  hintText: I18n
                      .of(context)
                      .loginNameHint,
                  hintStyle: TextStyle(fontSize: 12),
                  icon: Icon(Icons.person)),
              //校验用户名
              validator: (v) {
                return v
                    .trim()
                    .length > 0
                    ? null
                    : I18n
                    .of(context)
                    .loginNameError;
              }),
          TextFormField(
              controller: _pwdController,
              decoration: InputDecoration(
                  labelText: I18n
                      .of(context)
                      .password,
                  hintText: I18n
                      .of(context)
                      .passwordHint,
                  hintStyle: TextStyle(fontSize: 12),
                  icon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isShowPassWord
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: showPassWord)
              ),
              obscureText: !_isShowPassWord,
              //校验密码
              validator: (v) {
                return
                  v.trim().length >= 6 ? null : I18n.of(context).passwordError;
              }),
          // 登录按钮
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
                        .login,
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      //由于本widget也是Form的子代widget，所以可以通过下面方式获取FormState
                      if (Form.of(context).validate()) {
                        onSubmit(context);
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
  }

  ///点击控制密码是否显示
  void showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  //验证通过提交数据
  Future<void> onSubmit(BuildContext context) async {
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

    UserProfile userProfile = Provider.of<UserProfile>(context, listen: false);

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
    Collection collection = db.collection('user');
    collection.where({
      "username": _unameController.text,
      "password": _pwdController.text
    }).count().then((res) {
      print(res.total);
      if(res.total != 0) {
        print("登陆成功");
        Navigator.pop(context);
        userProfile.nickName = _unameController.text;
        ToastUtils.toast(I18n
            .of(context)
            .loginSuccess);
        Get.off(() => MainHomePage());
      }
      else{
        print("用户名密码错误");
        ToastUtils.error(I18n.of(context).loginNotMatch);
        Navigator.pop(context);
      }
    }).catchError((e) {
      print("登陆失败");
      ToastUtils.error(I18n.of(context).loginError);
      Navigator.pop(context);
    });

  }

}
