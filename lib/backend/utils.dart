// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';

import 'multi_users.dart';
import 'dart:collection';
import 'dart:convert';
import 'constants.dart';
import 'tag.dart';

dynamic DATETIME({dynamic date_time, bool num = true}) {
  if (date_time == null) {
    date_time = DateTime.now();
    if (num == true) {
      return DATETIME(date_time: date_time);
    } else {
      return date_time;
    }
  } else {
    date_time = date_time;
  }

  if ((date_time is int) && (date_time > 0)) {
    return DateTime.fromMillisecondsSinceEpoch(date_time);
  } else if (date_time is DateTime) {
    return date_time.millisecondsSinceEpoch;
  }
}

String DATE(DateTime date_time) => DateFormat('dd/MM/yyyy').format(date_time);

String TIME(DateTime date_time) => DateFormat('HH:mm:ss').format(date_time);

String DATE_AND_TIME(DateTime date_time) =>
    '${DATE(date_time)} ... ${TIME(date_time)}';

String OFFLINE_FORMAT(dynamic date_time) {
  if (date_time is int) {
    date_time = DATETIME(date_time: date_time);
  }
  return 'OFFLINE | ${DATE(date_time)} | ${TIME(date_time)}';
}

String EXISTS(dynamic manager, dynamic obj) {
  if (manager.objects.containsKey(obj.toString())) {
    return RESPONSE['EXIST'];
  } else {
    return RESPONSE['EXTINCT'];
  }
}

List<int> GETBYTES(String string) => utf8.encode(string);

String GETSTRING(List<int> bytes) => utf8.decode(bytes);

mixin Mixin {
  String get className => runtimeType.toString();
}

List<dynamic> ATTRS(dynamic objec, List<String> attrs) {
  List<dynamic> res = [];

  return res;
}

String ENCRYPT(String string) {
  var id_byt = GETBYTES(string);
  return sha224.convert(id_byt).toString();
}

String GENERATE_ID(List<dynamic> column) {
  String id = column.join("|");
  return ENCRYPT(id);
}

void GENERATE_ACTION_ID(Tag tag) {
  if (tag['id'] != null) {
    return;
  }
  List<dynamic> raw_id = tag[["action", "date_time", "type", "id"]];

  var dt = raw_id[1];

  if (!(dt is int)) {
    raw_id[1] = DATETIME(date_time: dt).toString();
  }

  raw_id.add(DATETIME().toString());

  tag['id'] = GENERATE_ID(raw_id);
}

void GENERATE_CHAT_ID(Tag tag) {
  if (tag['id'] != null) {
    return;
  }
  List<dynamic> raw_id =
      tag[["sender", "recipient", "date_time", "type", "chat"]];

  var dt = raw_id[2];

  if (!(dt is int)) {
    raw_id[2] = DATETIME(date_time: dt).toString();
  }

  raw_id.add(DATETIME().toString());

  tag['id'] = GENERATE_ID(raw_id);
}

void GENERATE_MEMBER_ID(Tag tag, String manager_id, Type manager_type) =>
    tag['unique_id'] = GENERATE_ID([tag['id'], manager_id, manager_type]);

String B64_ENCODE(data) {
  if (data is String) data = GETBYTES(data);
  assert(data is List<int>, 'Data must be List<int>');
  String ret = base64Encode(data);
  return ret;
}

List<int> B64_DECODE(String string) => base64Decode(string);

String B64_DECODE_TO_STRING(String string) => GETSTRING(B64_DECODE(string));

class Tuple<Tup> extends ListBase<Tup> {
  final List<Tup> _list = [];
  Tuple(List<dynamic> list) {
    _list.addAll(Iterable.castFrom(list));
  }

  @override
  set length(int newLength) {
    _list.length = newLength;
  }

  @override
  int get length => _list.length;

  @override
  Tup operator [](int index) => _list[index];

  @override
  void operator []=(int index, Tup value) {
    _list[index] = value;
  }

  @override
  void forEach(void Function(Tup) action) {
    _list.forEach(action);
  }

  @override
  String toString() {
    String text = _list.join(', ');
    return '($text)';
  }
}

CONSTANT GET_TYPE(dynamic chat_object) {
  if (chat_object is Contact)
    return TYPE['CONTACT'];
  else if (chat_object is Group)
    return TYPE['GROUP'];
  else if (chat_object is Channel) return TYPE['CHANNEL'];
  return TYPE;
}
