// app_holder.dart
import '../jedux_data/jedux_const.dart';
import 'package:jedux_test01/jedux.dart';

class AppHolder extends JeduxHolder {
  static AppHolder build(Map data, JeduxHolder parent) {
    return AppHolder(data, parent);
  }

  AppHolder(Map data, JeduxHolder parent) : super(data, parent);

  String get url => getProperty(JeduxConst.URL);

  set url(String value) => setProperty(JeduxConst.URL, value);

  String get title => getProperty(JeduxConst.TITLE);

  set title(String value) => setProperty(JeduxConst.TITLE, value);

  String get session => getProperty(JeduxConst.SESSION);

  set session(String value) => setProperty(JeduxConst.SESSION, value);
}
