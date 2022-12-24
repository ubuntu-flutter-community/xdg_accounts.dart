import 'package:linux_accounts_service/linux_accounts_service.dart';

Future<void> main() async {
  final service = LinuxAccountsService();
  final userIds = await service.listCachedUserIds();
  for (var id in userIds) {
    final user = await service.findUserById(id);
    print(user);
  }
  await service.dispose();
}
