// ignore_for_file: non_constant_identifier_names

import 'package:peachy/prmp_sql_dart/bases.dart';
// import 'package:sqflite/sqflite.dart';
import '../prmp_sql_dart/statements.dart';
import '../prmp_sql_dart/datatypes.dart';
import '../prmp_sql_dart/constraints.dart';
import 'user.dart';
// import 'package:path/path.dart';

class User_DB {
  static List column_names(List columns) {
    var _list = [];
    columns.forEach((element) {
      _list.add(element.column);
    });
    return _list;
  }

  final user_details_columns = [
    VARCHAR("id"),
    VARCHAR("name"),
    BLOB("key"),
    BLOB("icon"),
    VARCHAR("description"),
    BOOLEAN("recv_data"),
    INT("contacts"),
    INT("groups"),
    INT("channels"),
    INT("unsents"),
    INT("date_time"),
    INT("last_seen"),
  ];
  final objects_columns = [
    VARCHAR("object_id"),
    VARCHAR("name"),
    BLOB("icon"),
    VARCHAR("description"),
    VARCHAR("object_type"),
    VARCHAR("creator"),
    INT("total_members"),
  ];
  final chats_columns = [
    VARCHAR("chat_id"),
    VARCHAR("sender"),
    VARCHAR("recipient"),
    INT("date_time"),
    VARCHAR("type"),
    VARCHAR("chat"),
    VARCHAR("text"),
    BLOB("data"),
    BOOLEAN("sent"),
    VARCHAR("path"),
  ];
  final members_columns = [
    VARCHAR("unique_id"),
    VARCHAR("member_id"),
    VARCHAR("name"),
    BLOB("icon"),
    VARCHAR("description"),
    BOOLEAN("admin"),
    VARCHAR("manager_id"),
    VARCHAR("manager_type"),
    BOOLEAN("is_contact"),
  ];
  final other_settings_columns = [
    VARCHAR("name"),
    VARCHAR("settings"),
  ];
  final user_id = "";
  final loaded_server_settings = false;
  // Database? db;

  User_DB() {
    create_db();
  }
  void create_db() async {
    // db = await openDatabase(join(await getDatabasesPath(), 'client.db'),
    // onCreate: create_tables);
  }

  void create_tables(db, version) {
    List prepare_list(List columns) {
      var _columns = [];
      _columns.add(UNIQUE(columns.first));
      _columns.addAll(columns.sublist(1));
      return _columns;
    }

    var userDetails = CREATE_TABLE(
      "user_details",
      prepare_list(user_details_columns),
      check_exist: true,
    );
    var objects = CREATE_TABLE(
      "objects",
      prepare_list(objects_columns),
      check_exist: true,
    );
    var chats = CREATE_TABLE(
      "chats",
      prepare_list(chats_columns),
      check_exist: true,
    );
    var members = CREATE_TABLE(
      "members",
      prepare_list(members_columns),
      check_exist: true,
    );
    var otherSettings = CREATE_TABLE(
      "other_settings",
      prepare_list(other_settings_columns),
      check_exist: true,
    );
    var tables = [userDetails, chats, members, objects, otherSettings];
    print(tables);

    tables.forEach((table) {
      db.execute(table.toString());
    });
  }

  void save_user(User user) {}
  dynamic load_user({just_id = false}) {}
  void save_objects(user) {}
  dynamic load_objects(user) {}
  void add_chat(tag) {}
  dynamic chat_sent(tag) {}
  dynamic load_chats(user) {}
  void save_members(user) {
    dynamic get_values(member_manager) {}
  }

  void load_members(manager_id, manager_type) {}

  void add_user(user) {}
  Map load_server_settings() {
    return {};
  }

  void save_server_settings(String ip, port) {
    var settings = CONSTANT("$ip;$port");
  }
}
