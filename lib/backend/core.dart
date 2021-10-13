import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

dynamic DATETIME({dynamic date_time, bool num = true}) {
  dynamic datetime;
  if (date_time == null) {
    datetime = DateTime.now();
    if (num == true) {
      return DATETIME(date_time: datetime);
    } else {
      return datetime;
    }
  } else {
    datetime = date_time;
  }
  if ((datetime is int) && (datetime > 0)) {
    return DateTime.fromMicrosecondsSinceEpoch(datetime);
  } else if (datetime is DateTime) {
    return datetime.microsecondsSinceEpoch;
  }
}

String OFFLINE_FORMAT(dynamic date_time) {
  if (date_time is int) {
    date_time = DATETIME(date_time: date_time);
  }
  return 'OFFLINE | ' + DateFormat('dd/MM/yy | HH:mm:ss').format(date_time);
}

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

class CONSTANT with Mixin {
  String _NAME = '';
  Map<String, CONSTANT> OBJECTS = {};

  CONSTANT(String name, {List<dynamic> objects}) {
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
    return null;
  }

  @override
  bool operator ==(dynamic other) => other.toString().toUpperCase() == _NAME;
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
  'CHAT_COLOR',
  CHAT,
  RESPONSE,
  'SENDER',
  'RECIPIENT',
  'SENDER_TYPE',
  ID,
  'KEY',
  'NAME',
  'DATA',
  STATUS,
  'DATE_TIME',
  'LAST_SEEN',
  'RESPONSE_TO',
  'EXT',
  TYPE,
  'TEXT'
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
}

class Tag with Mixin {
  static final String _DELIMITER = '<TAG>';
  static List<int> DELIMITER = GETBYTES(_DELIMITER);
  Map<dynamic, dynamic> OBJECTS = {};

  Tag(Map<dynamic, dynamic> kwargs) {
    kwargs.forEach((key, value) {
      if (key is String) {
        key = key.toUpperCase();
      }
      if (value is Base) {
        OBJECTS[key] = value.id;
      } else {
        OBJECTS[key] = value;
      }
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
      if (OBJECTS.containsKey(attr.toUpperCase())) {
        return OBJECTS[attr.toUpperCase()];
      }
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

class Base with Mixin {
  String id = '';
  String name = '';
  String ext = '';
  String icon = '';
  DateTime date_time;
  List<Tag> chats = [];

  Base(this.id, {this.name, this.icon = '', DateTime date_time}) {
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
}

// 'p' comes before this type of classes so that they can be imported. They will not be if preceeded by '_'
class p_User_Base extends Base {
  CONSTANT _status = STATUS['OFFLINE'];
  DateTime last_seen;
  int type = 0;

  p_User_Base(String id,
      {String name = '', String icon = '', DateTime date_time})
      : super(id, name: name, icon: icon, date_time: date_time);

  String get status => _status.toString();

  dynamic get current_status {
    if (_status == STATUS['ONLINE']) {
      return _status.toString();
    } else {
      return DATETIME(date_time: last_seen);
    }
  }

  int get int_last_seen => DATETIME(date_time: last_seen);

  String get str_last_seen {
    // prmp
    if (last_seen != null) {
      return OFFLINE_FORMAT(last_seen);
    }
    return null;
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

class p_Multi_Users extends Base {
  bool only_admin = false;
  //prmp
  dynamic creator; // p_User
  Map<String, dynamic> admins_ = {}; // p_User
  Map<String, dynamic> users_ = {}; //p_User
  DateTime last_time;

  p_Multi_Users(String id,
      {String name = '', String icon = '', DateTime date_time})
      : super(id, name: name, icon: icon, date_time: date_time);

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
  p_Manager users;
  p_Manager groups;
  p_Manager channels;

  p_User(String id,
      {this.key = '', String name = '', String icon = '', DateTime? date_time})
      : super(id, name: name, icon: icon, date_time: date_time);

  void add_user(p_User_Base user) {
    users?.add(user);
  }

  void add_group(p_Multi_Users group) {
    groups?.add(group);
  }

  void add_channel(p_Multi_Users channel) {
    channels?.add(channel);
  }
}

class p_Manager {
  p_User user;
  final Map<String, Base> objects_ = {};

  p_Manager(this.user);

  p_User_Base get(String item) {
    return objects_[item];
  }

  void add(dynamic obj) {
    if (obj.id == user?.id) {
      return;
    }
    var _obj = get(obj.id);
    if (_obj != null) {
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

  List<p_User_Base> get objects => objects_.values.toList();

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
    }
  }
}

class Sock with Mixin {
  Socket socket; // or Socket
  CONSTANT state = SOCKET['CLOSED'];
  List<Tag> TAGS = [];
  Function receiver;
  Function onDone;
  Function onError;

  Sock({Socket socket, this.receiver, this.onDone, this.onError}) {
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
      recv_tag(receiver);
    } on SocketException {
      state = SOCKET['CLOSED'];
    }
    return alive;
  }

  void close() {
    try {
      state = SOCKET['CLOSED'];
      socket.close();
      socket.destroy();
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
      return ERRORS;
    }
  }

  void recv_tag(Function func) {
    socket.listen((data) {
      var tags = Tag.decodes(data);
      func(tags);
    }, onDone: onDone, onError: onError);
  }

  bool send_tag(Tag tag) {
    socket.write(tag.encode);
    return true;
  }
}
