// login_ready_holder.dart
import '../jedux_data/jedux_const.dart';
import 'package:jedux_test01/jedux.dart';

class LoginReadyHolder extends JeduxHolder {
  static LoginReadyHolder build(Map data, JeduxHolder parent) {
    return LoginReadyHolder(data, parent);
  }

  LoginReadyHolder(Map data, JeduxHolder parent) : super(data, parent);

  String get title => getProperty(JeduxConst.TITLE);

  set title(String value) => setProperty(JeduxConst.TITLE, value);

  void onEnd() {
    nextCycled.opened = true;
  }
}
