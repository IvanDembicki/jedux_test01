import 'package:flutter/widgets.dart';
import 'dart:async';

class DataConnector<S, ViewModel> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  /*
  @override
  Widget build(BuildContext context) {
    return _StoreStreamListener<S, ViewModel>(
      store: StoreProvider.of<S>(context),
      builder: builder,
      converter: converter,
      distinct: distinct,
      onInit: onInit,
      onDispose: onDispose,
      rebuildOnChange: rebuildOnChange,
      ignoreChange: ignoreChange,
      onWillChange: onWillChange,
      onDidChange: onDidChange,
      onInitialBuild: onInitialBuild,
    );
  }


}

class _StoreStreamListener<S, ViewModel> extends StatefulWidget {
  final ViewModelBuilder<ViewModel> builder;
  final StoreConverter<S, ViewModel> converter;
  final Store<S> store;
  final bool rebuildOnChange;
  final bool distinct;
  final OnInitCallback<S> onInit;
  final OnDisposeCallback<S> onDispose;
  final IgnoreChangeTest<S> ignoreChange;
  final OnWillChangeCallback<ViewModel> onWillChange;
  final OnDidChangeCallback<ViewModel> onDidChange;
  final OnInitialBuildCallback<ViewModel> onInitialBuild;

  _StoreStreamListener({
    Key key,
    @required this.builder,
    @required this.store,
    @required this.converter,
    this.distinct = false,
    this.onInit,
    this.onDispose,
    this.rebuildOnChange = true,
    this.ignoreChange,
    this.onWillChange,
    this.onDidChange,
    this.onInitialBuild,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StoreStreamListenerState<S, ViewModel>();
  }
}

class _StoreStreamListenerState<S, ViewModel>
    extends State<_StoreStreamListener<S, ViewModel>> {
  Stream<ViewModel> stream;
  ViewModel latestValue;

  @override
  void initState() {
    _init();

    super.initState();
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose(widget.store);
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(_StoreStreamListener<S, ViewModel> oldWidget) {
    if (widget.store != oldWidget.store) {
      _init();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _init() {
    if (widget.onInit != null) {
      widget.onInit(widget.store);
    }

    latestValue = widget.converter(widget.store);

    if (widget.onInitialBuild != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onInitialBuild(latestValue);
      });
    }

    var _stream = widget.store.onChange;

    if (widget.ignoreChange != null) {
      _stream = _stream.where((state) => !widget.ignoreChange(state));
    }

    stream = _stream.map((_) => widget.converter(widget.store));

    // Don't use `Stream.distinct` because it cannot capture the initial
    // ViewModel produced by the `converter`.
    if (widget.distinct) {
      stream = stream.where((vm) {
        final isDistinct = vm != latestValue;

        return isDistinct;
      });
    }

    // After each ViewModel is emitted from the Stream, we update the
    // latestValue. Important: This must be done after all other optional
    // transformations, such as ignoreChange.
    stream =
        stream.transform(StreamTransformer.fromHandlers(handleData: (vm, sink) {
          latestValue = vm;

          if (widget.onWillChange != null) {
            widget.onWillChange(latestValue);
          }

          if (widget.onDidChange != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onDidChange(latestValue);
            });
          }

          sink.add(vm);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return widget.rebuildOnChange
        ? StreamBuilder<ViewModel>(
      stream: stream,
      builder: (context, snapshot) => widget.builder(
        context,
        snapshot.hasData ? snapshot.data : latestValue,
      ),
    )
        : widget.builder(context, latestValue);
  }
  */
}
