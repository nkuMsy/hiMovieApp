import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'friendmodel_entity.dart';

class FriendCell extends StatefulWidget {

  FriendmodelData model;

  FriendCell({this.model});
  @override
  State<StatefulWidget> createState() {
    return FriendCellState();
  }

}
class FriendCellState extends State<FriendCell> {

  double _width = 0;
  bool _isShow = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0XFFFEFFFE),
      child: Column(
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: ClipRRect(
                  child: Image.asset("assets/image/blackLogo.png" , fit: BoxFit.fill,),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Expanded(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.model.username , style: TextStyle(fontSize: 17 , color: Color(0XFF566B94) , fontWeight: FontWeight.w500),),
                          SizedBox(height: 5,),
                          Text(widget.model.review , style: TextStyle(fontSize: 15),),
                        ],
                      )
                  )
              )

            ],
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(

                  margin: EdgeInsets.only(left: 70),
                  child: Text(widget.model.date , style: TextStyle(fontSize: 12 , color: Color(0XFFB2B2B2)),),
                ),
              ),

            ],
          ),

          SizedBox(height: 10,),
          Container(height: 0.5, width: double.infinity, color: Colors.black26,)
        ],
      )



    );
  }

  void isShow() {
    _isShow = !_isShow;
    setState(() {
      _width = _isShow ? 120 : 0;
    });
  }

  var _starCount = 0;
  var _talkCount = 0;

}