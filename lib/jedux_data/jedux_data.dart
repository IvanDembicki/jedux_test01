import '../jedux.dart';

class JeduxData {
  static const Map<String, dynamic> map = {
    JeduxDataFormat.TYPE: "App",
    JeduxDataFormat.PROPS: {"url": "", "title": "Application", "session": ""},
    JeduxDataFormat.CHILDREN: [
      {
        JeduxDataFormat.TYPE: "LoginWaiting",
        JeduxDataFormat.PROPS: {"title": "Waiting..."},
        JeduxDataFormat.CHILDREN: [],
      },
      {
        JeduxDataFormat.TYPE: "LoginLoading",
        JeduxDataFormat.PROPS: {"title": "Loading..."},
        JeduxDataFormat.CHILDREN: [],
      },
      {
        JeduxDataFormat.TYPE: "LoginError",
        JeduxDataFormat.PROPS: {"title": "Error..."},
        JeduxDataFormat.CHILDREN: [],
      },
      {
        JeduxDataFormat.TYPE: "LoginReady",
        JeduxDataFormat.PROPS: {"title": "Ready!"},
        JeduxDataFormat.CHILDREN: [
          {
            JeduxDataFormat.TYPE: "UserPaid",
            JeduxDataFormat.PROPS: {"title": "Paid"},
            JeduxDataFormat.CHILDREN: [
              {
                JeduxDataFormat.TYPE: "UserPage",
                JeduxDataFormat.PROPS: {"url": "..."},
                JeduxDataFormat.CHILDREN: [],
              },
            ],
          },
          {
            JeduxDataFormat.TYPE: "UserNewbie",
            JeduxDataFormat.PROPS: {"title": "Newbie"},
            JeduxDataFormat.CHILDREN: [],
          },
          {
            JeduxDataFormat.TYPE: "UserExpired",
            JeduxDataFormat.PROPS: {"title": "Expired"},
            JeduxDataFormat.CHILDREN: [],
          },
        ],
      },
    ],
  };
}
