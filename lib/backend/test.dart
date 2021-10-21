import 'dart:async';

import 'client.dart';

Future<void> main(List<String> args) async {
  var user = User('ade1', name: 'Apata', key: 'ade1');
  print(user);
  var con = await Client(
    'localhost',
    7767,
    user: user,
    statusWatcher: (value) => print(value),
  ).login();
  Timer(Duration(seconds: 2), () => print(user.status));
  Timer(Duration(seconds: 4),
      () => user.contacts.objects.forEach((element) => print(element.status)));
}
