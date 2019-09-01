import 'package:flutter/material.dart';

import 'jedux.dart';

class JeduxProvider extends StatefulWidget {
  final JeduxHolder jeduxHolder;
  final JeduxListener Function(JeduxHolder holder) childBuilder;

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
    child = widget.childBuilder(widget.jeduxHolder);
    widget.jeduxHolder.addListener(NotifyType.PROPERTY_CHANGED, onPropertyChanged);
    widget.jeduxHolder.addListener(NotifyType.STRUCTURE_CHANGED, onStructureChanged);
    super.initState();
  }

  void resetChild() {
    print("[${runtimeType}].resetChild([]) — ${widget.jeduxHolder.nodeType}");
      child = widget.childBuilder(widget.jeduxHolder);
  }

  void onPropertyChanged(dynamic type) => setState(() => resetChild());

  void onStructureChanged(dynamic type) => setState(() => resetChild());

  @override
  Widget build(BuildContext context) {
    print("[_JeduxProviderState].build([context]) ${runtimeType}");
    return child;
  }
}

/// Build a Widget using the [BuildContext] and [ViewModel]. The [ViewModel] is
/// derived from the [Store] using a [StoreConverter].
//typedef ViewModelBuilder<ViewModel> = Widget Function(
//    BuildContext context,
//    ViewModel vm,
//    );
