// login_loading_holder.dart
import '../jedux_data/jedux_const.dart';
import 'package:jedux_test01/jedux.dart';

class LoginLoadingHolder extends JeduxHolder {
  static LoginLoadingHolder build(Map data, JeduxHolder parent) {
    return LoginLoadingHolder(data, parent);
  }

  LoginLoadingHolder(Map data, JeduxHolder parent) : super(data, parent);

  String get title => getProperty(JeduxConst.TITLE);

  set title(String value) => setProperty(JeduxConst.TITLE, value);

  void onEnd() {
    nextCycled.opened = true;
  }
}
