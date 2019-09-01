// login_ready_view.dart
import 'package:flutter/material.dart';
import '../jedux/jedux.dart';
import '../jedux_holders/login_ready_holder.dart';

import '../jedux_holders/user_newbie_holder.dart';
import '../jedux_holders/user_expired_holder.dart';
import '../jedux_holders/user_paid_holder.dart';
import 'user_newbie_view.dart';
import 'user_expired_view.dart';
import 'user_paid_view.dart';

class LoginReadyView extends JeduxListener {
  LoginReadyHolder get _holder => jeduxHolder as LoginReadyHolder;

  LoginReadyView(JeduxHolder stateHolder, {Key key}) : super(stateHolder, key: key);

  @override
  Widget build(BuildContext context) {
    print("${_holder.tabs}[LoginReadyView].build([context])");
    return Scaffold(
        appBar: AppBar(title: Text(_holder.title), backgroundColor: Colors.lightGreen),
        body: Column(
          children: <Widget>[
            Center(
              child: MaterialButton(
                color: Colors.lightGreen,
                onPressed: () {
                  _holder.onEnd();
                },
                child: Text("Ready view"),
              ),
            ),
            Column(
              children: <Widget>[
                Text("---- child of ready state ---"),
                _getOpenedChildView(_holder.openedChild),
              ],
            ),
          ],
        ));
  }

  JeduxListener _getOpenedChildView(JeduxHolder openedHolder) {
    switch (openedHolder.runtimeType) {
      case UserNewbieHolder:
        return UserNewbieView(openedHolder);
      case UserExpiredHolder:
        return UserExpiredView(openedHolder);
      case UserPaidHolder:
        return UserPaidView(openedHolder);
    }
    print("***ERROR*** [LoginReadyView]._getOpenedChildView([${openedHolder.runtimeType}])");
    return null;
  }

}
