// This file was generated using the following command and may be overwritten.
// dart-dbus generate-remote-object /usr/share/dbus-1/interfaces/org.freedesktop.Accounts.User.xml

import 'package:dbus/dbus.dart';

/// Signal data for org.freedesktop.Accounts.User.Changed.
class OrgFreedesktopAccountsUserChanged extends DBusSignal {
  OrgFreedesktopAccountsUserChanged(DBusSignal signal)
      : super(
            sender: signal.sender,
            path: signal.path,
            interface: signal.interface,
            name: signal.name,
            values: signal.values,);
}

class OrgFreedesktopAccountsUser extends DBusRemoteObject {
  /// Stream of org.freedesktop.Accounts.User.Changed signals.
  late final Stream<OrgFreedesktopAccountsUserChanged> changed;

  OrgFreedesktopAccountsUser(
    DBusClient client,
    String destination, {
    DBusObjectPath path = const DBusObjectPath.unchecked('/'),
  }) : super(client, name: destination, path: path) {
    changed = DBusRemoteObjectSignalStream(
            object: this,
            interface: 'org.freedesktop.Accounts.User',
            name: 'Changed',
            signature: DBusSignature(''),)
        .asBroadcastStream()
        .map((signal) => OrgFreedesktopAccountsUserChanged(signal));
  }

  /// Gets org.freedesktop.Accounts.User.Uid
  Future<int> getUid() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'Uid',
        signature: DBusSignature('t'),);
    return value.asUint64();
  }

  /// Gets org.freedesktop.Accounts.User.UserName
  Future<String> getUserName() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'UserName',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.RealName
  Future<String> getRealName() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'RealName',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.AccountType
  Future<int> getAccountType() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'AccountType',
        signature: DBusSignature('i'),);
    return value.asInt32();
  }

  /// Gets org.freedesktop.Accounts.User.HomeDirectory
  Future<String> getHomeDirectory() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'HomeDirectory',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.Shell
  Future<String> getShell() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'Shell',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.Email
  Future<String> getEmail() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'Email',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.Language
  Future<String> getLanguage() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'Language',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.Session
  Future<String> getSession() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'Session',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.SessionType
  Future<String> getSessionType() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'SessionType',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.FormatsLocale
  Future<String> getFormatsLocale() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'FormatsLocale',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.InputSources
  Future<List<Map<String, String>>> getInputSources() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'InputSources',
        signature: DBusSignature('aa{ss}'),);
    return value
        .asArray()
        .map((child) => child
            .asDict()
            .map((key, value) => MapEntry(key.asString(), value.asString())),)
        .toList();
  }

  /// Gets org.freedesktop.Accounts.User.XSession
  Future<String> getXSession() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'XSession',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.Location
  Future<String> getLocation() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'Location',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.LoginFrequency
  Future<int> getLoginFrequency() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'LoginFrequency',
        signature: DBusSignature('t'),);
    return value.asUint64();
  }

  /// Gets org.freedesktop.Accounts.User.LoginTime
  Future<int> getLoginTime() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'LoginTime',
        signature: DBusSignature('x'),);
    return value.asInt64();
  }

  /// Gets org.freedesktop.Accounts.User.LoginHistory
  // Future<List<DBusStruct>> getLoginHistory() async {
  //   var value = await getProperty(
  //       'org.freedesktop.Accounts.User', 'LoginHistory',
  //       signature: DBusSignature('a(xxa{sv})'));
  //   return value.asArray().map((child) => child.asStruct()).toList();
  // }

  /// Gets org.freedesktop.Accounts.User.XHasMessages
  Future<bool> getXHasMessages() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'XHasMessages',
        signature: DBusSignature('b'),);
    return value.asBoolean();
  }

  /// Gets org.freedesktop.Accounts.User.XKeyboardLayouts
  Future<List<String>> getXKeyboardLayouts() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'XKeyboardLayouts',
        signature: DBusSignature('as'),);
    return value.asStringArray().toList();
  }

  /// Gets org.freedesktop.Accounts.User.BackgroundFile
  Future<String> getBackgroundFile() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'BackgroundFile',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.IconFile
  Future<String> getIconFile() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'IconFile',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.Saved
  Future<bool> getSaved() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'Saved',
        signature: DBusSignature('b'),);
    return value.asBoolean();
  }

  /// Gets org.freedesktop.Accounts.User.Locked
  Future<bool> getLocked() async {
    var value = await getProperty('org.freedesktop.Accounts.User', 'Locked',
        signature: DBusSignature('b'),);
    return value.asBoolean();
  }

  /// Gets org.freedesktop.Accounts.User.PasswordMode
  Future<int> getPasswordMode() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'PasswordMode',
        signature: DBusSignature('i'),);
    return value.asInt32();
  }

  /// Gets org.freedesktop.Accounts.User.PasswordHint
  Future<String> getPasswordHint() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'PasswordHint',
        signature: DBusSignature('s'),);
    return value.asString();
  }

  /// Gets org.freedesktop.Accounts.User.AutomaticLogin
  Future<bool> getAutomaticLogin() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'AutomaticLogin',
        signature: DBusSignature('b'),);
    return value.asBoolean();
  }

  /// Gets org.freedesktop.Accounts.User.SystemAccount
  Future<bool> getSystemAccount() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'SystemAccount',
        signature: DBusSignature('b'),);
    return value.asBoolean();
  }

  /// Gets org.freedesktop.Accounts.User.LocalAccount
  Future<bool> getLocalAccount() async {
    var value = await getProperty(
        'org.freedesktop.Accounts.User', 'LocalAccount',
        signature: DBusSignature('b'),);
    return value.asBoolean();
  }

  /// Invokes org.freedesktop.Accounts.User.SetUserName()
  Future<void> callSetUserName(String name,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User', 'SetUserName', [DBusString(name)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetRealName()
  Future<void> callSetRealName(String name,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User', 'SetRealName', [DBusString(name)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetEmail()
  Future<void> callSetEmail(String email,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User', 'SetEmail', [DBusString(email)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetLanguage()
  Future<void> callSetLanguage(String language,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User', 'SetLanguage', [DBusString(language)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetFormatsLocale()
  Future<void> callSetFormatsLocale(String formatsLocale,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod('org.freedesktop.Accounts.User', 'SetFormatsLocale',
        [DBusString(formatsLocale)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetInputSources()
  Future<void> callSetInputSources(List<Map<String, String>> sources,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User',
        'SetInputSources',
        [
          DBusArray(
              DBusSignature('a{ss}'),
              sources.map((child) => DBusDict(
                  DBusSignature('s'),
                  DBusSignature('s'),
                  child.map((key, value) =>
                      MapEntry(DBusString(key), DBusString(value)),),),),)
        ],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetXSession()
  Future<void> callSetXSession(String xSession,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User', 'SetXSession', [DBusString(xSession)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetSession()
  Future<void> callSetSession(String session,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User', 'SetSession', [DBusString(session)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetSessionType()
  Future<void> callSetSessionType(String sessionType,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod('org.freedesktop.Accounts.User', 'SetSessionType',
        [DBusString(sessionType)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetLocation()
  Future<void> callSetLocation(String location,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User', 'SetLocation', [DBusString(location)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetHomeDirectory()
  Future<void> callSetHomeDirectory(String homedir,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod('org.freedesktop.Accounts.User', 'SetHomeDirectory',
        [DBusString(homedir)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetShell()
  Future<void> callSetShell(String shell,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User', 'SetShell', [DBusString(shell)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetXHasMessages()
  Future<void> callSetXHasMessages(bool hasMessages,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod('org.freedesktop.Accounts.User', 'SetXHasMessages',
        [DBusBoolean(hasMessages)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetXKeyboardLayouts()
  Future<void> callSetXKeyboardLayouts(List<String> layouts,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod('org.freedesktop.Accounts.User', 'SetXKeyboardLayouts',
        [DBusArray.string(layouts)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetBackgroundFile()
  Future<void> callSetBackgroundFile(String filename,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod('org.freedesktop.Accounts.User', 'SetBackgroundFile',
        [DBusString(filename)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetIconFile()
  Future<void> callSetIconFile(String filename,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User', 'SetIconFile', [DBusString(filename)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetLocked()
  Future<void> callSetLocked(bool locked,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User', 'SetLocked', [DBusBoolean(locked)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetAccountType()
  Future<void> callSetAccountType(int accountType,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod('org.freedesktop.Accounts.User', 'SetAccountType',
        [DBusInt32(accountType)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetPasswordMode()
  Future<void> callSetPasswordMode(int mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User', 'SetPasswordMode', [DBusInt32(mode)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetPassword()
  Future<void> callSetPassword(String password, String hint,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod('org.freedesktop.Accounts.User', 'SetPassword',
        [DBusString(password), DBusString(hint)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetPasswordHint()
  Future<void> callSetPasswordHint(String hint,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod(
        'org.freedesktop.Accounts.User', 'SetPasswordHint', [DBusString(hint)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.SetAutomaticLogin()
  Future<void> callSetAutomaticLogin(bool enabled,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    await callMethod('org.freedesktop.Accounts.User', 'SetAutomaticLogin',
        [DBusBoolean(enabled)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
  }

  /// Invokes org.freedesktop.Accounts.User.GetPasswordExpirationPolicy()
  Future<List<DBusValue>> callGetPasswordExpirationPolicy(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false,}) async {
    var result = await callMethod(
        'org.freedesktop.Accounts.User', 'GetPasswordExpirationPolicy', [],
        replySignature: DBusSignature('xxxxxx'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,);
    return result.returnValues;
  }
}
