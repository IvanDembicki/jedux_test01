import 'package:flutter/material.dart';

import 'jedux.dart';

typedef ChildBuilder = JeduxListener Function(JeduxHolder holder);

class JeduxProvider extends StatefulWidget {
  final JeduxHolder jeduxHolder;
  final ChildBuilder childBuilder;

  JeduxProvider({Key key, @required this.jeduxHolder, @required this.childBuilder})
      : assert(jeduxHolder != null),
        assert(childBuilder != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _JeduxProviderState();
}

class _JeduxProviderState extends State<JeduxProvider> {
  JeduxListener child;

  @override
  void initState() {
    resetChild();
    widget.jeduxHolder.addListener(NotifyType.PROPERTY_CHANGED, onPropertyChanged);
    widget.jeduxHolder.addListener(NotifyType.STRUCTURE_CHANGED, onStructureChanged);
    super.initState();
  }

  void resetChild() => child = widget.childBuilder(widget.jeduxHolder);

  void onPropertyChanged(dynamic type) => setState(() => resetChild());

  void onStructureChanged(dynamic type) => setState(() => resetChild());

  @override
  Widget build(BuildContext context) => child;

}
