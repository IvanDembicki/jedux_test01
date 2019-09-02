import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:recase/recase.dart';

import 'jedux.dart';

/// Представляет состояние узла данных в иерархии состояний.
/// Дерево состояний формируется из данных [JeduxData],
/// каждый узел состояния инициирует себя и создает
/// дочерние узлы с помощью [JeduxHoldersFactory],
/// и далее рекурсивно до самого нижнего уровня.
///
/// Класс предоставляет возможность доступа к другим состояниям
/// в иерархии, позволяет ими манипулировать — открывать, добавлять и удалять.
///
/// Если были вызваны методы [setProperty] или он информирует зависимый [JeduxHolderProvider] о том,
/// что произошли изменения.

abstract class JeduxHolder with _Notifier {
  static const String _TRUE = "true";
  static const String _FALSE = "false";

  static Map<String, dynamic> _buildersMap;

  static JeduxHolder create(Map<String, dynamic> jeduxData, Map<String, dynamic> buildersMap) {
    _buildersMap = buildersMap;
    final isChanged = _JeduxChecker.checkJeduxData(jeduxData);
    if (isChanged) return null;
    return _create(jeduxData, null);
  }

  static JeduxHolder _create(Map data, JeduxHolder parent) {
    final String type = data[JeduxDataFormat.TYPE] as String;
    final JeduxHolder Function(Map, JeduxHolder) builder = _buildersMap[type];
    return builder(data, parent);
  }

  static final _idMap = Map<String, JeduxHolder>();

  static reset() {
    _idMap.clear();
  }

  final Map<String, String> _props = Map<String, String>();
  final List<JeduxHolder> _children = List<JeduxHolder>();

  String _nodeType;
  JeduxHolder _parent;

  JeduxHolder(Map data, JeduxHolder parent) {
    _initInstance(data, parent);
  }

  //// =========== DESERIALIZATION =========== ////

  void _initInstance(Map data, JeduxHolder parent) {
    _parent = parent;
    _nodeType = data[JeduxDataFormat.TYPE];
    print("$tabs $depth $_nodeType");
    _createProps(data);
    // print("$_tabs \t props: $_props");
    _createChildren(data);
  }

  _createProps(Map data) {
    final Map propsMap = data[JeduxDataFormat.PROPS];
    if (propsMap == null) return;
    propsMap.forEach((key, value) => _props[key] = value);
    opened = getProperty(JeduxDataFormat.OPENED) == _TRUE;
    _registerID();
  }

  _createChildren(Map data) {
    final childrenList = data[JeduxDataFormat.CHILDREN] as List<dynamic>;
    if (childrenList == null || childrenList.length == 0) return;
    for (int i = 0; i < childrenList.length; i++) {
      _children.add(_create(childrenList[i], this));
    }
  }

  _removeID() {
    final id = _props[JeduxDataFormat.ID];
    if (id == null) return;
    _idMap.remove(id);
  }

  _registerID() {
    final id = _props[JeduxDataFormat.ID];
    if (id == null || id.length == 0) return;
    final registeredHolder = _idMap[id];
    if (registeredHolder != null) print("***ERROR*** [JeduxHolder].setID([$id]) \n\t\terror: id is not unique");
    _idMap[id] = this;
  }

  //// =========== SERIALIZATION =========== ////

  Map<dynamic, dynamic> toMap({bool stringMap = true}) {
    Map<dynamic, dynamic> map = {};
    if (stringMap) {
      map[JeduxDataFormat.TYPE] = _nodeType.toString();
    } else {
      map[JeduxDataFormat.TYPE] = _nodeType;
    }
    map[JeduxDataFormat.PROPS] = _props;
    map[JeduxDataFormat.PROPS][JeduxDataFormat.PATH] = path;
    map[JeduxDataFormat.PROPS][JeduxDataFormat.DEPTH] = depth.toString();

    final List<Map> childrenList = _childrenToList();
    if (childrenList.length > 0) {
      map[JeduxDataFormat.CHILDREN] = childrenList;
    }
    return map;
  }

  List<Map> _childrenToList() {
    final result = List<Map>();
    for (int i = 0; i < _children.length; i++) {
      result.add(_children[i].toMap());
    }
    return result;
  }

  @override
  String toString() {
    String result = json
        .encode(toMap())
        .replaceAll('}', ",}")
        .replaceAll("\"${JeduxDataFormat.TYPE}\"", "DataFormat.TYPE")
        .replaceAll("\"${JeduxDataFormat.PROPS}\"", "DataFormat.PROPS")
        .replaceAll("\"${JeduxDataFormat.CHILDREN}\"", "DataFormat.CHILDREN")
        .replaceAll("\"${JeduxDataFormat.PATH}\"", "DataFormat.PATH")
        .replaceAll("\"${JeduxDataFormat.OPENED}\"", "DataFormat.OPENED")
        .replaceAll("\"${JeduxDataFormat.DEPTH}\"", "DataFormat.DEPTH")
        .replaceAllMapped(RegExp('\"NodeTypes\.\?\\w\+\"'), _removeQuotesForTypes);
    return result;
  }

  String _removeQuotesForTypes(Match match) => match.input.substring(match.start + 1, match.end - 1);

  //// =========== HIERARCHY =========== ////

  JeduxHolder get root => _parent == null ? this : _parent.root;

  JeduxHolder get parent => _parent;

  JeduxHolder getAncestorByType(Type type) => runtimeType == type ? this : _parent?.getAncestorByType(type);

  JeduxHolder getAncestorByNodeType(String type) => _nodeType == type ? this : _parent?.getAncestorByNodeType(type);

  JeduxHolder get firstChild => getChildAt(0);

  JeduxHolder get prevSibling => _parent?.getChildAt(_parent.indexOf(this) - 1);

  JeduxHolder get nextSibling => _parent?.getChildAt(_parent.indexOf(this) + 1);

  JeduxHolder get nextCycled => nextSibling ?? parent.firstChild;

  JeduxHolder get lastChild => getChildAt(_children.length - 1);

  int indexOf(JeduxHolder jeduxHolder) => _children.indexOf(jeduxHolder);

  JeduxHolder getChildAt(int index) => (index < 0 || index >= _children.length) ? null : _children[index];

  JeduxHolder getChildByType(Type type) {
    for (int i = 0; i < _children.length; i++) {
      if (_children[i].runtimeType == type) return _children[i];
    }
    return null;
  }

  JeduxHolder getChildByNodeType(String type) {
    for (int i = 0; i < _children.length; i++) {
      if (_children[i]._nodeType == type) return _children[i];
    }
    return null;
  }

  JeduxHolder getChildById(String id) {
    return _idMap[id];
  }

  List<JeduxHolder> descendants(Type type) {
    final result = List<JeduxHolder>();
    _collectDescendants(type, this, result);
    return result;
  }

  void _collectDescendants(Type type, JeduxHolder jeduxHolder, List<JeduxHolder> result) {
    if (jeduxHolder.runtimeType == type) result.add(jeduxHolder);
    final children = jeduxHolder._children;
    children.forEach((JeduxHolder child) => _collectDescendants(type, child, result));
  }

  //// =========== HIERARCHY CHANGE =========== ////

  JeduxHolder addChild(JeduxHolder jeduxHolder) {
    return addChildAt(_children.length, jeduxHolder);
  }

  JeduxHolder addChildAt(int index, JeduxHolder jeduxHolder) {
    _children.insert(index, jeduxHolder);
    jeduxHolder._parent = this;
    jeduxHolder._registerID();
    root.notify(NotifyType.STRUCTURE_CHANGED);
    return jeduxHolder;
  }

  JeduxHolder removeChildAt(int index) {
    final JeduxHolder jeduxHolder = _children[index];
    if (jeduxHolder == null) return null;
    _children.removeAt(index);
    jeduxHolder._parent = null;
    jeduxHolder._removeID();
    root.notify(NotifyType.STRUCTURE_CHANGED);
    return jeduxHolder;
  }

  JeduxHolder remove() {
    var parent = _parent;
    if (parent == null) return this;
    return parent.removeChildAt(parent.indexOf(this));
  }

  //// =========== OPENED =========== ////

  /// Открывает всю иерархию от текущего узла вверх до root
  void openHierarchy() {
    opened = true;
    _parent?.openHierarchy();
  }

  JeduxHolder initOpenedChild({int byPosition, Type byType, String byNodeType, bool notifyListeners = false}) {
    if (_children.length == 0) return null;

    if (byPosition != null) {
      _openedChild = getChildAt(byPosition);
    } else if (byType != null) {
      _openedChild = getChildByType(byType);
    } else if (byNodeType != null) {
      _openedChild = getChildByNodeType(byNodeType);
    } else {
      _openedChild = getChildAt(0);
    }
    _openedChild.setProperty(JeduxDataFormat.OPENED, "true", notifyListeners: notifyListeners);
    return _openedChild;
  }

  JeduxHolder _openedChild;

  JeduxHolder get openedChild {
    return _openedChild;
  }

  set openedChild(JeduxHolder child) {
    if (_openedChild == child) return;
    if (_openedChild != null) {
      _openedChild.setProperty(JeduxDataFormat.OPENED, _FALSE, notifyListeners: false);
    }
    _openedChild = child;
    if (_openedChild == null) return;
    _openedChild.setProperty(JeduxDataFormat.OPENED, _TRUE, notifyListeners: true);
  }

  bool get opened => _parent == null ? true : _parent._openedChild == this;

  set opened(bool value) {
    if (_parent == null) return;
    if (value) {
      _parent.openedChild = this;
    } else if (_parent.openedChild == this) {
      _parent.openedChild = null;
    }
  }

  //// =========== PROPERTIES =========== ////

  String get path {
    if (_parent == null) return "/";
    return "${_parent.path}$_nodeType[${_parent.indexOf(this)}]/";
  }

  String get nodeType => _nodeType;

  String get tabs => (_parent?.tabs ?? "") + "\t";

  int get depth => (_parent?.depth ?? -1) + 1;

  void setProperty(String name, String value, {bool notifyListeners = true}) {
    _props[name] = value;
    if (notifyListeners) root.notify(NotifyType.PROPERTY_CHANGED);
  }

  String getProperty(String name) => _props[name];
}

typedef void StateHolderHandler<NotifyType>(NotifyType type);

enum NotifyType {
  PROPERTY_CHANGED,
  STRUCTURE_CHANGED,
}

/// Добавляет функциональность уведомления слушателей о произошедших событиях.
mixin _Notifier {
  final List<StateHolderHandler> _propertyListeners = List<StateHolderHandler>();
  final List<StateHolderHandler> _structureListeners = List<StateHolderHandler>();

  /// Добавляет слушателя уведомлений
  void addListener(NotifyType type, StateHolderHandler handler) {
    removeListener(type, handler);
    final listenersList = _getListeners(type);
    listenersList.add(handler);
  }

  /// Удаляет слушателя уведомлений
  void removeListener(NotifyType type, StateHolderHandler handler) {
    final listenersList = _getListeners(type);
    final handlerIndex = listenersList.indexOf(handler);
    if (handlerIndex < 0) return;
    listenersList.removeAt(handlerIndex);
  }

  /// Уведомляет слушателей указанного типа о событии.
  void notify(NotifyType type) {
    final List<StateHolderHandler> listeners = _getListeners(type);
    for (int i = 0; i < listeners.length; i++) {
      final handler = listeners[i];
      if (handler != null) handler(type);
    }
  }

  List<StateHolderHandler> _getListeners(NotifyType type) {
    switch (type) {
      case NotifyType.PROPERTY_CHANGED:
        return _propertyListeners;
        break;
      case NotifyType.STRUCTURE_CHANGED:
        return _structureListeners;
        break;
    }
    return null;
  }
}

/// Класс [_JeduxChecker] нужен для того, чтобы:
/// * проверить данные описания структуры приложения,
/// * сгенерировать необходимые константы,
/// * сгенерировать ссылки на билдеры,
/// * сгенерировать шаблоны классов model и view.
///
/// Всё это помещается в Clipboard, и далее может быть
/// помещено в пустой файл и использовано для создания кода.

class _JeduxChecker {
  static bool checkJeduxData(
    Map data, {
    List<String> builders,
    List<String> holders,
    List<String> constants,
    List<String> views,
  }) {
    final isRoot = builders == null;
    if (isRoot) {
      builders = List<String>();
      builders.add("""// ===== Add this lines to 'jedux_data/jedux_builders.dart map =====
      class JeduxBuilders {
          static final Map<String, JeduxHolder Function(Map, JeduxHolder)> map = {
          // yes, here
          };
      }
      """);

      constants = List<String>();
      constants.add("\n\n// ===== Add this lines to 'jedux_data/jedux_const.dart' ===== \n\n");
      holders = List<String>();
      holders.add("\n\n// ===== Add this classes to 'jedux_holders' folder ===== \n\n");
      views = List<String>();
      views.add("\n\n// ===== Add this classes to 'views' folder ===== \n\n");
    }

    final type = data[JeduxDataFormat.TYPE];
    bool result = false;

    final builder = JeduxHolder._buildersMap[type];
    if (builder == null) {
      result = true;

      final holderName = "${type}Holder";
      final constantName = new ReCase(type).constantCase;
      final fileName = new ReCase(holderName).snakeCase;
      final gettersList = _getGettersList(data[JeduxDataFormat.PROPS], constants);

      builders.add(getBuilder(constantName, holderName));
      constants.add(getConstant(constantName, type, "_HOLDER"));
      holders.add(getHolder(fileName, holderName, gettersList.join("\n")));
      views.add(getView(data));
    }

    result = _checkChildren(data, builders, holders, constants, views) || result;

    if (isRoot) {
      constants = removeDuplicates(constants);
      constants.sort();
      Clipboard.setData(ClipboardData(text: _getClipboardString(constants, holders, builders, views)));
      print("\n  [Jedux] — Jedux application structure was changed. New entries added to clipboard.");
    }

    return result;
  }

  static bool _checkChildren(
    Map data,
    List<String> mapEntryList,
    List<String> classEntryList,
    List<String> constEntryList,
    List<String> viewsEntryList,
  ) {
    final childrenList = data[JeduxDataFormat.CHILDREN] as List<dynamic>;
    bool result = false;
    if (childrenList == null || childrenList.length == 0) return result;
    for (int i = 0; i < childrenList.length; i++) {
      result = checkJeduxData(
            childrenList[i],
            builders: mapEntryList,
            holders: classEntryList,
            constants: constEntryList,
            views: viewsEntryList,
          ) ||
          result;
    }
    return result;
  }

  static List<String> _getGettersList(Map<String, String> data, List<String> constEntryList) {
    final result = List<String>();
    if (data == null) return result;
    data.forEach((String key, String value) {
      result.add(_getPropertyEntry(key, constEntryList));
    });
    return result;
  }

  static String getHolder(String fileName, String className, String gettersList) {
    return """
// $fileName.dart
import '../jedux_data/jedux_const.dart';
import '../jedux/jedux.dart';

class $className extends JeduxHolder {
  static $className build(Map data, JeduxHolder parent) {
    return $className(data, parent);
  }
  
  $className(Map data, JeduxHolder parent) : super(data, parent);
  $gettersList
}
""";
  }

  static String _getPropertyEntry(String key, List<String> constEntryList) {
    final constName = ReCase(key).constantCase;
    constEntryList.add(getConstant(constName, key, ""));
    return """
    String get $key => getProperty(JeduxConst.$constName);
    set $key(String value) => setProperty(JeduxConst.$constName, value);
    """;
  }

  static String getConstant(String constantName, String constValue, String postfix) {
    return "static const $constantName$postfix = \"$constValue\";";
  }

  static String getBuilder(String constantName, String className) {
    return "\nJeduxConst.${constantName}_HOLDER: $className.build,";
  }

  static String _getClipboardString(
    List<String> constants,
    List<String> holders,
    List<String> builders,
    List<String> views,
  ) {
    return "${constants.join("\n")}\n\n${holders.join("\n\n")}\n\n${builders.join("\n")}\n\n${views.join("\n")}";
  }

  static String getView(Map data) {
    final children = data[JeduxDataFormat.CHILDREN];
    if (children == null) return "";
    if (children == null || children.length == 0) return getSimpleView(data);
    return getComplexView(data);
  }

  static String getSimpleView(Map data) {
    final type = data[JeduxDataFormat.TYPE];
    final holderName = "${type}Holder";
    final viewName = "${type}View";
    final viewFileName = new ReCase(viewName).snakeCase;
    final holderFileName = new ReCase(holderName).snakeCase;

    return """
// views/$viewFileName.dart

import 'package:flutter/material.dart';
import '../jedux/jedux.dart';
import '../jedux_holders/$holderFileName.dart';

class $viewName extends JeduxListener {
  $holderName get _holder => jeduxHolder as $holderName;

  $viewName(JeduxHolder stateHolder, {Key key}) : super(stateHolder, key: key);

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
    """;
  }

  static String getComplexView(Map data) {
    final type = data[JeduxDataFormat.TYPE];
    final holderName = "${type}Holder";
    final viewName = "${type}View";
    final holderFileName = new ReCase(holderName).snakeCase;
    final viewFileName = new ReCase(viewName).snakeCase;

    return """
// $viewFileName.dart
import 'package:flutter/material.dart';
import '../jedux/jedux.dart';
import '../jedux_holders/$holderFileName.dart';

${getChildHoldersImports(data)}
${getChildViewsImports(data)}

class $viewName extends JeduxListener {
  $holderName get _holder => jeduxHolder as $holderName;

  $viewName(JeduxHolder stateHolder, {Key key}) : super(stateHolder, key: key);

  @override
  Widget build(BuildContext context) {
    return _getOpenedChildView(jeduxHolder.openedChild);
  }

  JeduxListener _getOpenedChildView(JeduxHolder openedHolder) {
    openedHolder = openedHolder ?? jeduxHolder.initOpenedChild(byPosition: 0);
    switch (openedHolder.runtimeType) {
    ${getChildSwitches(data)}
    }
    print("***ERROR*** [$viewName]._getOpenedChildView([\${openedHolder.runtimeType}])");
    return null;
  }

}

""";
  }

  static String getChildHoldersImports(Map data) {
    final children = data[JeduxDataFormat.CHILDREN] as List<Map>;
    final result = List<String>();
    children.forEach((Map child) {
      final type = child[JeduxDataFormat.TYPE];
      final holderName = "${type}Holder";
      final holderFileName = new ReCase(holderName).snakeCase;
      final entry = "import '../jedux_holders/$holderFileName.dart';";
      result.add(entry);
    });
    return result.join("\n");
  }

  static String getChildViewsImports(Map data) {
    final children = data[JeduxDataFormat.CHILDREN] as List<Map>;
    final result = List<String>();
    children.forEach((Map child) {
      final type = child[JeduxDataFormat.TYPE];
      final viewName = "${type}View";
      final viewFileName = new ReCase(viewName).snakeCase;
      final entry = "import '$viewFileName.dart';";
      result.add(entry);
    });
    return result.join("\n");
  }

  static String getChildSwitches(Map data) {
    final children = data[JeduxDataFormat.CHILDREN] as List<Map>;

    final result = List<String>();
    children.forEach((Map child) {
      final type = child[JeduxDataFormat.TYPE];
      final holderName = "${type}Holder";
      final viewName = "${type}View";
      final entry = """case $holderName:
      return $viewName(openedHolder);""";
      result.add(entry);
    });
    return result.join("\n");
  }

  static List<String> removeDuplicates(List<String> constEntryList) {
    final uniques = Map<String, bool>();
    for (int i = 0; i < constEntryList.length; i++) {
      uniques[constEntryList[i]] = true;
    }
    final result = List<String>();
    uniques.forEach((String key, bool value) {
      result.add(key);
    });
    return result;
  }
}
