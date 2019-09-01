// views/login_error_view.dart

import 'package:flutter/material.dart';
import '../jedux/jedux.dart';
import '../jedux_holders/login_error_holder.dart';

class LoginErrorView extends JeduxListener {
  LoginErrorHolder get _holder => jeduxHolder as LoginErrorHolder;

  LoginErrorView(JeduxHolder stateHolder, {Key key}) : super(stateHolder, key: key);

  @override
  Widget build(BuildContext context) {
    print("${_holder.tabs}[LoginErrorView].build([context])");
    return Scaffold(
        appBar: AppBar(title: Text(_holder.title), backgroundColor: Colors.red),
        body: Column(
          children: <Widget>[
            Center(
              child: MaterialButton(
                color: Colors.red,
                onPressed: () {
                  _holder.onEnd();
                },
                child: Text("Error view"),
              ),
            ),
          ],
        ));
  }
}