import 'package:flutter/material.dart';

class User {
  var id;
  String name;
  String icon;
  int type = 1;
  List<Message> msgs;
  List<User> users;

  User(
      {this.id,
      this.name,
      this.icon = '',
      this.type = 1,
      this.msgs,
      this.users});

  set messages(List<Message> messages) => msgs = messages;
  List<Message> get messages => msgs;
}

class Message {
  final User sender;
  final String time;
  final String data;
  final String text;
  final bool sent;
  final bool unread;
  String type;

  Message({
    this.sender,
    this.time,
    this.text,
    this.sent,
    this.unread,
    this.type = 'text',
    this.data = '',
  });
}

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);

int hex2int(String hexcode) {
  String color = '0xFF' + hexcode;
  color = color.replaceAll('#', '');
  return int.parse(color);
}

Color colorHex(String hexcode) {
  int color = hex2int(hexcode);
  return Color(color);
}

MaterialColor materialColor(String hexcode) {
  Color color = colorHex(hexcode);
  Map<int, Color> map_color = {
    50: color.withOpacity(.1),
    100: color.withOpacity(.2),
    200: color.withOpacity(.3),
    300: color.withOpacity(.4),
    400: color.withOpacity(.5),
    500: color.withOpacity(.6),
    600: color.withOpacity(.7),
    700: color.withOpacity(.8),
    800: color.withOpacity(.9),
    900: color.withOpacity(1),
  };
  return MaterialColor(hex2int(hexcode), map_color);
}
