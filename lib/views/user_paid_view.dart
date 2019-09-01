// user_paid_view.dart
import 'package:flutter/material.dart';
import '../jedux/jedux.dart';
import '../jedux_holders/user_paid_holder.dart';

import '../jedux_holders/user_page_holder.dart';
import 'user_page_view.dart';

class UserPaidView extends JeduxListener {
  UserPaidHolder get _holder => jeduxHolder as UserPaidHolder;

  UserPaidView(JeduxHolder stateHolder, {Key key}) : super(stateHolder, key: key);

  @override
  Widget build(BuildContext context) {
    print("${_holder.tabs}[UserPaidView].build([context])");
    return Center(
      child: Column(
        children: <Widget>[
          Text(_holder.title),
          MaterialButton(
            color: Colors.blue,
            onPressed: _holder.onPressed,
            child: Text("User paid button"),
          ),
          Text("Hello world"),

          // _getOpenedChildView(_holder.openedChild),
        ],
      ),
    );
  }

  JeduxListener _getOpenedChildView(JeduxHolder openedHolder) {
    switch (openedHolder.runtimeType) {
      case UserPageHolder:
        return UserPageView(openedHolder);
    }
    print("***ERROR*** [UserPaidView]._getOpenedChildView([${openedHolder.runtimeType}])");
    return null;
  }
}
