// ignore_for_file: non_constant_identifier_names

import 'utils.dart';

class CONSTANT with Mixin {
  String _NAME = '';
  Map<String, CONSTANT> OBJECTS = {};

  CONSTANT(String name, {List<dynamic>? objects}) {
    _NAME = name.toUpperCase();

    objects?.forEach((obj) {
      add(obj);
    });
  }

  void add(dynamic obj) {
    CONSTANT __obj;
    if (obj is String) {
      var _obj = CONSTANT(obj);
      __obj = _obj;
    } else {
      __obj = obj;
    }
    OBJECTS[__obj._NAME] = __obj;
  }

  int get length => OBJECTS.length;

  List<String> get list => OBJECTS.keys.toList();

  @override
  String toString() {
    return _NAME;
  }

  dynamic operator [](dynamic name) {
    if ((name is String) | (name is CONSTANT)) {
      var _name = name.toString().toUpperCase();
      if (_name == 'OBJECTS') {
        return _NAME;
      } else if (OBJECTS.containsKey(_name)) {
        return OBJECTS[_name];
      }
    } else if (name is List) {
      var list = <dynamic>[];

      name.forEach((element) {
        list.add(this[element]);
      });
      return list;
    }
    return;
  }

  @override
  bool operator ==(dynamic other) => other.toString().toUpperCase() == _NAME;

  @override
  int get hashCode => _NAME.hashCode;
}

CONSTANT SOCKET = CONSTANT('SOCKET', objects: ['ALIVE', 'CLOSED', 'RESET']);
CONSTANT ERRORS = CONSTANT('ERRORS', objects: SOCKET[['CLOSED', 'RESET']]);

CONSTANT CHAT = CONSTANT('CHAT', objects: ["AUDIO", "IMAGE", "TEXT", "VIDEO"]);
CONSTANT CALL = CONSTANT("CALL", objects: ["AUDIO", "VIDEO"]);
CONSTANT STATUS = CONSTANT('STATUS', objects: ['ONLINE', 'OFFLINE']);

CONSTANT RESPONSE = CONSTANT('RESPONSE', objects: [
  "ACCEPTED",
  "ADMIN_ONLY",
  "DECLINED",
  "EXIST",
  "EXTINCT",
  "FAILED",
  "FALSE_KEY",
  "LOGIN_FAILED",
  "SIMULTANEOUS_LOGIN",
  "SUCCESSFUL",
]);
CONSTANT ID = CONSTANT('ID', objects: ["CHANNEL_ID", "GROUP_ID", "USER_ID"]);
CONSTANT TYPE =
    CONSTANT('TYPE', objects: ["CHANNEL", "CONTACT", "USER", "GROUP"]);
CONSTANT ACTION = CONSTANT('ACTION', objects: [
  "ADD",
  "ADD_ADMIN",
  "ADD_MEMBER",
  CALL,
  'CALL_REQUEST',
  'CALL_RESPONSE',
  CHAT,
  "CREATE",
  "DELETE",
  "DATA",
  "CHANGE",
  "LOGIN",
  "LOGOUT",
  "ONLY_ADMIN",
  "REMOVE",
  "REMOVE_ADMIN",
  "REMOVE_MEMBER",
  "SIGNUP",
  STATUS,
]);
CONSTANT TAG = CONSTANT('TAG', objects: [
  ACTION,
  "ADMIN",
  "BIO",
  CALL,
  CHAT,
  "CHAT_COLOR",
  "CREATOR",
  "DATA",
  "DATE_TIME",
  "ICON",
  ID,
  "KEY",
  "MOBILE",
  "NAME",
  "RECIPIENT",
  RESPONSE,
  "RESPONSE_TO",
  "SENDER",
  STATUS,
  "TEXT",
  TYPE,
]);
