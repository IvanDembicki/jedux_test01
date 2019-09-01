// views/login_loading_view.dart

import 'package:flutter/material.dart';
import '../jedux/jedux.dart';
import '../jedux_holders/login_loading_holder.dart';

class LoginLoadingView extends JeduxListener {
  LoginLoadingHolder get _holder => jeduxHolder as LoginLoadingHolder;

  LoginLoadingView(JeduxHolder stateHolder, {Key key}) : super(stateHolder, key: key);

  @override
  Widget build(BuildContext context) {
    print("${_holder.tabs}[LoginLoadingView].build([context])");
    return Scaffold(
        appBar: AppBar(title: Text(_holder.title), backgroundColor: Colors.blue),
        body: Column(
          children: <Widget>[
            Center(
              child: MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  _holder.onEnd();
                },
                child: Text("Loading view"),
              ),
            ),
          ],
        ));
  }
}
