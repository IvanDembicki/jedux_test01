// views/user_newbie_view.dart

import 'package:flutter/material.dart';
import '../jedux/jedux.dart';
import '../jedux_holders/user_newbie_holder.dart';

class UserNewbieView extends JeduxListener {
  UserNewbieHolder get _holder => jeduxHolder as UserNewbieHolder;

  UserNewbieView(JeduxHolder stateHolder, {Key key}) : super(stateHolder, key: key);

  @override
  Widget build(BuildContext context) {
    print("${_holder.tabs}[UserNewbieView].build([context])");
    return Center(
      child: Column(
        children: <Widget>[
          Text(_holder.title),
          MaterialButton(color: Colors.lightGreen,
            onPressed: _holder.onPressed,
            child: Text("User newbie button"),
          ),
        ],
      ),
    );;
  }
}
