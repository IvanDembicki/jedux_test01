// user_newbie_holder.dart
import '../jedux_data/jedux_const.dart';
import 'package:jedux_test01/jedux.dart';

class UserNewbieHolder extends JeduxHolder {
  static UserNewbieHolder build(Map data, JeduxHolder parent) {
    return UserNewbieHolder(data, parent);
  }

  UserNewbieHolder(Map data, JeduxHolder parent) : super(data, parent);

  String get title => getProperty(JeduxConst.TITLE);

  set title(String value) => setProperty(JeduxConst.TITLE, value);

  void onPressed() {
    nextSibling == null ? parent.firstChild.opened = true : nextSibling.opened = true;
  }

}
