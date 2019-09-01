// login_waiting_holder.dart
import '../jedux_data/jedux_const.dart';
import '../jedux/jedux.dart';

class LoginWaitingHolder extends JeduxHolder {
  static LoginWaitingHolder build(Map data, JeduxHolder parent) {
    return LoginWaitingHolder(data, parent);
  }

  LoginWaitingHolder(Map data, JeduxHolder parent) : super(data, parent);

  String get title => getProperty(JeduxConst.TITLE);

  set title(String value) => setProperty(JeduxConst.TITLE, value);

  void onEnd() {
    nextCycled.opened = true;
  }
}
