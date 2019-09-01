import 'package:flutter/material.dart';

import 'jedux/jedux.dart';
import 'jedux_data/jedux_builders.dart';
import 'jedux_data/jedux_data.dart';
import 'views/app_view.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  final jeduxHolder = JeduxHolder.create(JeduxData.map, JeduxBuilders.map);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jedux Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JeduxProvider(
        childBuilder: _getOpenedChildView,
        jeduxHolder: jeduxHolder,
      ),
    );
  }

  JeduxListener _getOpenedChildView(JeduxHolder holder) {
    return AppView(holder);
  }
}
