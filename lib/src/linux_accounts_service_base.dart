import 'dart:async';

import 'package:dbus/dbus.dart';

class LinuxAccountsService {
  final DBusRemoteObject _object;
  final List<DBusRemoteObject> _userObjects = [];
  StreamSubscription<DBusPropertiesChangedSignal>? _propertyListener;

  LinuxAccountsService() : _object = _createObject();

  static DBusRemoteObject _createObject() => DBusRemoteObject(
        DBusClient.system(),
        name: 'org.freedesktop.Accounts',
        path: DBusObjectPath('/org/freedesktop/Accounts'),
      );

  static DBusRemoteObject _createUserObject(String path) => DBusRemoteObject(
        DBusClient.system(),
        name: 'org.freedesktop.Accounts',
        path: DBusObjectPath(path),
      );

  Future<void> init() async {
    // init all stuff
    _propertyListener ??= _object.propertiesChanged.listen(_updateProperties);
  }

  Future<void> dispose() async {
    await _propertyListener?.cancel();
    await _object.client.close();
    _propertyListener = null;
  }

  void _updateProperties(DBusPropertiesChangedSignal signal) {
    if (signal.userAdded) {
      _object.callListCachedUsers().then(_updateUsers);
    }
  }

  void _updateUsers(List<String> value) {
    if (value.isEmpty) return;
    // _userExtensionsEnabled = value;
    // if (!_userExtensionsEnabledController.isClosed) {
    //   _userExtensionsEnabledController.add(_userExtensionsEnabled);
    // }
  }

  Future<List<int>> listCachedUserIds() async {
    final idStrings = await _object.callListCachedUsers();
    final ids = <int>[];
    for (var element in idStrings) {
      final idString = element.replaceAll('/org/freedesktop/Accounts/User', '');
      final parsedInt = int.parse(idString);
      ids.add(parsedInt);
    }
    return ids;
  }

  Future<List<String>> listCachedUserPaths() async =>
      await _object.callListCachedUsers();

  Future<String> findUserById(int id) async => _object.callFindUserById(id);

  Future<String> findUserByName(String name) async =>
      _object.callFindUserByName(name);

  void createUser({
    required String name,
    required String fullname,
    required int accountType,
  }) =>
      _object.callCreateUser(name, fullname, accountType);
}

extension _AccountsRemoteObject on DBusRemoteObject {
  /// Gets org.freedesktop.Accounts.DaemonVersion
  Future<String> getDaemonVersion() async {
    var value = await getProperty(
      'org.freedesktop.Accounts',
      'DaemonVersion',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.HasNoUsers
  Future<bool> getHasNoUsers() async {
    var value = await getProperty(
      'org.freedesktop.Accounts',
      'HasNoUsers',
      signature: DBusSignature('b'),
    );
    return value.asBoolean();
  }

  /// Gets org.freedesktop.Accounts.HasMultipleUsers
  Future<bool> getHasMultipleUsers() async {
    var value = await getProperty(
      'org.freedesktop.Accounts',
      'HasMultipleUsers',
      signature: DBusSignature('b'),
    );
    return value.asBoolean();
  }

  /// Gets org.freedesktop.Accounts.AutomaticLoginUsers
  Future<List<String>> getAutomaticLoginUsers() async {
    var value = await getProperty(
      'org.freedesktop.Accounts',
      'AutomaticLoginUsers',
      signature: DBusSignature('ao'),
    );
    return value
        .asObjectPathArray()
        .map((e) => e.asString())
        .toList(); // Changed
  }

  /// Invokes org.freedesktop.Accounts.ListCachedUsers()
  Future<List<String>> callListCachedUsers({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      'org.freedesktop.Accounts',
      'ListCachedUsers',
      [],
      replySignature: DBusSignature('ao'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0]
        .asArray()
        .map((e) => e.asString())
        .toList(); // changed
  }

  /// Invokes org.freedesktop.Accounts.FindUserById()
  Future<String> callFindUserById(
    int id, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      'org.freedesktop.Accounts',
      'FindUserById',
      [DBusInt64(id)],
      replySignature: DBusSignature('o'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString(); // changed
  }

  /// Invokes org.freedesktop.Accounts.FindUserByName()
  Future<String> callFindUserByName(
    String name, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      'org.freedesktop.Accounts',
      'FindUserByName',
      [DBusString(name)],
      replySignature: DBusSignature('o'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString(); // changed
  }

  /// Invokes org.freedesktop.Accounts.CreateUser()
  Future<String> callCreateUser(
    String name,
    String fullname,
    int accountType, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      'org.freedesktop.Accounts',
      'CreateUser',
      [DBusString(name), DBusString(fullname), DBusInt32(accountType)],
      replySignature: DBusSignature('o'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString(); // changed
  }

  /// Invokes org.freedesktop.Accounts.CacheUser()
  Future<String> callCacheUser(
    String name, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      'org.freedesktop.Accounts',
      'CacheUser',
      [DBusString(name)],
      replySignature: DBusSignature('o'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString(); // changed
  }

  /// Invokes org.freedesktop.Accounts.UncacheUser()
  Future<void> callUncacheUser(
    String name, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts',
      'UncacheUser',
      [DBusString(name)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.DeleteUser()
  Future<void> callDeleteUser(
    int id,
    bool removeFiles, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts',
      'DeleteUser',
      [DBusInt64(id), DBusBoolean(removeFiles)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }
}

extension _ChangedAccounts on DBusPropertiesChangedSignal {
  bool get userAdded => changedProperties.containsKey('UserAdded');

  bool get userDeleted => changedProperties.containsKey('UserDeleted');
}
