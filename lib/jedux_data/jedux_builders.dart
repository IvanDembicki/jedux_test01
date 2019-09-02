import 'package:jedux_test01/jedux/jedux.dart';
import 'package:jedux_test01/jedux_holders/app_holder.dart';
import 'package:jedux_test01/jedux_holders/login_error_holder.dart';
import 'package:jedux_test01/jedux_holders/login_loading_holder.dart';
import 'package:jedux_test01/jedux_holders/login_ready_holder.dart';
import 'package:jedux_test01/jedux_holders/login_waiting_holder.dart';
import 'package:jedux_test01/jedux_holders/user_expired_holder.dart';
import 'package:jedux_test01/jedux_holders/user_newbie_holder.dart';
import 'package:jedux_test01/jedux_holders/user_page_holder.dart';
import 'package:jedux_test01/jedux_holders/user_paid_holder.dart';

import 'jedux_const.dart';

class JeduxBuilders {
  static final Map<String, JeduxHolderBuilder> map = {
    JeduxConst.APP_HOLDER: AppHolder.build,
    JeduxConst.LOGIN_WAITING_HOLDER: LoginWaitingHolder.build,
    JeduxConst.LOGIN_LOADING_HOLDER: LoginLoadingHolder.build,
    JeduxConst.LOGIN_ERROR_HOLDER: LoginErrorHolder.build,
    JeduxConst.LOGIN_READY_HOLDER: LoginReadyHolder.build,
    JeduxConst.USER_NEWBIE_HOLDER: UserNewbieHolder.build,
    JeduxConst.USER_EXPIRED_HOLDER: UserExpiredHolder.build,
    JeduxConst.USER_PAID_HOLDER: UserPaidHolder.build,
    JeduxConst.USER_PAGE_HOLDER: UserPageHolder.build,
  };
}
