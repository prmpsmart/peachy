// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'base.dart';
import 'constants.dart';
import 'utils.dart';

class Tag with Mixin {
  static final String STR_DELIMITER = '<TAG>';
  static List<int> DELIMITER = GETBYTES(STR_DELIMITER);
  Map OBJECTS = {};

  Tag(Map kwargs_) {
    Map kwargs = Map.from(kwargs_);

    if ((!kwargs.containsKey('date_time')) &&
        (!kwargs.containsKey(TAG['DATE_TIME'])))
      kwargs['date_time'] = DATETIME(num: false);

    kwargs.forEach((k, v) {
      dynamic kk = k, vv = v;

      if (kk == 'data') {
        if (v is List<int>) vv = v;
      }

      if (TAG.list.contains(k.toString().toUpperCase())) {
        kk = TAG[k];
        if (kk.list.contains(v.toString().toUpperCase())) vv = kk[v];
      } else if (TAG['ID'] == k)
        vv = v.toString().toLowerCase();
      else if (TAG['DATE_TIME'] == k)
        vv = DATETIME(date_time: v);
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
        v = DATETIME(date_time: value);
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
    var bytes = GETBYTES(string);
    var encoded = B64_ENCODE(bytes) + STR_DELIMITER;
    return encoded;
  }

  static Tag decode(String encoded) {
    var bytes = B64_DECODE(encoded);
    var string = GETSTRING(bytes);
    Map map = jsonDecode(string);
    return Tag(map);
  }

  void forEach(void Function(dynamic, dynamic) action) =>
      OBJECTS.forEach(action);

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
          if (value is Map) value = Tag(value);
          break;
        }
      return value;
    }
  }

  void operator []=(dynamic key, dynamic value) {
    if (key is String) {
      key = key.toUpperCase();
      if (TAG.list.contains(key)) key = TAG[key];
    }
    OBJECTS[key] = value;
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
