import 'dart:async';

import 'package:dbus/dbus.dart';
import 'package:xdg_accounts/src/xdg_user.dart';

const _kAccountsInterface = 'org.freedesktop.Accounts';
const _kAccountsPath = '/org/freedesktop/Accounts';

class XdgAccounts {
  XdgAccounts() : _object = _createObject();

  final DBusRemoteObject _object;
  StreamSubscription<DBusPropertiesChangedSignal>? _propertyListener;

  /// User paths mapped to the [XdgUser]
  final Map<String, XdgUser> _xdgUsers = {};
  List<XdgUser> get xdgUsers => _xdgUsers.entries.map((e) => e.value).toList();

  static DBusRemoteObject _createObject() => DBusRemoteObject(
        DBusClient.system(),
        name: _kAccountsInterface,
        path: DBusObjectPath(_kAccountsPath),
      );

  static XdgUser _createUserObject(String path) => XdgUser(
        DBusClient.system(),
        _kAccountsInterface,
        path: DBusObjectPath(path),
      );

  Future<void> init() async {
    await _initDaemonVersion();

    await _initUserPaths();
    await _initFreeDesktopUsers();

    await _initAutomaticLoginUsers();
    await _initHasNoUsers();
    await _initHasMultipleUsers();
    _propertyListener ??= _object.propertiesChanged.listen(_updateProperties);
  }

  Future<void> dispose() async {
    for (var u in _xdgUsers.entries) {
      await u.value.dispose();
    }
    await _propertyListener?.cancel();
    await _object.client.close();
    _propertyListener = null;
  }

  void _updateProperties(DBusPropertiesChangedSignal signal) {
    if (signal.userAdded || signal.userDeleted) {
      _object.callListCachedUsers().then(_updateUserPaths);
    }
    if (signal.daemonVersionChanged) {
      _object.getDaemonVersion().then(_updateDaemonVersion);
    }
    if (signal.automaticLoginUsersChanged) {
      _object.getAutomaticLoginUsers().then(_updateAutomaticLoginUsers);
    }
    if (signal.hasNoUsersChanged) {
      _object.getHasNoUsers().then(_updateHasNoUsers);
    }
    if (signal.hasMultipleUsersChanged) {
      _object.getHasMultipleUsers().then(_updateHasMultipleUsers);
    }
  }

  List<String>? _userPaths;
  final _usersController = StreamController<bool>.broadcast();
  Stream<bool> get usersChanged => _usersController.stream;
  Future<void> _initUserPaths() async {
    _userPaths = await _object.callListCachedUsers();
    if (_userPaths != null) {
      _putNewUsers(_userPaths!);
    }
  }

  Future<void> _initFreeDesktopUsers() async {
    for (var u in xdgUsers) {
      await u.init();
    }
  }

  void _updateUserPaths(List<String> value) {
    _userPaths = value;
    _putNewUsers(value);
    _removeOutdatedUsers(value);
    _usersController.add(true);
  }

  Future<String> getDaemonVersion() async => _object.getDaemonVersion();
  String? lastDaemonVersion;
  final _daemonVersionController = StreamController<String>.broadcast();
  Stream<String> get daemonVersion => _daemonVersionController.stream;
  Future<void> _initDaemonVersion() async =>
      lastDaemonVersion = await getDaemonVersion();
  void _updateDaemonVersion(String value) {
    lastDaemonVersion = value;
    _daemonVersionController.add(value);
  }

  List<String>? automaticLoginUsers;
  final _automaticLoginUsersController =
      StreamController<List<String>>.broadcast();
  Stream<List<String>> get automaticLoginUsersStream =>
      _automaticLoginUsersController.stream;
  Future<void> _initAutomaticLoginUsers() async =>
      automaticLoginUsers = await _object.getAutomaticLoginUsers();
  void _updateAutomaticLoginUsers(List<String> value) {
    automaticLoginUsers = value;
    _automaticLoginUsersController.add(value);
  }

  // HasNoUsers
  bool? hasNoUsers;
  final _hasNoUsersController = StreamController<bool>.broadcast();
  Stream<bool> get hasNoUsersStream => _hasNoUsersController.stream;
  Future<void> _initHasNoUsers() async =>
      hasNoUsers = await _object.getHasNoUsers();
  void _updateHasNoUsers(bool value) {
    hasNoUsers = value;
    _hasNoUsersController.add(value);
  }

  // HasMultipleUsers
  bool? hasMultipleUsers;
  final _hasMultipleUsersController = StreamController<bool>.broadcast();
  Stream<bool> get hasMultipleUsersStream => _hasMultipleUsersController.stream;
  Future<void> _initHasMultipleUsers() async =>
      hasMultipleUsers = await _object.getHasMultipleUsers();
  void _updateHasMultipleUsers(bool value) {
    hasMultipleUsers = value;
    _hasMultipleUsersController.add(value);
  }

  XdgUser? findUserByPath(String path) => _xdgUsers[path];

  Future<String> findUserById({
    required int id,
  }) async =>
      _object.callFindUserById(id);

  Future<String> findUserByName({
    required String name,
  }) async =>
      _object.callFindUserByName(name);

  Future<String> createUser({
    required String name,
    required String fullname,
    required int accountType,
  }) async =>
      await _object.callCreateUser(name, fullname, accountType);

  Future<String> cacheUser({required String name}) async =>
      _object.callCacheUser(name);

  Future<void> unCacheUser({required String name}) async =>
      _object.callUncacheUser(name);

  Future<void> deleteUser({required int id, required bool removeFiles}) async =>
      _object.callDeleteUser(id, removeFiles);

  // Helper methods
  void _putNewUsers(List<String> userPaths) {
    for (var path in userPaths) {
      _xdgUsers.putIfAbsent(
        path,
        () => _createUserObject(path),
      );
    }
  }

  void _removeOutdatedUsers(List<String> userPaths) {
    if (userPaths.length < _xdgUsers.length) {
      final outDatedUsers = userPaths;
      for (var u in _xdgUsers.entries) {
        for (var user in userPaths) {
          if (u.key == user) {
            outDatedUsers.remove(user);
            break;
          }
        }
      }
      for (var oU in outDatedUsers) {
        _xdgUsers.remove(oU);
      }
    }
  }
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

  bool get daemonVersionChanged =>
      changedProperties.containsKey('DaemonVersion');

  bool get automaticLoginUsersChanged =>
      changedProperties.containsKey('AutomaticLoginUsers');

  bool get hasNoUsersChanged => changedProperties.containsKey('HasNoUsers');

  bool get hasMultipleUsersChanged =>
      changedProperties.containsKey('HasMultipleUsers');
}
