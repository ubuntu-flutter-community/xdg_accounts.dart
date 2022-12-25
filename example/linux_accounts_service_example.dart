// ignore_for_file: avoid_print

import 'package:linux_accounts_service/linux_accounts_service.dart';

Future<void> main() async {
  final service = LinuxAccountsService();
  await service.init();
  final userIds = service.users;
  for (var id in userIds ?? []) {
    print(id);
  }
  await service.dispose();
}
