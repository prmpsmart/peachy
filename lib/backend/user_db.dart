// ignore_for_file: camel_case_types, non_constant_identifier_names, empty_constructor_bodies, unused_element, unused_local_variable

import 'dart:convert';

import './utils.dart';
import './user.dart';
import './multi_users.dart';
import './tag.dart';

// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:peachy/prmp_sql_dart/prmp_sql_dart.dart';

class User_DB {
  static List<String> USERS = [];
  static User? USER;
  static bool DEBUG = false;

  static final USERS_COLUMNS = [
    PRIMARY_KEY(VARCHAR("id")),
    VARCHAR("name"),
    TEXT("key"),
    TEXT("bio"),
    TEXT("icon"),
    BOOLEAN("recv_data"),
    INT("last_seen"),
    INT("date_time"),
  ];

  static final TAGS_COLUMNS = [
    PRIMARY_KEY(VARCHAR("id")),
    VARCHAR("user_id"),
    TEXT("tag_encrypt"),
    TEXT("data"),
    VARCHAR("path"),
  ];

  static final CONTACTS_COLUMNS = [
    PRIMARY_KEY(VARCHAR("id")),
    VARCHAR("user_id"),
    VARCHAR("name"),
    TEXT("bio"),
    INT("last_seen"),
    TEXT("icon"),
  ];

  static final MEMBERS_COLUMNS = [
    PRIMARY_KEY(VARCHAR("id")),
    VARCHAR("user_id"),
    VARCHAR("name"),
    TEXT("bio"),
    TEXT("icon"),
    TEXT("members"),
    BOOLEAN("admin_only"),
  ];

  static final SETTINGS_COLUMNS = [
    VARCHAR("name"), // last logged in user
    VARCHAR("value"),
  ];

  static Database? database;

  static Future<void> init() async {
    if (database == null) {
      // String databasePath = (await getExternalStorageDirectory())!.path;
      String databasePath = await getDatabasesPath();
      databasePath = join(databasePath, 'peachy_db.db');

      // if (await databaseExists(databasePath)) deleteDatabase(databasePath);

      database =
          await openDatabase(databasePath, version: 1, onCreate: create_tables);

      // clear_groups();
    }
  }

  static void create_tables(Database db, int version) {
    List prepare_list(List columns) {
      var _columns = [];
      _columns.add(UNIQUE(columns.first));
      _columns.addAll(columns.sublist(1));
      return (_columns);
    }

    var settings = CREATE_TABLE(
      "settings",
      prepare_list(SETTINGS_COLUMNS),
      check_exist: true,
    );
    var chats = CREATE_TABLE(
      "chats",
      prepare_list(TAGS_COLUMNS),
      check_exist: true,
    );
    var queued = CREATE_TABLE(
      "queued",
      prepare_list(TAGS_COLUMNS),
      check_exist: true,
    );
    var users = CREATE_TABLE(
      "users",
      prepare_list(USERS_COLUMNS),
      check_exist: true,
    );
    var contacts = CREATE_TABLE(
      "contacts",
      CONTACTS_COLUMNS,
      check_exist: true,
    );
    var groups = CREATE_TABLE(
      "groups",
      prepare_list(MEMBERS_COLUMNS),
      check_exist: true,
    );
    var channels = CREATE_TABLE(
      "channels",
      prepare_list(MEMBERS_COLUMNS),
      check_exist: true,
    );
    var tables = [settings, chats, queued, users, contacts, groups, channels];

    tables.forEach((table) {
      String query = table.toString();
      db.execute(query);
    });
  }

//
//
//
//
//
//
//
//
// add
  static void add_user(User user) async {
    var statement;
    if (USERS.contains(user.id) ||
        await CHECK_IF_EXISTS('users', 'id', user.id))
      statement = UPDATE(
        'users',
        SET([
          EQUAL_TO_STRING('name', user.name),
          EQUAL_TO_STRING('key', user.key),
          EQUAL_TO_STRING('bio', user.bio),
          EQUAL_TO_STRING('icon', user.icon),
          EQUAL('recv_data', user.recv_data),
          EQUAL('last_seen', user.int_last_seen),
        ]),
        where: WHERE(
          EQUAL_TO_STRING(
            'id',
            user.id,
          ),
        ),
      );
    else
      statement = INSERT(
        'users',
        columns: Columns([
          'id',
          'name',
          'key',
          'bio',
          'icon',
          'recv_data',
          'last_seen',
          'date_time',
        ], parenthesis: true),
        values: VALUES(
          [
            user.id,
            user.name,
            user.key,
            user.bio,
            user.icon,
            user.recv_data,
            user.int_last_seen,
            DATETIME(date_time: user.date_time),
          ],
        ),
      );

    if (!USERS.contains(user.id)) USERS.add(user.id);

    EXECUTE(statement);
  }

  static void add_contact(Contact contact) async {
    var user = contact.user;
    var statement;
    if (await CHECK_IF_EXISTS('contacts', 'id', contact.id))
      statement = UPDATE(
        'contacts',
        SET([
          EQUAL_TO_STRING('user_id', user.id),
          EQUAL_TO_STRING('name', contact.name),
          EQUAL_TO_STRING('bio', contact.bio),
          EQUAL('last_seen', contact.int_last_seen),
          EQUAL_TO_STRING('icon', contact.icon),
        ]),
        where: WHERE(
          EQUAL_TO_STRING(
            'id',
            contact.id,
          ),
        ),
      );
    else
      statement = INSERT(
        'contacts',
        columns: Columns([
          'user_id',
          'id',
          'name',
          'bio',
          'last_seen',
          'icon',
        ], parenthesis: true),
        values: VALUES(
          [
            user.id,
            contact.id,
            contact.name,
            contact.bio,
            contact.int_last_seen,
            contact.icon,
          ],
        ),
      );
    EXECUTE(statement);
  }

  static void add_group(Group group) async {
    var user = group.user;
    var statement;
    var members = MEMBERS_STRING(group);
    if (await CHECK_IF_EXISTS('groups', 'id', group.id))
      statement = UPDATE(
        'groups',
        SET([
          EQUAL_TO_STRING('user_id', user.id),
          EQUAL_TO_STRING('name', group.name),
          EQUAL_TO_STRING('bio', group.bio),
          EQUAL_TO_STRING('icon', group.icon),
          EQUAL_TO_STRING('members', members),
          EQUAL('admin_only', group.only_admin),
        ]),
        where: WHERE(
          EQUAL_TO_STRING(
            'id',
            group.id,
          ),
        ),
      );
    else
      statement = INSERT(
        'groups',
        columns: Columns([
          'user_id',
          'id',
          'name',
          'bio',
          'icon',
          'members',
          'admin_only',
        ], parenthesis: true),
        values: VALUES(
          [
            user.id,
            group.id,
            group.name,
            group.bio,
            group.icon,
            members,
            group.only_admin,
          ],
        ),
      );
    EXECUTE(statement);
  }

  static void add_channel(Channel channel) async {
    var user = channel.user;
    var statement;
    var members = MEMBERS_STRING(channel);
    if (await CHECK_IF_EXISTS('channels', 'id', channel.id))
      statement = UPDATE(
        'channels',
        SET([
          EQUAL_TO_STRING('user_id', user.id),
          EQUAL_TO_STRING('name', channel.name),
          EQUAL_TO_STRING('bio', channel.bio),
          EQUAL_TO_STRING('icon', channel.icon),
          EQUAL_TO_STRING('members', members),
          EQUAL('admin_only', channel.only_admin),
        ]),
        where: WHERE(
          EQUAL_TO_STRING(
            'id',
            channel.id,
          ),
        ),
      );
    else
      statement = INSERT(
        'channels',
        columns: Columns([
          'user_id',
          'id',
          'name',
          'bio',
          'icon',
          'members',
          'admin_only',
        ], parenthesis: true),
        values: VALUES(
          [
            user.id,
            channel.id,
            channel.name,
            channel.bio,
            channel.icon,
            members,
            channel.only_admin,
          ],
        ),
      );
    EXECUTE(statement);
  }

  static void add_tag(User user, Tag tag, String table) async {
    var statement;
    if (await CHECK_IF_EXISTS(table, 'id', tag['id']))
      statement = UPDATE(
        table,
        SET(
          [
            EQUAL_TO_STRING('tag_encrypt', TAG_ENCRYPT(tag)[0]),
          ],
        ),
        where: WHERE(
          EQUAL_TO_STRING('id', tag['id']),
        ),
      );
    else {
      List<String> tag_data = TAG_ENCRYPT(tag);

      statement = INSERT(
        table,
        columns: Columns([
          'id',
          'user_id',
          'tag_encrypt',
          'data',
          'path',
        ], parenthesis: true),
        values: VALUES(
          [
            tag['id'],
            user.id,
            tag_data[0],
            tag_data[1],
            tag['path'] ?? '',
          ],
        ),
      );
    }
    EXECUTE(statement);
  }

  static void add_chat(User user, Tag tag) async => add_tag(user, tag, 'chats');

  static void add_queued(User user, Tag tag) async =>
      add_tag(user, tag, 'queued');
//
//
//
//
//
//
//
// remove
  static void remove(String table, String value) => EXECUTE(
        DELETE(
          table,
          where: WHERE(
            EQUAL_TO_STRING(
              'id',
              value,
            ),
          ),
        ),
      );
// remove
  static void remove_user(User user) => remove('users', user.id);

  static void remove_contact(String contact_id) =>
      remove('contacts', contact_id);

  static void remove_group(String group_id) => remove('groups', group_id);

  static void remove_channel(String channel_id) =>
      remove('channels', channel_id);

  static void remove_chat(String tag_id) => remove('chats', tag_id);

  static void remove_queued(String tag_id) => remove('queued', tag_id);

//
//
//
//
//
//
//
//
// load
  static Future<User?> load_user(String id, {bool load_data: true}) async {
    if (await CHECK_IF_EXISTS('users', 'id', id)) {
      var select = SELECT(
        '*',
        'users',
        where: WHERE(
          EQUAL_TO_STRING('id', id),
        ),
      );
      var result = await QUERY(select);

      User? user;

      if (result.isNotEmpty) {
        var tag = Tag(result[0]);
        user = User(tag['id'], tag['key'],
            name: tag['name'],
            bio: tag['bio'],
            icon: tag['icon'],
            date_time: DATETIME(date_time: tag['date_time']),
            last_seen: tag['last_seen']);
        user.recv_data = tag['recv_data'] == 1;
        USER = user;
        if (load_data) load_user_data(user);
      }
      return user;
    }
  }

  static void load_last_user() async {
    var id = await load_last_logged_user();
    if (id.isNotEmpty) USER = await load_user(id, load_data: false);
  }

  static void load_user_data(User user) async {
    await load_contacts(user);
    await load_groups(user);
    await load_channels(user);
    User.FINISHED_LOADING.value = !User.FINISHED_LOADING.value;
    await load_chats(user);
    User.FINISHED_LOADING.value = !User.FINISHED_LOADING.value;
    await load_queued(user);
  }

  static Future<List<Map<String, Object?>>> load_user_data_from_table(
    User user,
    String table,
  ) async {
    return await QUERY(
      SELECT(
        '*',
        table,
        where: WHERE(
          EQUAL_TO_STRING('user_id', user.id),
        ),
      ),
    );
  }

  static Future<void> load_contacts(User user) async {
    var result = await load_user_data_from_table(user, 'contacts');
    user.load_manager(user.users, result, db: true);
  }

  static Future<void> load_groups(User user) async {
    var result = await load_user_data_from_table(user, 'groups');
    user.load_manager(user.groups, result, db: true);
  }

  static Future<void> load_channels(User user) async {
    var result = await load_user_data_from_table(user, 'channels');
    user.load_manager(user.channels, result, db: true);
  }

  static Future<void> load_tags(
      User user, String table, Function(Tag, {bool db}) add_function) async {
    var results = await load_user_data_from_table(user, table);

    for (Map res in results) {
      String data = Tag(res)['data'];
      // String path = tag['path'];

      var chat = TAG_DECRYPT(res['tag_encrypt']);
      if (data.isNotEmpty) chat['data'] = data;

      add_function(chat, db: true);
    }
  }

  static Future<void> load_chats(User user) async =>
      load_tags(user, 'chats', user.add_chat);

  static Future<void> load_queued(User user) async =>
      load_tags(user, 'queued', user.add_queued);

  static void load_users() async {
    var select = SELECT('id', 'users');
    var result = await QUERY(select);
    for (var item in result) {
      USERS.add(item['id'] as String);
    }
  }

  static Future<String> load_settings(String name) async {
    String value = '';

    var select = SELECT(
      'value',
      'settings',
      where: WHERE(
        EQUAL_TO_STRING('name', name),
      ),
    );
    var result = await QUERY(select);
    if (result.isNotEmpty) {
      value = result.first['value'].toString();
    }
    return value;
  }

  static Future<String> load_last_logged_user() async =>
      load_settings('last_logged_user');

  static Future<String> load_server_settings() async =>
      load_settings('server_settings');

//
//
//
//
//
//
//
// clear
  static void clear_user_data(String user_id) {
    clear_contacts(user_id);
    clear_groups(user_id);
    clear_channels(user_id);
    clear_chats(user_id);
  }

  static void clear_contacts(String user_id) {
    EXECUTE(
      DELETE(
        'contacts',
        where: WHERE(
          EQUAL_TO_STRING('user_id', user_id),
        ),
      ),
    );
  }

  static void clear_groups(String user_id) {
    EXECUTE(
      DELETE(
        'groups',
        where: WHERE(
          EQUAL_TO_STRING('user_id', user_id),
        ),
      ),
    );
  }

  static void clear_channels(String user_id) {
    EXECUTE(
      DELETE(
        'channels',
        where: WHERE(
          EQUAL_TO_STRING('user_id', user_id),
        ),
      ),
    );
  }

  static void clear_chats(String user_id) {
    EXECUTE(
      DELETE(
        'chats',
        where: WHERE(
          EQUAL_TO_STRING('user_id', user_id),
        ),
      ),
    );
  }

  static void clear_tags(String user_id) {
    EXECUTE(
      DELETE(
        'queued',
        where: WHERE(
          EQUAL_TO_STRING('user_id', user_id),
        ),
      ),
    );
  }

//
//
//
//
//
//
//
// update
  static void update_settings(String name, String value) async {
    var statement;
    if (await CHECK_IF_EXISTS('settings', 'name', name))
      statement = UPDATE(
        'settings',
        SET([
          EQUAL_TO_STRING('value', value),
        ]),
        where: WHERE(
          EQUAL_TO_STRING('name', name),
        ),
      );
    else
      statement = INSERT(
        'settings',
        columns: Columns(['name', 'value']),
        values: VALUES([name, value]),
      );
    EXECUTE(statement);
  }

  static Future<void> update_last_logged_user(String user_id) async {
    if (await load_last_logged_user() != user_id) {
      clear_user_data(user_id);
    }
    update_settings('last_logged_user', user_id);
  }

  static void update_server_settings(String ip, port) async =>
      update_settings('server_settings', "$ip;$port");

//
//
//
//
//
//
//
// general
  static Future<bool> CHECK_IF_EXISTS(
    String table,
    String column,
    String value,
  ) async {
    var count_1 = COUNT(1);
    var select = SELECT(
      count_1,
      table,
      where: WHERE(
        EQUAL_TO_STRING(column, value),
      ),
      limit: LIMIT(1),
    );

    var result = await QUERY(select);
    return result[0][count_1.toString()] != 0 ? true : false;
  }

  static Future<void> EXECUTE(
    Statement statement,
  ) async {
    var statement_ = statement.toString();
    if (DEBUG) print('EXECUTE : $statement_');
    if (database != null) await database!.execute(statement_);
  }

  static Future<List<Map<String, Object?>>> QUERY(
    Statement statement,
  ) async {
    var statement_ = statement.toString();
    List<Map<String, Object?>> result = [];
    if (DEBUG) print('QUERY : $statement_');
    if (database != null) {
      result = await database!.rawQuery(statement_);
      if (DEBUG) print('QUERY_RESULT : $result');
    }
    return result;
  }

  static void CLOSE() async {
    if (database != null) await database!.close();
    database = null;
  }

  static void ADD(obj, {User? user, bool queued = false}) {
    if (obj is User)
      add_user(obj);
    else if (obj is Contact)
      add_contact(obj);
    else if (obj is Group)
      add_group(obj);
    else if (obj is Channel)
      add_channel(obj);
    else if (queued && (obj is Tag))
      add_queued(user as User, obj);
    else if (obj is Tag) add_chat(user as User, obj);
  }

  static void REMOVE(obj) {
    if (obj is Contact)
      remove_contact(obj.id);
    else if (obj is Group)
      remove_group(obj.id);
    else if (obj is Channel) remove_channel(obj.id);
  }

  static List<String> TAG_ENCRYPT(Tag tag) {
    String data = '';

    Map map = tag.dict;

    if (map.containsKey('DATA')) {
      data = map['DATA'];
      map.remove('DATA');
    }
    String tag_en = B64_ENCODE(jsonEncode(map));

    return [tag_en, data];
  }

  static Tag TAG_DECRYPT(String string) {
    String data = B64_DECODE_TO_STRING(string);
    return Tag(jsonDecode(data));
  }

  static String MEMBERS_STRING(MultiUsers multi_user) {
    Map<String, List<String>> members = {
      'users': multi_user.users,
      'admins': multi_user.admins
    };
    return jsonEncode(members);
  }
}
