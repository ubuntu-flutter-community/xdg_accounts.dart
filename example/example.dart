// ignore_for_file: avoid_print

import 'package:linux_accounts_service/linux_accounts_service.dart';

Future<void> main() async {
  final service = LinuxAccountsService();
  await service.init();
  for (var fu in service.freeDesktopUsers.entries) {
    var username = await fu.value.getUserName();
    var freeDesktopAccountType = await fu.value.getAccountType();
    var uid = await fu.value.getUid();
    print(
      '$username (UID: $uid, Type: ${freeDesktopAccountType.name})',
    );
  }

  await service.dispose();
}
