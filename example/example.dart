// ignore_for_file: avoid_print

import 'dart:async';

import 'package:linux_accounts_service/linux_accounts_service.dart';
import 'package:linux_accounts_service/src/freedesktop_user.dart';

Future<void> main() async {
  final service = LinuxAccountsService();
  await service.init();

  await printAllUsers(service.freeDesktopUsers);

  List<StreamSubscription<String>> userNameSubs = [];

  // Process properties in stream subs
  for (var fu in service.freeDesktopUsers) {
    final sub = fu.userNameChanged.listen((userName) async {
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

Future<void> printAllUsers(List<FreeDesktopUser> freeDesktopUsers) async {
  for (var fu in freeDesktopUsers) {
    var username = await fu.getUserName();
    var freeDesktopAccountType = await fu.getAccountType();
    var uid = await fu.getUid();
    print(
      '$username (UID: $uid, Type: ${freeDesktopAccountType.name})',
    );
  }
}
