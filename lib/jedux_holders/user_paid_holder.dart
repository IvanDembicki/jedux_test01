// user_paid_holder.dart
import '../jedux_data/jedux_const.dart';
import 'package:jedux_test01/jedux.dart';

class UserPaidHolder extends JeduxHolder {
  static UserPaidHolder build(Map data, JeduxHolder parent) {
    return UserPaidHolder(data, parent);
  }

  UserPaidHolder(Map data, JeduxHolder parent) : super(data, parent);

  String get title => getProperty(JeduxConst.TITLE);

  set title(String value) => setProperty(JeduxConst.TITLE, value);

  void onPressed() {
    nextCycled.opened = true;
  }
}
