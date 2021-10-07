import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'constants.dart';

void main() {
  final User user1 = User(id: 1, name: 'Tina');
  final User user2 = User(id: 2, name: 'Valentino');
  final User user3 = User(id: 3, name: 'Valentina');

  final User user4 = User(id: 4, name: 'Black', type: 2);
  final User user5 = User(id: 5, name: 'Tina Bae', type: 2);
  final User user6 = User(id: 6, name: 'Nifemi Love', type: 2);

  final User user7 = User(id: 7, name: 'Beau Tina', type: 3);
  final User user8 = User(id: 8, name: 'HB Val', type: 3);
  final User user9 = User(id: 9, name: 'Black Tino', type: 3);

  List<User> _users = [
    user1,
    user2,
    user3,
    user4,
    user5,
    user6,
    user7,
    user8,
    user9
  ];

  final User currentUser =
      User(id: 'prmpsmart', name: 'PRMPSmart Peach', users: _users);

  List<Message> messages = [
    Message(
        sender: user1,
        time: '2: 30 PM',
        text: 'This is user 1, of my first flutter app.',
        sent: true,
        unread: true),
    Message(
        sender: user2,
        time: '2: 40 PM',
        text: 'Hey I\'m user 2, how are you doing?',
        sent: true,
        unread: false),
    Message(
        sender: currentUser,
        time: '3: 00 PM',
        text: 'Love your picture the first time I saw it.',
        sent: false,
        unread: true),
    Message(
        sender: user3,
        time: '3: 10 PM',
        text: 'This is user 1, of my first flutter app.',
        sent: false,
        unread: true),
    Message(
        sender: currentUser,
        time: '3: 30 PM',
        text: 'Hey I\'m user 2, how are you doing?',
        sent: true,
        unread: false),
    Message(
        sender: user2,
        time: '4: 00 PM',
        text: 'I\'m in love wih your picture.',
        sent: true,
        unread: true),
    Message(
        sender: user3,
        time: '4: 30 PM',
        text: 'Hello',
        sent: false,
        unread: true),
    Message(
        sender: currentUser,
        time: '4: 30 PM',
        text: 'Hello',
        sent: false,
        unread: true),
    Message(
        sender: user1,
        time: '4: 30 PM',
        text: '''Hello guys and thanks for downloading this Mod for GTAV 
This MOD Has been tested on a gtx 950 and an i3 6100 cpu and has provided locked 60 Fps on the following in Game Settings (Screenshot Proivided) and LA REVO 2.0 Installed

Requirements : a PC that can run GTA V
               Reshade Installed with Sweet FX Effects installed

Installation : Copy all the files to GTA V Directory and paste, Press F12 Ingame and Select ARCADE from the Preset List.

Do Subscribe my YT Channel if you liked this Mod for gta V and this modification was created because my PC Could not run NVE OR Redux and it was not able to meet my 
expectations as a result i created this mod which i think looks Great, Let me know if you like it too in the comments section Below XD''',
        sent: false,
        unread: true),
    Message(
        sender: currentUser,
        time: '5: 00 PM',
        text: 'How are you doing?',
        sent: true,
        unread: false),
    Message(
        sender: user1,
        time: '4: 30 PM',
        text: 'This is user 1, of my first flutter app.',
        sent: false,
        unread: true),
    Message(
        sender: currentUser,
        time: '5: 00 PM',
        text: 'Hey I\'m user 2, how are you doing?',
        sent: true,
        unread: false),
    Message(
        sender: user1,
        time: '4: 30 PM',
        text: 'Miracle Peter',
        sent: false,
        type: 'image',
        data: 'I love you!',
        unread: true),
    Message(
        sender: currentUser,
        time: '5: 00 PM',
        text: 'Miracy Petey',
        sent: true,
        data: 'I love you!',
        type: 'image',
        unread: false),
    Message(
        sender: user3,
        time: '5: 30 PM',
        text:
            'I\'m new here, but I fell in love wih your picture the first time I saw it.',
        sent: true,
        unread: true),
    Message(
        sender: currentUser,
        time: '5: 30 PM',
        text: 'I\'m new here.',
        sent: true,
        unread: true),
    Message(
        sender: user2,
        time: '5: 30 PM',
        text: 'I fell in love wih your picture the first time I saw it.',
        sent: true,
        unread: true),
    Message(
        sender: currentUser,
        time: '5: 30 PM',
        text: 'First Audio sent.',
        sent: true,
        data: 'I love you!',
        type: 'audio',
        unread: true),
    Message(
        sender: user2,
        time: '5: 30 PM',
        text: 'First Audio sent first time I saw it.',
        data: 'I love you!',
        type: 'audio',
        sent: true,
        unread: true),
  ];

  _users.forEach((element) {
    element.messages = messages;
  });

  runApp(
    MyApp(currentUser),
  );
}

class MyApp extends StatelessWidget {
  final User user;
  MyApp(this.user);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peachy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: materialColor('#d85461'),
        accentColor: Color(0xFFFEF9EB),
      ),
      home: Home(user),
    );
  }
}
