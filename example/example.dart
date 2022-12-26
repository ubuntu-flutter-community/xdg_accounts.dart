// ignore_for_file: avoid_print

import 'package:linux_accounts_service/linux_accounts_service.dart';

Future<void> main() async {
  final service = LinuxAccountsService();
  await service.init();

  await printAllUsers(service);

  // Change to an existing uid
  // await service.changeUserName(uid: '1001', newUserName: 'anewname');
  // await printAllUsers(service);

  await service.dispose();
}

Future<void> printAllUsers(LinuxAccountsService service) async {
  for (var fu in service.freeDesktopUsers) {
    var username = await fu.getUserName();
    var freeDesktopAccountType = await fu.getAccountType();
    var uid = await fu.getUid();
    print(
      '$username (UID: $uid, Type: ${freeDesktopAccountType.name})',
    );
  }
}
