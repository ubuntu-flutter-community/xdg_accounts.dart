// ignore_for_file: avoid_print

import 'dart:async';

import 'package:linux_accounts_service/linux_accounts_service.dart';
import 'package:linux_accounts_service/src/xdg_user.dart';

Future<void> main() async {
  final service = LinuxAccountsService();
  await service.init();

  await printAllUsers(service.xdgUsers);

  List<StreamSubscription<String>> userNameSubs = [];

  // Process properties in stream subs
  for (var u in service.xdgUsers) {
    final sub = u.userNameChanged.listen((userName) async {
      print('USERNAME CHANGED: $userName');
    });
    userNameSubs.add(sub);
  }

  // Change to an existing uid - DANGER!!!
  // await service.changeUserName(uid: '1001', newUserName: 'willy');

  for (var sub in userNameSubs) {
    await sub.cancel();
  }
  await service.dispose();
}

Future<void> printAllUsers(List<XdgUser> xdgUsers) async {
  for (var u in xdgUsers) {
    var username = await u.getUserName();
    var accountType = await u.getAccountType();
    var uid = await u.getUid();
    print(
      '$username (UID: $uid, Type: ${accountType.name})',
    );
  }
}
