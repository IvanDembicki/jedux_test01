// app_view.dart
import 'package:flutter/material.dart';
import 'package:jedux_test01/jedux.dart';
import '../jedux_holders/app_holder.dart';

import '../jedux_holders/login_waiting_holder.dart';
import '../jedux_holders/login_loading_holder.dart';
import '../jedux_holders/login_error_holder.dart';
import '../jedux_holders/login_ready_holder.dart';
import 'login_waiting_view.dart';
import 'login_loading_view.dart';
import 'login_error_view.dart';
import 'login_ready_view.dart';

class AppView extends JeduxListener {
  AppHolder get _holder => jeduxHolder as AppHolder;

  AppView(JeduxHolder stateHolder, {Key key}) : super(stateHolder, key: key);

  @override
  Widget build(BuildContext context) {
    return _getOpenedChildView(_holder.openedChild);
  }

  JeduxListener _getOpenedChildView(JeduxHolder openedHolder) {
    openedHolder = openedHolder ?? jeduxHolder.initOpenedChild(byPosition: 1);
    switch (openedHolder.runtimeType) {
      case LoginWaitingHolder:
        return LoginWaitingView(openedHolder);
      case LoginLoadingHolder:
        return LoginLoadingView(openedHolder);
      case LoginErrorHolder:
        return LoginErrorView(openedHolder);
      case LoginReadyHolder:
        return LoginReadyView(openedHolder);
    }
    print("***ERROR*** [AppView]._getOpenedChildView([${openedHolder.runtimeType}])");
    return null;
  }
}
