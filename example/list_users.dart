// ignore_for_file: avoid_print

import 'package:xdg_accounts/xdg_accounts.dart';

void main(List<String> args) async {
  final service = XdgAccounts();
  await service.init();

  printAllUsers(service.xdgUsers);

  await service.dispose();
}

void printAllUsers(List<XdgUser> xdgUsers) {
  print('Current users are:');
  for (var u in xdgUsers) {
    var username = u.userName;
    var accountType = u.accountType;
    var uid = u.uid;
    print(
      '$username (UID: $uid, Type: ${accountType?.name})',
    );
  }
}
