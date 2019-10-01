// views/user_expired_view.dart

import 'package:flutter/material.dart';
import 'package:jedux_test01/jedux.dart';
import '../jedux_holders/user_expired_holder.dart';

class UserExpiredView extends JeduxListener {
  UserExpiredHolder get _holder => jeduxHolder as UserExpiredHolder;

  UserExpiredView(JeduxHolder stateHolder, {Key key}) : super(stateHolder, key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(_holder.title),
          MaterialButton(
            color: Colors.orange,
            onPressed: _holder.onPressed,
            child: Text("User expired button"),
          ),
        ],
      ),
    );
  }
}
