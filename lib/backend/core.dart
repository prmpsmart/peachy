// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
// import 'c';

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
    return DateTime.fromMillisecondsSinceEpoch(date_time * 1000);
  } else if (date_time is DateTime) {
    return date_time.millisecondsSinceEpoch ~/ 1000;
  }
}

String OFFLINE_FORMAT(dynamic date_time) {
  if (date_time is int) {
    date_time = DATETIME(date_time: date_time);
  }
  return 'OFFLINE | ' + DateFormat('dd/MM/yyyy | HH:mm:ss').format(date_time);
}

String DATE(DateTime date_time) => DateFormat('dd/MM/yyyy').format(date_time);

String TIME(DateTime date_time) => DateFormat('HH:mm:ss').format(date_time);

String EXISTS(dynamic manager, dynamic obj) {
  if (manager.objects.containsKey(obj.toString())) {
    return RESPONSE['EXIST'];
  } else {
    return RESPONSE['EXTINCT'];
  }
}

List<int> GETBYTES(String string) =>
    string.codeUnits; // return utf8.encode(string);

String GETSTRING(List<int> bytes) =>
    String.fromCharCodes(bytes); // return utf8.decode(string);

mixin Mixin {
  String get className => runtimeType.toString();
}

List<dynamic> ATTRS(dynamic objec, List<String> attrs) {
  List<dynamic> res = [];

  return res;
}

String GENERATE_ID(List<dynamic> column) {
  var id_byt = GETBYTES(column.join("|"));
  String id = "";
  return id;
}

void GENERATE_CHAT_ID(Tag tag) {
  if (tag['id'] != null) {
    return;
  }
  List<dynamic> raw_id =
      tag[Tuple(["sender", "recipient", "date_time", "type", "chat"])];

  var dt = raw_id[2];

  if (!(dt is int)) {
    raw_id[2] = DATETIME(date_time: dt).toString();
  }

  raw_id.add(DATETIME().toString());

  tag['id'] = GENERATE_ID(raw_id);
}

void GENERATE_MEMBER_ID(Tag tag, String manager_id, Type manager_type) {
  tag['unique_id'] = GENERATE_ID([tag['id'], manager_id, manager_type]);
}

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

// CONSTANTS

CONSTANT SOCKET = CONSTANT('SOCKET', objects: ['RESET', 'CLOSED', 'ALIVE']);
CONSTANT ERRORS = CONSTANT('ERRORS', objects: SOCKET[['RESET', 'CLOSED']]);

CONSTANT CHAT = CONSTANT('CHAT', objects: ['TEXT', 'AUDIO', 'IMAGE', 'VIDEO']);
CONSTANT STATUS =
    CONSTANT('STATUS', objects: ['ONLINE', 'OFFLINE', 'LAST_SEEN']);

CONSTANT RESPONSE = CONSTANT('RESPONSE', objects: [
  'SUCCESSFUL',
  'FAILED',
  'LOGIN_FAILED',
  'SIMULTANEOUS_LOGIN',
  'EXIST',
  'EXTINCT',
  'FALSE_KEY'
]);
CONSTANT ID =
    CONSTANT('ID', objects: ['USER_ID', 'GROUP_ID', 'CHANNEL_ID', 'CHAT_ID']);
CONSTANT TYPE =
    CONSTANT('TYPE', objects: ['ADMIN', 'CONTACT', 'GROUP', 'CHANNEL']);
CONSTANT ACTION = CONSTANT('ACTION', objects: [
  'ADD',
  'REMOVE',
  'CREATE',
  'DELETE',
  'CHANGE',
  'DATA',
  CHAT,
  'START',
  'END',
  STATUS,
  'SIGNUP',
  'LOGIN',
  'LOGOUT',
  'QUEUED'
]);
CONSTANT TAG = CONSTANT('TAG', objects: [
  ACTION,
  "CHAT_COLOR",
  CHAT,
  RESPONSE,
  "SENDER",
  "RECIPIENT",
  "SENDER_TYPE",
  ID,
  "ADMIN",
  "DESCRIPTION",
  "ICON",
  "KEY",
  "CREATOR",
  "NAME",
  "DATA",
  STATUS,
  "DATE_TIME",
  "LAST_SEEN",
  "RESPONSE_TO",
  "EXT",
  TYPE,
  "TEXT",
]);

// CONSTANTS

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

class Tag with Mixin {
  static final String _DELIMITER = '<TAG>';
  static List<int> DELIMITER = GETBYTES(_DELIMITER);
  Map OBJECTS = {};

  Tag(Map kwargs) {
    kwargs.forEach((k, v) {
      dynamic kk = k, vv = v;
      if (TAG.list.contains(k)) {
        kk = TAG[k];
        if (kk.list.contains(v)) vv = kk[v];
      } else if (k == TAG['ID'])
        vv = v.toString().toLowerCase();
      else if (k == TAG['DATE_TIME'])
        vv = DateTime(v);
      else if (v is Map)
        vv = Tag(v);
      else if (v is List) {
        var vals = [];
        v.forEach((v_) {
          dynamic val = v_;
          if (v is Map) val = Tag(v_);
          vals.add(val);
        });
        vv = Tuple(vals);
      }

      OBJECTS[kk] = vv;
      if (vv is Base) OBJECTS[kk] = vv.id;
    });
  }
  @override
  String toString() {
    return '$className($OBJECTS)';
  }

  Map<String, dynamic> get dict {
    var sorted = <String, dynamic>{};

    OBJECTS.forEach((key, value) {
      var k = key.toString();
      dynamic v;

      if (value is CONSTANT) {
        v = value.toString();
      } else if (value is Tag) {
        v = value.dict;
      } else if (value is DateTime) {
        v = value;
      } else if (value is Base) {
        v = value.id;
      } else if (value is Tuple) {
        var vals = [];
        v.forEach((v_) {
          dynamic val = v_;
          if (v is Tag) val = v_.dict;
          vals.add(val);
        });
        v = Tuple(vals);
      } else {
        v = value;
      }
      sorted[k] = v;
    });
    return sorted;
  }

  String get encode {
    var string = jsonEncode(dict);
    // var encoded = GETBYTES(string) + DELIMITER;
    return string;
  }

  static Tag decode_dict(Map dict) {
    return Tag(dict);
  }

  void forEach(void Function(dynamic, dynamic) action) =>
      OBJECTS.forEach(action);

  static Tag decode(List<int> data) {
    var _decoded = GETSTRING(data);
    _decoded = _decoded.replaceAll(_DELIMITER, '');

    Map<String, dynamic> decoded = jsonDecode(_decoded);
    return Tag(decoded);
  }

  static List<Tag> decodes(List<int> data) {
    var list = <Tag>[];
    var _decodes = GETSTRING(data);
    var _decodes_list = _decodes.split(_DELIMITER);

    _decodes_list.forEach((element) {
      if (element is String && element.isNotEmpty) {
        var map = jsonDecode(element);
        list.add(Tag(map));
      }
    });

    return list;
  }

  String get kwargs {
    var _str = '';
    OBJECTS.forEach((key, value) {
      _str += '$key=$value, ';
    });
    return _str.substring(0, _str.length - 2);
  }

  dynamic operator [](attr) {
    if (attr is Tuple) {
      var map = <dynamic, dynamic>{};

      attr.forEach((element) {
        map[element.toString().toUpperCase()] = this[element];
      });
      return map;
    } else if (attr is List) {
      var list = <dynamic>[];

      attr.forEach((element) {
        list.add(this[element]);
      });
      return list;
    } else if (attr is String) {
      dynamic value;
      List keys = OBJECTS.keys.toList();

      for (int i = 0; i < keys.length; i++)
        if (keys[i].toString().toUpperCase() == attr.toUpperCase()) {
          value = OBJECTS[keys[i]];
          break;
        }

      return value;
    }
  }

  void operator []=(dynamic key, dynamic value) {
    if (key is String) {
      OBJECTS[key.toUpperCase()] = value;
    } else {
      OBJECTS[key] = value;
    }
  }

  dynamic get_date_time() {
    dynamic date_time = this['date_time'];
    if (date_time is int) {
      return DATETIME(date_time: date_time);
    }
    return date_time;
  }

  void delete(dynamic attr) {
    var _dict = dict;
    if (_dict.containsKey(attr)) {
      _dict.remove(attr);
    } else if (_dict.containsKey(attr.toString().toUpperCase())) {
      _dict.remove(attr.toString().toUpperCase());
    }
    OBJECTS.clear();
    OBJECTS = _dict;
  }
}

var EMPTY_TAG = Tag({});
var EMPTY_TAGS = [EMPTY_TAG, []];

class Base with Mixin {
  String id;
  String name;
  String ext = '';
  String icon = '';
  String description = '';
  DateTime? date_time;
  List<Tag> chats = [];

  Base(this.id,
      {this.name = '',
      this.icon = '',
      this.description = '',
      DateTime? date_time}) {
    if (date_time != null) {
      this.date_time = date_time;
    } else {
      this.date_time = DateTime.now();
    }
  }

  @override
  String toString() {
    var add = '';
    if (name != '') {
      add = ', name=$name';
    }
    return '$className(id=$id$add)';
  }

  void add_chat(Tag chat) => chats.add(chat);

  Tag get data => Tag({
        'name': name,
        'id': id,
        'icon': icon,
        'description': description,
        'ext': ext
      });
}

// 'p' comes before this type of classes so that they can be imported. They will not be if preceeded by '_'
class p_User_Base extends Base {
  CONSTANT _status = STATUS['OFFLINE'];
  DateTime? last_seen;
  int type = 0;

  p_User_Base(String id,
      {String name = '', String icon = '', DateTime? date_time, description = ''})
      : super(id, name: name, icon: icon, date_time: date_time, description: description) {
    last_seen = DateTime.now();
    change_status(STATUS['OFFLINE']);
  }

  String get status => _status.toString();

  dynamic get current_status {
    if (_status == STATUS['ONLINE']) {
      return _status.toString();
    } else {
      return DATETIME(date_time: last_seen);
    }
  }

  int get int_last_seen => DATETIME(date_time: last_seen);

  String? get str_last_seen {
    // prmp
    if (last_seen != null) {
      return OFFLINE_FORMAT(last_seen);
    }
  }

  void change_status(dynamic status) {
    if (status == STATUS['ONLINE']) {
      _status = status;
    } else {
      var last_seen = 0;
      if (status == STATUS['OFFLINE']) {
        _status = status;
      } else {
        _status = STATUS['ONLINE'];
        last_seen = status;
      }
      this.last_seen = DATETIME(date_time: last_seen, num: false);
    }
  }
}

class p_MultiUsers extends Base {
  bool only_admin = false;
  //prmp
  dynamic creator; // p_User
  Map<String, dynamic> admins_ = {}; // p_User
  Map<String, dynamic> users_ = {}; //p_User
  DateTime? last_time;

  p_MultiUsers(String id,
      {String name = '', String icon = '', DateTime? date_time})
      : super(id, name: name, icon: icon, date_time: date_time) {
    last_time = DateTime.now();
  }

  void add_admin(String admin_id) {
    if (users_.containsKey(admin_id)) {
      admins_[admin_id] = users_[admin_id];
    }
  }

  void add(user) {
    users_[user.id] = user;
  }

  List<String> get ids => users_.keys.toList();

  List<dynamic> get users => users_.values.toList();

  List<dynamic> get objects => users;

  // ignore: unused_element
  Map<String, dynamic> get objects_ => users_;

  List<dynamic> get admin_ids => admins_.keys.toList();

  List<dynamic> get admins => admins_.values.toList();
}

class p_User extends p_User_Base {
  String key = '';
  p_Manager? users;
  p_Manager? groups;
  p_Manager? channels;

  p_User(String id,
      {this.key = '', String name = '', String icon = '', DateTime? date_time, String description = ''})
      : super(id, name: name, icon: icon, date_time: date_time, description : description);

  void add_user(p_User_Base user) {
    users?.add(user);
  }

  void add_group(p_MultiUsers group) {
    groups?.add(group);
  }

  void add_channel(p_MultiUsers channel) {
    channels?.add(channel);
  }
}

class p_Manager {
  p_User user;

  final Map<String, dynamic> objects_ = {};

  p_Manager(this.user);

  get(String item) => objects_[item];

  void add(dynamic obj) {
    if (obj.id == user.id) {
      return;
    }
    var _obj = get(obj.id);
    if (_obj == null) {
      objects_[obj.id] = obj;
    }
  }

  void remove(String id) {
    var obj = get(id);
    if (obj != null) {
      objects_.remove(id);
    }
  }

  void add_chat(Tag chat) {
    var obj = get(chat['recipient']);
    if (obj != null) {
      obj.add_chat(chat);
    }
  }

  int get length => objects_.length;

  List<dynamic> get objects => objects_.values.toList();

  List<String> get ids => objects_.keys.toList();

  dynamic operator [](dynamic name) {
    if (name is String) {
      if (objects_.containsKey(name)) {
        return objects_[name];
      }
    } else if (name is List) {
      var litu = <Base>[];
      name.forEach((element) {
        litu.add(this[element]);
      });
      return litu;
    } else if (name is int) return objects[name];
  }
}

class Sock with Mixin {
  Socket? socket; // or Socket
  CONSTANT state = SOCKET['CLOSED'];
  List<Tag> TAGS = [];
  Function? receiver;
  Function? onDone;
  Function? onError;

  Sock({Socket? socket, this.receiver, this.onDone, this.onError}) {
    if (socket != null) {
      this.socket = socket;
    }
  }

  bool get alive => state == SOCKET['ALIVE'];

  // ignore: unused_element
  Future<bool> connect(String ip, int port) async {
    try {
      socket = await Socket.connect(ip, port);
      state = SOCKET['ALIVE'];
      recv_tag(receiver!);
    } on SocketException {
      state = SOCKET['CLOSED'];
    }
    return alive;
  }

  void close() {
    try {
      state = SOCKET['CLOSED'];
      socket!.close();
      socket!.destroy();
      // ignore: empty_catches
    } catch (e) {}
  }

  //prmp
  dynamic catch_(Function func) {
    try {
      var result = func();
      state = SOCKET['ALIVE'];
      return result;
    } catch (e) {
      state = SOCKET['CLOSED'];
      return ERRORS;
    }
  }

  void recv_tag(Function func) {
    socket!.listen((data) {
      var tags = Tag.decodes(data);
      func(tags);
    }, onDone: () => onDone!(), onError: onError);
  }

  bool send_tag(Tag tag) {
    try {
      socket?.write(tag.encode);
      return true;
    } catch (e) {
      return false;
    }
  }
}
