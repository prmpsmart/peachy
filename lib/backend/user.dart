// ignore_for_file: non_constant_identifier_names, override_on_non_overriding_member

import 'constants.dart';
import 'database.dart';
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

  static User_DB load_user() => User_DB().load_user();

  User_DB get user_db => User_DB();

  User(String id, String key,
      {String name = '',
      String icon = '',
      String bio = '',
      DateTime? date_time})
      : super(id, name: name, icon: icon, date_time: date_time, bio: bio) {
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

  void change_data(Tag tag) {
    super.change_data(tag);
    String key = tag['key'] ?? '';
    if (key != '') this.key = key;
  }

  void implement_change() {
    print('implement_change: $pending_change_data');
    if (pending_change_data != null) {
      change_data(pending_change_data as Tag);
      clear_pending_change_data();
    }
  }

  void load_data(Tag tag) {
    print('loading data: $tag');

    Tag data = tag['data'];
    name = data['name'] ?? '';
    icon = data['icon'] ?? '';
    bio = data['bio'] ?? '';
    change_status(data['status']);

    _load_data(users as Manager, data['users']);
    _load_data(groups as Manager, data['groups']);
    _load_data(channels as Manager, data['channels']);
    recv_data = true;
  }

  void _load_data(Manager manager, datas) {
    datas.forEach((obj) {
      manager.add(Tag(obj));
    });
  }

  @override
  void add_chat(Tag tag, {bool saved: false}) {
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
    // if (!saved) user_db.add_chat(tag);
  }

  void add_queued(Tag tag) {
    if (!queued.containsKey(['id'])) queued[tag['id']] = tag;
  }

  dynamic get_chat_object(String id) {
    return users![id] || groups![id] || channels![id];
  }

  void add_user(p_User_Base user) {
    users?.add(user);
  }

  void add_group(Group group) {
    groups?.add(group);
  }

  void add_channel(MultiUsers channel) {
    channels?.add(channel);
  }
}
