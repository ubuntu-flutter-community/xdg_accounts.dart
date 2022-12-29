// ignore_for_file: avoid_print, unused_local_variable

import 'dart:async';

import 'package:linux_accounts_service/xdg_accounts.dart';
import 'package:linux_accounts_service/src/xdg_user.dart';

Future<void> main() async {
  final service = XdgAccounts();
  await service.init();

  await printAllUsers(service.xdgUsers);

  List<StreamSubscription<String>> userNameSubs = [];

  XdgUser? myUser;

  // Process properties in stream subs
  for (var u in service.xdgUsers) {
    // Change to an existing uid - DANGER!!!
    if (u.uid == 1001) {
      myUser = u;
    }
    final sub = u.userNameChanged.listen((userName) async {
      print('USERNAME CHANGED: $userName');
    });
    userNameSubs.add(sub);
  }

  // DANGER DANGER - do not uncomment if you don't know what this does !!!
  // await myUser?.setUserName('myUser', allowInteractiveAuthorization: true);

  for (var sub in userNameSubs) {
    await sub.cancel();
  }
  await service.dispose();
}

Future<void> printAllUsers(List<XdgUser> xdgUsers) async {
  for (var u in xdgUsers) {
    var username = u.userName;
    var accountType = u.accountType;
    var uid = u.uid;
    print(
      '$username (UID: $uid, Type: ${accountType?.name})',
    );
  }
}
