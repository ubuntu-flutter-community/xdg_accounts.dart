import 'dart:async';

import 'package:dbus/dbus.dart';
import 'package:linux_accounts_service/src/freedesktop_user.dart';

const _kAccountsInterface = 'org.freedesktop.Accounts';
const _kAccountsPath = '/org/freedesktop/Accounts';

class LinuxAccountsService {
  LinuxAccountsService() : _object = _createObject();

  final DBusRemoteObject _object;
  StreamSubscription<DBusPropertiesChangedSignal>? _propertyListener;

  /// User IDs mapped to the [FreeDesktopUser]
  final Map<String, FreeDesktopUser> _freeDesktopUsers = {};
  List<FreeDesktopUser> get freeDesktopUsers =>
      _freeDesktopUsers.entries.map((e) => e.value).toList();

  static DBusRemoteObject _createObject() => DBusRemoteObject(
        DBusClient.system(),
        name: _kAccountsInterface,
        path: DBusObjectPath(_kAccountsPath),
      );

  static FreeDesktopUser _createUserObject(String path) => FreeDesktopUser(
        DBusClient.system(),
        _kAccountsInterface,
        path: DBusObjectPath(path),
      );

  Future<void> init() async {
    await _initDaemonVersion();
    await _initUsers();
    await _initAutomaticLoginUsers();
    await _initHasNoUsers();
    await _initHasMultipleUsers();
    _propertyListener ??= _object.propertiesChanged.listen(_updateProperties);
  }

  Future<void> dispose() async {
    for (var fu in _freeDesktopUsers.entries) {
      await fu.value.dispose();
    }
    await _propertyListener?.cancel();
    await _object.client.close();
    _propertyListener = null;
  }

  void _updateProperties(DBusPropertiesChangedSignal signal) {
    if (signal.userAdded || signal.userDeleted) {
      _object.callListCachedUsers().then(_updateUsers);
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

  List<String>? _users;
  final _userController = StreamController<bool>.broadcast();
  Stream<bool> get usersChanged => _userController.stream;
  Future<void> _initUsers() async {
    _users = await _object.callListCachedUsers();
    if (_users != null) {
      _putNewUsers(_users!);
    }
  }

  void _updateUsers(List<String> value) {
    _users = value;
    _putNewUsers(value);
    _removeOutdatedUsers(value);
    _userController.add(true);
  }

  Future<void> changeUserName({
    required String uid,
    required String newUserName,
  }) async {
    await _freeDesktopUsers[uid]
        ?.callSetUserName(newUserName, allowInteractiveAuthorization: true);
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

  Future<String> findUserById({
    required int id,
  }) async =>
      _object.callFindUserById(id);

  Future<String> findUserByName({
    required String name,
  }) async =>
      _object.callFindUserByName(name);

  Future<void> createUser({
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
  void _putNewUsers(List<String> users) {
    for (var user in users) {
      _freeDesktopUsers.putIfAbsent(
        _userIdFromPath(user),
        () => _createUserObject(user),
      );
    }
  }

  void _removeOutdatedUsers(List<String> users) {
    if (users.length < _freeDesktopUsers.length) {
      for (var fu in _freeDesktopUsers.entries) {
        // TODO
      }
    }
  }

  String _userIdFromPath(String user) =>
      user.replaceAll('$_kAccountsPath/User', '');
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
