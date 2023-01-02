// ignore_for_file: avoid_print, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:xdg_accounts/xdg_accounts.dart';

import 'list_users.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty || int.tryParse(args.first) == null) {
    print(
      'No UID or no valid UID was entered, please provide a valid UID as the first argument!\nIf you want to check the uid of a user, enter "id USERNAME" with a username you know into the terminal.\nExiting!',
    );
    exit(0);
  } else {
    int uid = int.tryParse(args.first)!;
    final service = XdgAccounts();
    // Inits the [XdgAccounts] do not forget to dispose to release the DBus objects created within!
    await service.init();

    XdgUser? myUser;

    // Listen to property changes in stream subscriptions
    // do not forget to cancel them!
    StreamSubscription<String>? myUsernameSub;
    for (var u in service.xdgUsers) {
      if (u.uid == uid) {
        myUser = u;
      }
    }
    myUsernameSub = myUser?.userNameChanged.listen((userName) async {
      print('USERNAME CHANGED: $userName');
    });

    print('');
    printAllUsers(service.xdgUsers);
    print(
      '''\nDANGER: the next step will rename the user ${myUser?.userName} with the UID $uid you have entered,\nif you are ABSOLUTELY sure that you want to change the username of UID $uid enter y''',
    );

    String? input = stdin.readLineSync();

    if (input == 'y') {
      print('Enter a new username for UID $uid :');

      String? newUserName = stdin.readLineSync();
      if (newUserName != null &&
          newUserName.isNotEmpty &&
          newUserName.length > 1) {
        await myUser?.setUserName(
          newUserName,
          allowInteractiveAuthorization: true,
        );
      }
    } else {
      print('Renaming was not confirmed!');
    }

    await Future.delayed(Duration(seconds: 5));
    print(
      'Canceling stream subscriptions, disposing the service and exiting ...',
    );

    await myUsernameSub?.cancel();
    await service.dispose();
  }
}
