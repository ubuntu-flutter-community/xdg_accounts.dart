import 'dart:async';

import 'package:dbus/dbus.dart';

enum XdgAccountType {
  user,
  admin;
}

class XdgUserChangedSignal extends DBusSignal {
  XdgUserChangedSignal(DBusSignal signal)
      : super(
          sender: signal.sender,
          path: signal.path,
          interface: signal.interface,
          name: signal.name,
          values: signal.values,
        );
}

extension _XdgUserPropertiesChangedSignal on DBusPropertiesChangedSignal {
  bool get userNameChanged => changedProperties.containsKey('UserName');
  bool get realNameChanged => changedProperties.containsKey('RealName');
  bool get accountTypeChanged => changedProperties.containsKey('AccountType');
  bool get homeDirChanged => changedProperties.containsKey('HomeDirectory');
  bool get shellChanged => changedProperties.containsKey('Shell');
  bool get emailChanged => changedProperties.containsKey('Email');
  bool get languageChanged => changedProperties.containsKey('Language');
  bool get sessionChanged => changedProperties.containsKey('Session');
  bool get sessionTypeChanged => changedProperties.containsKey('SessionType');
  bool get formatsLocaleChanged =>
      changedProperties.containsKey('FormatsLocale');
  bool get inputSourcesChanged => changedProperties.containsKey('InputSources');
  bool get xSessionChanged => changedProperties.containsKey('XSession');
  bool get locationChanged => changedProperties.containsKey('Location');
  bool get loginFrequencyChanged =>
      changedProperties.containsKey('LoginFrequency');
  bool get loginTimeChanged => changedProperties.containsKey('LoginTime');
  bool get xHasMessagesChanged => changedProperties.containsKey('XHasMessages');
  bool get xKeyboardLayoutsChanged =>
      changedProperties.containsKey('XKeyboardLayouts');
  bool get backgroundFileChanged =>
      changedProperties.containsKey('BackgroundFile');
  bool get iconFileChanged => changedProperties.containsKey('IconFile');
  bool get savedChanged => changedProperties.containsKey('Saved');
  bool get lockedChanged => changedProperties.containsKey('Locked');
  bool get passwordModeChanged => changedProperties.containsKey('PasswordMode');
  bool get passwordHintChanged => changedProperties.containsKey('PasswordHint');
  bool get automaticLoginChanged =>
      changedProperties.containsKey('AutomaticLogin');
  bool get systemAccountChanged =>
      changedProperties.containsKey('SystemAccount');
  bool get localAccountChanged => changedProperties.containsKey('LocalAccount');
}

class XdgUser extends DBusRemoteObject {
  XdgUser(
    DBusClient client,
    String destination, {
    DBusObjectPath path = const DBusObjectPath.unchecked('/'),
  }) : super(client, name: destination, path: path) {
    changed = DBusRemoteObjectSignalStream(
      object: this,
      interface: 'org.freedesktop.Accounts.User',
      name: 'Changed',
      signature: DBusSignature(''),
    ).asBroadcastStream().map((signal) => XdgUserChangedSignal(signal));
  }

  StreamSubscription<DBusPropertiesChangedSignal>? _propertyListener;
  late final Stream<XdgUserChangedSignal> changed;

  Future<void> init() async {
    _uid = await getUid();
    _userName = await getUserName();
    _realName = await getRealName();
    _accountType = await getAccountType();
    _homeDir = await getHomeDirectory();
    _shell = await getShell();
    _email = await getEmail();
    _language = await getLanguage();
    _session = await getSession();
    _sessionType = await getSessionType();
    _formatsLocale = await getFormatsLocale();
    _inputSources = await getInputSources();
    _xSession = await getXSession();
    _location = await getLocation();
    _loginFrequency = await getLoginFrequency();
    _loginTime = await getLoginTime();
    _xHasMessages = await getXHasMessages();
    _xKeyboardLayouts = await getXKeyboardLayouts();
    _backgroundFile = await getBackgroundFile();
    _saved = await getSaved();
    _locked = await getLocked();
    _passwordMode = await getPasswordMode();
    _passwordHint = await getPasswordHint();
    _automaticLogin = await getAutomaticLogin();
    _systemAccount = await getSystemAccount();
    _localAccount = await getLocalAccount();
    _propertyListener ??= propertiesChanged.listen(_updateProperties);
  }

  void _updateProperties(DBusPropertiesChangedSignal signal) {
    if (signal.userNameChanged) {
      getUserName().then(_updateUserName);
    }
    if (signal.realNameChanged) {
      getRealName().then(_updateRealName);
    }
    if (signal.accountTypeChanged) {
      getAccountType().then(_updateAccountType);
    }
    if (signal.homeDirChanged) {
      getHomeDirectory().then(_updateHomeDir);
    }
    if (signal.shellChanged) {
      getShell().then(_updateShell);
    }
    if (signal.emailChanged) {
      getEmail().then(_updateEmail);
    }
    if (signal.languageChanged) {
      getLanguage().then(_updateLanguage);
    }
    if (signal.sessionChanged) {
      getSession().then(_updateSession);
    }
    if (signal.sessionTypeChanged) {
      getSessionType().then(_updateSessionType);
    }
    if (signal.formatsLocaleChanged) {
      getFormatsLocale().then(_updateFormatsLocale);
    }
    if (signal.inputSourcesChanged) {
      getInputSources().then(_updateInputSources);
    }
    if (signal.xSessionChanged) {
      getXSession().then(_updateXSession);
    }
    if (signal.locationChanged) {
      getLocation().then(_updateLocation);
    }
    if (signal.loginFrequencyChanged) {
      getLoginFrequency().then(_updateLoginFrequency);
    }
    if (signal.loginTimeChanged) {
      getLoginTime().then(_updateLoginTime);
    }
    if (signal.xHasMessagesChanged) {
      getXHasMessages().then(_updateXHasMessages);
    }
    if (signal.xKeyboardLayoutsChanged) {
      getXKeyboardLayouts().then(_updateXKeyboardLayouts);
    }
    if (signal.backgroundFileChanged) {
      getBackgroundFile().then(_updateBackgroundFile);
    }
    if (signal.iconFileChanged) {
      getIconFile().then(_updateIconFile);
    }

    if (signal.savedChanged) {
      getSaved().then(_updateSaved);
    }
    if (signal.lockedChanged) {
      getLocked().then(_updateLocked);
    }
    if (signal.passwordModeChanged) {
      getPasswordMode().then(_updatePasswordMode);
    }
    if (signal.passwordHintChanged) {
      getPasswordHint().then(_updatePasswordHint);
    }
    if (signal.automaticLoginChanged) {
      getAutomaticLogin().then(_updateAutomaticLogin);
    }
    if (signal.systemAccountChanged) {
      getSystemAccount().then(_updateSystemAccount);
    }
    if (signal.localAccountChanged) {
      getLocalAccount().then(_updateLocalAccount);
    }
  }

  Future<void> dispose() async {
    await _propertyListener?.cancel();
    _propertyListener = null;
    await client.close();
  }

  // Uid
  int? _uid;
  int? get uid => _uid;

  /// Gets org.freedesktop.Accounts.User.Uid
  Future<int> getUid() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'Uid',
      signature: DBusSignature('t'),
    );
    return value.asUint64();
  }

  // UserName
  final _userNameChangedController = StreamController<String>.broadcast();
  Stream<String> get userNameChanged => _userNameChangedController.stream;
  String? _userName;
  String? get userName => _userName;
  void _updateUserName(String? value) {
    if (value == null) return;
    _userName = value;
    _userNameChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.UserName
  Future<String> getUserName() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'UserName',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // RealName
  final _realNameChangedController = StreamController<String>.broadcast();
  Stream<String> get realNameChanged => _realNameChangedController.stream;
  String? _realName;
  String? get realName => _realName;
  void _updateRealName(String? value) {
    if (value == null) return;
    _realName = value;
    _realNameChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.RealName
  Future<String> getRealName() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'RealName',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // AccountType
  final _accountTypeChangedController =
      StreamController<XdgAccountType>.broadcast();
  Stream<XdgAccountType> get accountTypeChanged =>
      _accountTypeChangedController.stream;
  XdgAccountType? _accountType;
  XdgAccountType? get accountType => _accountType;
  void _updateAccountType(XdgAccountType? value) {
    if (value == null) return;
    _accountType = value;
    _accountTypeChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.AccountType
  Future<XdgAccountType> getAccountType() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'AccountType',
      signature: DBusSignature('i'),
    );
    return value.asInt32() == 0 ? XdgAccountType.user : XdgAccountType.admin;
  }

  // HomeDirectory
  final _homeDirChangedController = StreamController<String>.broadcast();
  Stream<String> get homeDirChanged => _homeDirChangedController.stream;
  String? _homeDir;
  String? get homeDir => _homeDir;
  void _updateHomeDir(String? value) {
    if (value == null) return;
    _homeDir = value;
    _homeDirChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.HomeDirectory
  Future<String> getHomeDirectory() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'HomeDirectory',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // Shell
  final _shellChangedController = StreamController<String>.broadcast();
  Stream<String> get shellChanged => _shellChangedController.stream;
  String? _shell;
  String? get shell => _shell;
  void _updateShell(String? value) {
    if (value == null) return;
    _shell = value;
    _shellChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.Shell
  Future<String> getShell() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'Shell',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // Email
  final _emailChangedController = StreamController<String>.broadcast();
  Stream<String> get emailChanged => _emailChangedController.stream;
  String? _email;
  String? get email => _email;
  void _updateEmail(String? value) {
    if (value == null) return;
    _email = value;
    _emailChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.Email
  Future<String> getEmail() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'Email',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // Language
  final _languageChangedController = StreamController<String>.broadcast();
  Stream<String> get languageChanged => _languageChangedController.stream;
  String? _language;
  String? get language => _language;
  void _updateLanguage(String? value) {
    if (value == null) return;
    _language = value;
    _languageChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.Language
  Future<String> getLanguage() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'Language',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // Session
  final _sessionChangedController = StreamController<String>.broadcast();
  Stream<String> get sessionChanged => _sessionChangedController.stream;
  String? _session;
  String? get session => _session;
  void _updateSession(String? value) {
    if (value == null) return;
    _session = value;
    _sessionChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.Session
  Future<String> getSession() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'Session',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // SessionType
  final _sessionTypeChangedController = StreamController<String>.broadcast();
  Stream<String> get sessionTypeChanged => _sessionTypeChangedController.stream;
  String? _sessionType;
  String? get sessionType => _sessionType;
  void _updateSessionType(String? value) {
    if (value == null) return;
    _sessionType = value;
    _sessionTypeChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.SessionType
  Future<String> getSessionType() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'SessionType',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // FormatsLocale
  final _formatsLocaleChangedController = StreamController<String>.broadcast();
  Stream<String> get formatsLocaleChanged =>
      _formatsLocaleChangedController.stream;
  String? _formatsLocale;
  String? get formatsLocale => _formatsLocale;
  void _updateFormatsLocale(String? value) {
    if (value == null) return;
    _formatsLocale = value;
    _formatsLocaleChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.FormatsLocale
  Future<String> getFormatsLocale() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'FormatsLocale',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // InputSources
  final _inputSourcesChangedController =
      StreamController<List<Map<String, String>>>.broadcast();
  Stream<List<Map<String, String>>> get inputSourcesChanged =>
      _inputSourcesChangedController.stream;
  List<Map<String, String>>? _inputSources;
  List<Map<String, String>>? get inputSources => _inputSources;
  void _updateInputSources(List<Map<String, String>>? value) {
    if (value == null) return;
    _inputSources = value;
    _inputSourcesChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.InputSources
  Future<List<Map<String, String>>> getInputSources() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'InputSources',
      signature: DBusSignature('aa{ss}'),
    );
    return value
        .asArray()
        .map(
          (child) => child
              .asDict()
              .map((key, value) => MapEntry(key.asString(), value.asString())),
        )
        .toList();
  }

  // XSession
  final _xSessionChangedController = StreamController<String>.broadcast();
  Stream<String> get xSessionChanged => _xSessionChangedController.stream;
  String? _xSession;
  String? get xSession => _xSession;
  void _updateXSession(String? value) {
    if (value == null) return;
    _xSession = value;
    _xSessionChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.XSession
  Future<String> getXSession() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'XSession',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // Location
  final _locationChangedController = StreamController<String>.broadcast();
  Stream<String> get locationChanged => _locationChangedController.stream;
  String? _location;
  String? get location => _location;
  void _updateLocation(String? value) {
    if (value == null) return;
    _location = value;
    _locationChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.Location
  Future<String> getLocation() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'Location',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // LoginFrequency
  final _loginFrequencyChangedController = StreamController<int>.broadcast();
  Stream<int> get loginFrequencyChanged =>
      _loginFrequencyChangedController.stream;
  int? _loginFrequency;
  int? get loginFrequency => _loginFrequency;
  void _updateLoginFrequency(int? value) {
    if (value == null) return;
    _loginFrequency = value;
    _loginFrequencyChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.LoginFrequency
  Future<int> getLoginFrequency() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'LoginFrequency',
      signature: DBusSignature('t'),
    );
    return value.asUint64();
  }

  // LoginTime
  final _loginTimeChangedController = StreamController<int>.broadcast();
  Stream<int> get loginTimeChanged => _loginTimeChangedController.stream;
  int? _loginTime;
  int? get loginTime => _loginTime;
  void _updateLoginTime(int? value) {
    if (value == null) return;
    _loginTime = value;
    _loginTimeChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.LoginTime
  Future<int> getLoginTime() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'LoginTime',
      signature: DBusSignature('x'),
    );
    return value.asInt64();
  }

  /// Gets org.freedesktop.Accounts.User.LoginHistory
  // Future<List<DBusStruct>> getLoginHistory() async {
  //   var value = await getProperty(
  //       'org.freedesktop.Accounts.User', 'LoginHistory',
  //       signature: DBusSignature('a(xxa{sv})'));
  //   return value.asArray().map((child) => child.asStruct()).toList();
  // }

  // XHasMessages
  final _xHasMessagesChangedController = StreamController<bool>.broadcast();
  Stream<bool> get xHasMessagesChanged => _xHasMessagesChangedController.stream;
  bool? _xHasMessages;
  bool? get xHasMessages => _xHasMessages;
  void _updateXHasMessages(bool? value) {
    if (value == null) return;
    _xHasMessages = value;
    _xHasMessagesChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.XHasMessages
  Future<bool> getXHasMessages() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'XHasMessages',
      signature: DBusSignature('b'),
    );
    return value.asBoolean();
  }

  // XKeyboardLayouts
  final _xKeyboardLayoutsChangedController =
      StreamController<List<String>>.broadcast();
  Stream<List<String>> get xKeyboardLayoutsChanged =>
      _xKeyboardLayoutsChangedController.stream;
  List<String>? _xKeyboardLayouts;
  List<String>? get xKeyboardLayouts => _xKeyboardLayouts;
  void _updateXKeyboardLayouts(List<String>? value) {
    if (value == null) return;
    _xKeyboardLayouts = value;
    _xKeyboardLayoutsChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.XKeyboardLayouts
  Future<List<String>> getXKeyboardLayouts() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'XKeyboardLayouts',
      signature: DBusSignature('as'),
    );
    return value.asStringArray().toList();
  }

  // BackgroundFile
  final _backgroundFileChangedController = StreamController<String>.broadcast();
  Stream<String> get backgroundFileChanged =>
      _backgroundFileChangedController.stream;
  String? _backgroundFile;
  String? get backgroundFile => _backgroundFile;
  void _updateBackgroundFile(String? value) {
    if (value == null) return;
    _backgroundFile = value;
    _backgroundFileChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.BackgroundFile
  Future<String> getBackgroundFile() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'BackgroundFile',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // IconFile
  final _iconFileChangedController = StreamController<String>.broadcast();
  Stream<String> get iconFileChanged => _iconFileChangedController.stream;
  String? _iconFile;
  String? get iconFile => _iconFile;
  void _updateIconFile(String? value) {
    if (value == null) return;
    _iconFile = value;
    _iconFileChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.IconFile
  Future<String> getIconFile() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'IconFile',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // Saved
  final _savedChangedController = StreamController<bool>.broadcast();
  Stream<bool> get savedChanged => _savedChangedController.stream;
  bool? _saved;
  bool? get saved => _saved;
  void _updateSaved(bool? value) {
    if (value == null) return;
    _saved = value;
    _savedChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.Saved
  Future<bool> getSaved() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'Saved',
      signature: DBusSignature('b'),
    );
    return value.asBoolean();
  }

  // Locked
  final _lockedChangedController = StreamController<bool>.broadcast();
  Stream<bool> get lockedChanged => _lockedChangedController.stream;
  bool? _locked;
  bool? get locked => _locked;
  void _updateLocked(bool? value) {
    if (value == null) return;
    _locked = value;
    _lockedChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.Locked
  Future<bool> getLocked() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'Locked',
      signature: DBusSignature('b'),
    );
    return value.asBoolean();
  }

  // PasswordMode
  final _passwordModeChangedController = StreamController<int>.broadcast();
  Stream<int> get passwordModeChanged => _passwordModeChangedController.stream;
  int? _passwordMode;
  int? get passwordMode => _passwordMode;
  void _updatePasswordMode(int? value) {
    if (value == null) return;
    _passwordMode = value;
    _passwordModeChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.PasswordMode
  Future<int> getPasswordMode() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'PasswordMode',
      signature: DBusSignature('i'),
    );
    return value.asInt32();
  }

  // PasswordHint
  final _passwordHintChangedController = StreamController<String>.broadcast();
  Stream<String> get passwordHintChanged =>
      _passwordHintChangedController.stream;
  String? _passwordHint;
  String? get passwordHint => _passwordHint;
  void _updatePasswordHint(String? value) {
    if (value == null) return;
    _passwordHint = value;
    _passwordHintChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.PasswordHint
  Future<String> getPasswordHint() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'PasswordHint',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  // AutomaticLogin
  final _automaticLoginChangedController = StreamController<bool>.broadcast();
  Stream<bool> get automaticLoginChanged =>
      _automaticLoginChangedController.stream;
  bool? _automaticLogin;
  bool? get automaticLogin => _automaticLogin;
  void _updateAutomaticLogin(bool? value) {
    if (value == null) return;
    _automaticLogin = value;
    _automaticLoginChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.AutomaticLogin
  Future<bool> getAutomaticLogin() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'AutomaticLogin',
      signature: DBusSignature('b'),
    );
    return value.asBoolean();
  }

  // SystemAccount
  final _systemAccountChangedController = StreamController<bool>.broadcast();
  Stream<bool> get systemAccountChanged =>
      _systemAccountChangedController.stream;
  bool? _systemAccount;
  bool? get systemAccount => _systemAccount;
  void _updateSystemAccount(bool? value) {
    if (value == null) return;
    _systemAccount = value;
    _systemAccountChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.SystemAccount
  Future<bool> getSystemAccount() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'SystemAccount',
      signature: DBusSignature('b'),
    );
    return value.asBoolean();
  }

  final _localAccountChangedController = StreamController<bool>.broadcast();
  Stream<bool> get localAccountChanged => _localAccountChangedController.stream;
  bool? _localAccount;
  bool? get localAccount => _localAccount;
  void _updateLocalAccount(bool? value) {
    if (value == null) return;
    _localAccount = value;
    _localAccountChangedController.add(value);
  }

  /// Gets org.freedesktop.Accounts.User.LocalAccount
  Future<bool> getLocalAccount() async {
    var value = await getProperty(
      'org.freedesktop.Accounts.User',
      'LocalAccount',
      signature: DBusSignature('b'),
    );
    return value.asBoolean();
  }

  /// Invokes org.freedesktop.Accounts.User.SetUserName()
  Future<void> setUserName(
    String name, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetUserName',
      [DBusString(name)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetRealName()
  Future<void> setRealName(
    String name, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetRealName',
      [DBusString(name)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetEmail()
  Future<void> setEmail(
    String email, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetEmail',
      [DBusString(email)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetLanguage()
  Future<void> setLanguage(
    String language, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetLanguage',
      [DBusString(language)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetFormatsLocale()
  Future<void> setFormatsLocale(
    String formatsLocale, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetFormatsLocale',
      [DBusString(formatsLocale)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetInputSources()
  Future<void> setInputSources(
    List<Map<String, String>> sources, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetInputSources',
      [
        DBusArray(
          DBusSignature('a{ss}'),
          sources.map(
            (child) => DBusDict(
              DBusSignature('s'),
              DBusSignature('s'),
              child.map(
                (key, value) => MapEntry(DBusString(key), DBusString(value)),
              ),
            ),
          ),
        )
      ],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetXSession()
  Future<void> setXSession(
    String xSession, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetXSession',
      [DBusString(xSession)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetSession()
  Future<void> setSession(
    String session, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetSession',
      [DBusString(session)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetSessionType()
  Future<void> setSessionType(
    String sessionType, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetSessionType',
      [DBusString(sessionType)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetLocation()
  Future<void> setLocation(
    String location, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetLocation',
      [DBusString(location)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetHomeDirectory()
  Future<void> setHomeDirectory(
    String homedir, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetHomeDirectory',
      [DBusString(homedir)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetShell()
  Future<void> setShell(
    String shell, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetShell',
      [DBusString(shell)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetXHasMessages()
  Future<void> setXHasMessages(
    bool hasMessages, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetXHasMessages',
      [DBusBoolean(hasMessages)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetXKeyboardLayouts()
  Future<void> setXKeyboardLayouts(
    List<String> layouts, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetXKeyboardLayouts',
      [DBusArray.string(layouts)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetBackgroundFile()
  Future<void> setBackgroundFile(
    String filename, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetBackgroundFile',
      [DBusString(filename)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetIconFile()
  Future<void> setIconFile(
    String filename, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetIconFile',
      [DBusString(filename)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetLocked()
  Future<void> setLocked(
    bool locked, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetLocked',
      [DBusBoolean(locked)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetAccountType()
  Future<void> setAccountType(
    int accountType, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetAccountType',
      [DBusInt32(accountType)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetPasswordMode()
  Future<void> setPasswordMode(
    int mode, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetPasswordMode',
      [DBusInt32(mode)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetPassword()
  Future<void> setPassword(
    String password,
    String hint, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetPassword',
      [DBusString(password), DBusString(hint)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetPasswordHint()
  Future<void> setPasswordHint(
    String hint, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetPasswordHint',
      [DBusString(hint)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.SetAutomaticLogin()
  Future<void> setAutomaticLogin(
    bool enabled, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'org.freedesktop.Accounts.User',
      'SetAutomaticLogin',
      [DBusBoolean(enabled)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.Accounts.User.GetPasswordExpirationPolicy()
  Future<List<DBusValue>> callGetPasswordExpirationPolicy({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      'org.freedesktop.Accounts.User',
      'GetPasswordExpirationPolicy',
      [],
      replySignature: DBusSignature('xxxxxx'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues;
  }
}
