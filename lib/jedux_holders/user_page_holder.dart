// user_page_holder.dart
import '../jedux_data/jedux_const.dart';
import 'package:jedux_test01/jedux.dart';

class UserPageHolder extends JeduxHolder {
  static UserPageHolder build(Map data, JeduxHolder parent) {
    return UserPageHolder(data, parent);
  }

  UserPageHolder(Map data, JeduxHolder parent) : super(data, parent);

  String get url => getProperty(JeduxConst.URL);
}
