// ignore_for_file: non_constant_identifier_names, override_on_non_overriding_member

import 'package:flutter/foundation.dart';

import 'constants.dart';
import 'user_db.dart';
import 'base.dart';
import 'multi_users.dart';
import 'tag.dart';

class User extends p_User_Base {
  bool recv_data = false;
  Tag? pending_change_data;
  Map<String, Tag> queued = {};
  Map<String, Tag> pending_created_objects = {};

  String key = '';
  ContactsManager? users;
  GroupsManager? groups;
  ChannelsManager? channels;

  User(String id, String key,
      {String name = '',
      String icon = '',
      String bio = '',
      DateTime? date_time,
      last_seen})
      : super(id,
            name: name,
            icon: icon,
            date_time: date_time,
            bio: bio,
            last_seen: last_seen) {
    this.key = key;
    users = ContactsManager(this);
    groups = GroupsManager(this);
    channels = ChannelsManager(this);
  }

  ContactsManager get contacts => users as ContactsManager;

  void set_pending_change_data(Tag tag) {
    pending_change_data = tag;
  }

  void clear_pending_change_data() {
    pending_change_data = null;
  }

  void change_data(Tag tag, {bool db: false}) {
    super.change_data(tag);
    String key = tag['key'] ?? '';
    if (key != '') this.key = key;
    if (!db) User_DB.add_user(this);
  }

  void implement_change() {
    print('IMPLEMENT CHANGE : $pending_change_data');
    if (pending_change_data != null) {
      change_data(pending_change_data as Tag);
      clear_pending_change_data();
    }
  }

  void load_data(Tag tag) {
    print('LOADING DATA ');

    Tag data = tag['data'];
    name = data['name'] ?? '';
    icon = data['icon'] ?? '';
    bio = data['bio'] ?? '';
    change_status(data['status']);

    load_manager(users, data['users']);
    load_manager(groups, data['groups']);
    load_manager(channels, data['channels']);
    recv_data = true;

    User_DB.add_user(this);
  }

  void load_manager(manager, datas, {bool db: false}) {
    datas.forEach((obj) {
      (manager as Manager).add(Tag(obj), db: db);
    });
  }

  @override
  void add_chat(Tag tag, {bool db: false}) {
    CONSTANT type = tag['type'];

    if (TYPE['CONTACT'] == type)
      contacts.add_chat(tag);
    else if (TYPE['GROUP'] == type)
      groups!.add_chat(tag);
    else if (TYPE['CHANNEL'] == type)
      channels!.add_chat(tag);
    else {
      return;
    }
    if ((tag['sender'] == id) && (!tag['sent'])) {
      add_queued(tag);
    }
    if (!db) User_DB.add_chat(this, tag);
  }

  void add_queued(Tag tag, {bool db: false}) {
    if (!queued.containsKey(['id'])) queued[tag['id']] = tag;
    if (!db) User_DB.add_queued(this, tag);
  }

  void remove_queued(String key) {
    User_DB.add_queued(this, queued[key] as Tag);
    queued.remove(key);
  }

  void chat_seen(Tag tag) {
    tag['seen'] = true;
    User_DB.add_chat(this, tag);
  }

  dynamic get_chat_object(String id) {
    return users![id] || groups![id] || channels![id];
  }

  static ValueNotifier<bool> FINISHED_LOADING = ValueNotifier(false);
}
