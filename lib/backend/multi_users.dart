// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'utils.dart';
import 'base.dart';
import 'tag.dart';
import 'user.dart';
import 'user_db.dart';

class Manager extends p_Manager {
  Function(User, Tag)? OBJ;

  Manager(User user) : super(user);

  @override
  dynamic add(tag, {bool db = false}) {
    String id = tag['id'] ?? '';
    if (id != user.id) {
      if (OBJ != null) {
        var obj = get(id);

        if (obj != null)
          obj.change_data(tag);
        else {
          obj = OBJ!(user, tag);
          super.add(obj);
        }
        if (!db) User_DB.ADD(obj);
        return obj;
      }
    }
  }

  @override
  void remove(String id) {
    super.remove(id);
    User_DB.REMOVE(id);
  }
}

class ContactsManager extends Manager {
  ContactsManager(User user) : super(user) {
    OBJ = (User user, Tag tag) => Contact(user, tag);
  }

  @override
  void add_chat(Tag chat) {
    String id = chat['sender'];
    if (id == user.id) {
      id = chat['recipient'];
    }
    var obj = get(id);
    if (obj != null) obj.add_chat(chat);
  }
}

class GroupsManager extends Manager {
  GroupsManager(User user) : super(user) {
    OBJ = (User user, Tag tag) => Group(user, tag);
  }
}

class ChannelsManager extends Manager {
  ChannelsManager(User user) : super(user) {
    OBJ = (User user, Tag tag) => Channel(user, tag);
  }
}

mixin Chats {
  late User user;
  Map<String, Tag> chats_dict = {};
  List<Tag> chats = [];
  DateTime? last_time = DateTime.now();

  void add_chat(Tag tag) {
    String? id = tag['id'];
    if (id is String && !chats_dict.containsKey(id)) {
      last_time = tag.get_date_time() ?? DateTime.now();
      bool? seen = tag['seen'];
      if (seen != true) tag['seen'] = tag['sender'] == user.id;

      chats.add(tag);
      chats_dict[id] = tag;
    }
  }

  Tag? get last_chat {
    if (chats.isNotEmpty) {
      return chats.last;
    }
  }

  List<Tag> unseen_chats() {
    List<Tag> unseens = [];
    chats.forEach((chat) {
      if (!chat['seen']) unseens.add(chat);
    });
    return unseens;
  }

  int get unseens => unseen_chats().length;

  void remove_chat(String tag_id) {
    if (chats_dict.containsKey(tag_id)) {
      Tag tag = chats_dict[tag_id] as Tag;
      chats_dict.remove(tag_id);
      chats.remove(tag);
      User_DB.remove_chat(tag_id);
    }
  }
}

class Contact extends p_User_Base with Chats {
  Contact(User user, Tag tag)
      : super(tag['id'],
            name: tag['name'],
            icon: tag['icon'] ?? '',
            last_seen: tag['last_seen']) {
    this.user = user;
  }
}

class MultiUsers extends Base with Chats {
  bool only_admin = false;
  String creator = '';
  List<String> users = [];
  List<String> admins = [];

  MultiUsers(User user, Tag tag)
      : super(tag['id'],
            name: tag['name'] ?? '',
            icon: tag['icon'] ?? '',
            bio: tag['bio'] ?? '') {
    this.user = user;

    creator = tag['creator'] ?? '';
    var members = tag['members'];

    if (members is String) members = Tag(jsonDecode(members));

    Tuple? users = members['users'];
    if (users != null) {
      users.forEach((p0) => this.users.add(p0 as String));
    }
    Tuple? admins = members['admins'];
    if (admins != null) {
      admins.forEach((p0) => this.admins.add(p0 as String));
    }
  }
  void add_user(String id) {
    if (!users.contains(id)) users.add(id);
  }

  void add_admin(String id) {
    if (users.contains(id) && !admins.contains(id)) admins.add(id);
  }

  @override
  void change_data(Tag tag) {
    super.change_data(tag);
    Tuple? users = tag['users'];
    if (users != null) {
      this.users = [];
      users.forEach((p0) => this.users.add(p0 as String));
    }
    Tuple? admins = tag['admins'];
    if (admins != null) {
      this.admins = [];
      admins.forEach((p0) => this.admins.add(p0 as String));
    }
  }
}

class Group extends MultiUsers {
  final int type = 2;
  Group(User user, Tag tag) : super(user, tag) {
    only_admin = tag['only_admin'] ?? false;
  }

  @override
  void change_data(Tag tag) {
    super.change_data(tag);
    only_admin = tag['only_admin'] ?? false;
  }
}

class Channel extends MultiUsers {
  final int type = 3;
  Channel(User user, Tag tag) : super(user, tag) {
    only_admin = true;
  }
}
