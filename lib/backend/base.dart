// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'user.dart';
import 'constants.dart';
import 'tag.dart';
import 'utils.dart';

class Base with Mixin {
  String id;
  String name;
  String icon = '';
  String bio = '';
  DateTime? date_time;

  Base(this.id,
      {this.name = '', this.icon = '', this.bio = '', DateTime? date_time}) {
    if (date_time != null) {
      this.date_time = date_time;
    } else {
      this.date_time = DateTime.now();
    }
  }
  String get_name() {
    if (name.isEmpty) return id;
    return name;
  }

  @override
  String toString() {
    var add = '';
    if (name != '') {
      add = ', name=$name';
    }
    return '$className(id=$id$add)';
  }

  Tag get data => Tag({'name': name, 'id': id, 'icon': icon, 'bio': bio});

  void change_data(Tag tag) {
    String name = tag['name'] ?? '';
    String icon = tag['icon'] ?? '';
    String bio = tag['bio'] ?? '';

    if (name != '') this.name = name;
    if (icon != '') this.icon = icon;
    if (bio != '') this.bio = bio;
  }
}

// 'p' comes before this type of classes so that they can be imported. They will not be if preceeded by '_'
class p_User_Base extends Base {
  CONSTANT _status = STATUS['OFFLINE'];
  DateTime? last_seen;
  final int type = 1;

  bool get online => _status == STATUS['ONLINE'];

  p_User_Base(String id,
      {String name = '',
      String icon = '',
      DateTime? date_time,
      String bio = '',
      last_seen})
      : super(id, name: name, icon: icon, bio: bio, date_time: date_time) {
    if (last_seen is int) set_last_seen(last_seen);
    change_status(STATUS['OFFLINE']);
  }

  String get status => _status.toString();

  dynamic get current_status {
    if (STATUS['ONLINE'] == _status) {
      return _status.toString();
    } else if (last_seen != null) {
      return DATETIME(date_time: last_seen);
    }
  }

  int get int_last_seen => DATETIME(date_time: last_seen);

  String? get str_last_seen {
    if (last_seen != null) {
      return OFFLINE_FORMAT(last_seen);
    }
  }

  void change_status(dynamic status) {
    if (STATUS['ONLINE'] == status) {
      _status = STATUS['ONLINE'];
    } else {
      _status = STATUS['OFFLINE'];
      int last = (status is int) ? status : 0;
      if (last != 0) last_seen = DATETIME(date_time: last, num: false);
    }
  }

  void set_last_seen(int last_seen) {
    this.last_seen = DATETIME(date_time: last_seen, num: false);
  }
}

class p_Manager {
  User user;

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
