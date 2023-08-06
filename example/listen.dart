// ignore_for_file: avoid_print, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:xdg_accounts/xdg_accounts.dart';

Future<void> main(List<String> args) async {
  final service = XdgAccounts();
  await service.init();

  final sub = service.usersChanged.listen((event) {
    for (var user in service.xdgUsers) {
      print(user.name);
    }
  });

  String? input = stdin.readLineSync();

  if (input == 'q') {
    sub.cancel;
    await service.dispose();

    exit(0);
  } else {
    print('Renaming was not confirmed!');
  }
}
