// views/user_page_view.dart

import 'package:flutter/material.dart';
import '../jedux/jedux.dart';
import '../jedux_holders/user_page_holder.dart';

class UserPageView extends JeduxListener {
  UserPageHolder get _holder => jeduxHolder as UserPageHolder;

  UserPageView(JeduxHolder stateHolder, {Key key}) : super(stateHolder, key: key);

  @override
  Widget build(BuildContext context) {
    return Text("Hello world ${_holder.nodeType}");
  }
}
