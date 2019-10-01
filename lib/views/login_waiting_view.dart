// views/login_waiting_view.dart

import 'package:flutter/material.dart';
import 'package:jedux_test01/jedux.dart';
import '../jedux_holders/login_waiting_holder.dart';

class LoginWaitingView extends JeduxListener {
  LoginWaitingHolder get _holder => jeduxHolder as LoginWaitingHolder;

  LoginWaitingView(JeduxHolder stateHolder, {Key key}) : super(stateHolder, key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_holder.title),
          backgroundColor: Colors.black26,
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: MaterialButton(
                color: Colors.black26,
                onPressed: () {
                  _holder.onEnd();
                },
                child: Text("Waiting view"),
              ),
            ),
          ],
        ));
  }
}
