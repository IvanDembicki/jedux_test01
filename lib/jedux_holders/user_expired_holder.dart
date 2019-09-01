// user_expired_holder.dart
import '../jedux_data/jedux_const.dart';
import '../jedux/jedux.dart';

class UserExpiredHolder extends JeduxHolder {
  static UserExpiredHolder build(Map data, JeduxHolder parent) {
    return UserExpiredHolder(data, parent);
  }

  UserExpiredHolder(Map data, JeduxHolder parent) : super(data, parent);
  String get title => getProperty(JeduxConst.TITLE);
  set title(String value) => setProperty(JeduxConst.TITLE, value);


  void onPressed() {
    nextCycled.opened = true;
  }

}
