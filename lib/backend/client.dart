import 'core.dart';
import 'package:path/path.dart' as path;

class Manager extends p_Manager {
  Function(User, Tag)? OBJ;

  Manager(User user) : super(user);

  @override
  void add(dynamic tag) {
    if (tag['id'] != user.id) {
      if (OBJ != null) {
        var obj = OBJ!(user as User, tag);
        super.add(obj);
      }
    }
  }
}

mixin Chats {
  late User user;
  List<Tag> chats = [];
  int unread_chats = 0;
  DateTime? last_time = DateTime.now();

  // Chats(this.user);

  void add_chat(Tag tag) {
    var dt = tag['date_time'];
    last_time = dt ?? DateTime.now();
    if (tag['sender'] != user.id) {
      unread_chats += 1;
    }
    chats.add(tag);
  }

  Tag? get last_chat {
    if (chats.isNotEmpty) {
      return chats.last;
    }
  }

  void read() {
    unread_chats = 0;
  }
}

mixin User_Base {
  String icon = '';
  String ext = '';

  void set_icon(String file) {
    // TODO receive file path or file data from android
    icon = file;
    ext = path.extension(file);
  }
}

class Contact extends p_User_Base with Chats, User_Base {
  int type = 1;
  Contact(User user, Tag tag)
      : super(tag['id'], name: tag['name'], icon: tag['icon'] ?? '') {
    this.user = user;
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
      var obj = get(id);
      if (obj != null) {
        obj.add_chat(chat);
      }
    }
  }
}

class MultiUsers extends p_MultiUsers with Chats {
  MultiUsers(User user_, Tag tag)
      : super(tag['id'], name: tag['name'], icon: tag['icon'] ?? '') {
    user = user_;
    creator = getUser(tag['creator']);
    tag['admins'].forEach((id) => admins_[id] = getUser(id));
    tag['users'].forEach((id) => users_[id] = getUser(id));
  }

  getUser(String id) {
    if (user.id == id)
      return user;
    else if (user.contacts.ids.contains(id))
      return user.contacts.objects_[id];
    else
      return p_User(id);
  }
}

class Group extends MultiUsers {
  int type = 2;
  Group(User user, Tag tag) : super(user, tag) {
    only_admin = tag['only_admin'];
  }
}

class GroupsManager extends Manager {
  GroupsManager(User user) : super(user) {
    OBJ = (User user, Tag tag) => Group(user, tag);
  }
}

class Channel extends MultiUsers {
  int type = 3;
  Channel(User user, Tag tag) : super(user, tag) {
    only_admin = true;
  }
}

class ChannelsManager extends Manager {
  ChannelsManager(User user) : super(user) {
    OBJ = (User user, Tag tag) => Channel(user, tag);
  }
}

class User extends p_User with User_Base {
  List<Tag> unsents = [];
  bool recv_data = false;
  bool recv_tags = false;

  User(String id,
      {String name = '',
      String key = '',
      String icon = '',
      DateTime? date_time})
      : super(id, name: name, icon: icon, date_time: date_time, key: key) {
    users = ContactsManager(this);
    groups = GroupsManager(this);
    channels = ChannelsManager(this);
  }

  ContactsManager get contacts => users as ContactsManager;

  void load_data(Tag tag) {
    // print('load_data: $tag');

    name = tag['name'] ?? '';
    icon = tag['icon'] ?? '';
    ext = tag['ext'] ?? '';

    _load_data(users as Manager, tag['users']);
    _load_data(groups as Manager, tag['groups']);
    _load_data(channels as Manager, tag['channels']);
    recv_data = true;
  }

  void _load_data(Manager manager, Map datas) {
    datas.forEach((key, value) {
      value['id'] = key;
      var tag = Tag(value);
      manager.add(tag);
    });
  }

  @override
  void add_chat(Tag chat) {
    String type = chat['type'];
    if (type == TYPE['CONTACT']) {
      users!.add_chat(chat);
    } else if (type == TYPE['GROUP']) {
      groups!.add_chat(chat);
    } else if (type == TYPE['CHANNEL']) {
      channels!.add_chat(chat);
    } else {
      return;
    }
    if ((chat['sender'] == id) && (!chat['sent'])) {
      unsents.add(chat);
    }
  }
}

class Client {
  bool _stop = false; // stop connection or try to relogin
  String ip;
  int port;
  User? user;
  late Sock socket;
  Function(bool)? statusWatcher;

  static Client? activeClient;

  bool relogin;

  bool start = false; // try to relogin after connection failure
  @override
  String toString() {
    return 'Client(ip=$ip port=$port, user=$user)';
  }

  Client(this.ip, this.port,
      {this.user, this.relogin = false, this.statusWatcher}) {
    activeClient = this;
    create_socket();
  }

  void create_socket() {
    socket = Sock(receiver: recv_tag, onDone: onDone, onError: onError);
  }

  bool send_tag(tag) {
    return socket.send_tag(tag);
  }

  void recv_tag(List<Tag> tags) {
    // print('recv_tag: $tags');

    var tag = tags[0];
    var action = tag['action'];
    if (ACTION['SIGNUP'] == action) {
      recv_signup(tag);
    } else if (ACTION['LOGIN'] == action) {
      recv_login(tag);
    } else {
      parse(tag);
    }
  }

  void set_user(user) {
    this.user = user;
  }

  bool get alive => socket.alive;

  Future<bool> connect() async {
    if (alive) return alive;

    var alive_ = await socket.connect(ip, port);

    if (!alive_) {
      create_socket();
      alive_ = await socket.connect(ip, port);
    }
    return alive_;
  }

  void onDone() {
    print('client.Client.onDone:');
    shutting();
  }

  void onError(e) {
    print('client.Client.onError: $e');
    // shutting();
  }

  void shutting() {
    socket.state = SOCKET['CLOSED'];
    statusWatcher!(alive);
    print('client.Client.shutting:');

    gone_offline();
    if (relogin) re_login();
  }

  Function(dynamic)? signup_receiver;

  Future<CONSTANT> signup(
      {String id = '',
      String name = '',
      String key = '',
      User? user,
      bool force = false,
      bool login = false,
      bool start = false,
      Function(dynamic)? receiver}) async {
    signup_receiver = receiver;

    if (!await connect()) {
      return SOCKET['CLOSED'];
    }

    this.user ??= user;
    assert(
        (id.isNotEmpty && name.isNotEmpty && key.isNotEmpty) || (user != null));

    id = id.isNotEmpty ? id : user!.id;
    name = name.isNotEmpty ? name : user!.name;
    key = key.isNotEmpty ? key : user!.key;

    var tag =
        Tag({'id': id, 'name': name, 'key': key, 'action': ACTION['SIGNUP']});

    try {
      send_tag(tag);
    } catch (e) {
      return ERRORS;
    }
    return RESPONSE['SUCCESSFUL'];
  }

  void recv_signup(Tag tag) {
    if (signup_receiver != null) signup_receiver!(tag['response']);

    if (RESPONSE['SUCCESSFUL'] == tag['response']) {
      user ??= User(tag['id'], name: tag['name'], key: tag['key']);
    }

    print('client.Client.recv_signup: ${tag['response']}');
  }

  Function(dynamic)? login_receiver;

  Future<CONSTANT> login(
      {String id = '',
      String key = '',
      User? user,
      bool start = false,
      Function(dynamic)? receiver}) async {
    this.start = start;
    login_receiver = receiver;
    if (!await connect()) return SOCKET['CLOSED'];

    this.user ??= user;
    assert((id.isNotEmpty && key.isNotEmpty) || (user != null));

    id = id.isNotEmpty ? id : this.user!.id;
    key = key.isNotEmpty ? key : this.user!.key;

    var tag = Tag({'id': id, 'key': key, 'action': ACTION['LOGIN']});
    var response;

    try {
      if (send_tag(tag)) {
        response = RESPONSE['SUCCESSFUL'];
      } else
        response = SOCKET['CLOSED'];
    } catch (e) {
      response = ERRORS;
    }

    return response;
  }

  void recv_login(Tag tag) {
    print('client.Client.recv_login: $tag');
    if (login_receiver != null) login_receiver!(tag['response']);

    if (RESPONSE['SUCCESSFUL'] == tag['response']) {
      _stop = false;
      user ??= User(tag['id'], key: tag['key']);
      user!.change_status(STATUS['ONLINE']);

      if (!start) restore_data();
      send_status();
      // send_queued();
      send_queued_tags();
    }
  }

  Future<dynamic> re_login({bool start = false}) async {
    while (STATUS['OFFLINE'] == user!.status) {
      if (_stop) return;

      var res = await login(start: start);
      if ((RESPONSE['SUCCESSFUL'] == res) ||
          (RESPONSE['SIMULTANEOUS_LOGIN'] == res)) {
        return res;
      }
      await Future.delayed(Duration(seconds: 1));
    }
  }

  void start_session() {
    print('client.Client.start_session: Listening to Server');

    while (true) {
      if (_stop) {
        return;
      }
      if (user!.recv_data && !user!.recv_tags) {
        recv_queued_tags();
      }
    }
  }

  dynamic logout() {
    relogin = false;
    _stop = true;
    dynamic soc_resp;

    soc_resp = send_tag(Tag({'action': ACTION['LOGOUT']}));
    if (soc_resp != null && soc_resp == false) {
      stop();
      soc_resp = RESPONSE['SUCCESSFUL'];
    }
    return soc_resp;
  }

  void stop() {
    _stop = false;
    socket.close();
    gone_offline();
  }

  void gone_offline() => user?.change_status(STATUS['OFFLINE']);

  void parse(Tag tag) {
    // print('parse: $tag');

    var action = tag['action'];
    if (ACTION['STATUS'] == action) {
      recv_status(tag);
    } else if (ACTION['CHAT'] == action) {
      recv_chat(tag);
    } else if (ACTION['DATA'] == action) {
      recv_data(tag);
    } else if (ACTION['ADD'] == action) {
      recv_add(tag);
    } else if (ACTION['REMOVE'] == action) {
      recv_remove(tag);
    } else if (ACTION['CREATE'] == action) {
      recv_create(tag);
    } else if (ACTION['CHANGE'] == action) {
      recv_change(tag);
    } else if (ACTION['DELETE'] == action) {
      recv_delete(tag);
    }
  }

  void restore_data() {
    if (user != null) {
      return send_data(user!.id);
    }
  }

  // senders
  dynamic send_data(String id, {dynamic type = 'CONTACT'}) {
    var tag = Tag({'id': id, 'action': ACTION['DATA'], 'type': type});
    return send_tag(tag);
  }

  dynamic send_add(String id, dynamic type) {
    var tag = Tag({'action': ACTION['ADD'], 'type': type, 'id': id});
    return send_tag(tag);
  }

  dynamic send_remove(String id, dynamic type) {
    var tag = Tag({'action': ACTION['REMOVE'], 'type': type, 'id': id});
    return send_tag(tag);
  }

  dynamic send_create(String id, dynamic type, String name, String icon) {
    var tag = Tag({
      'action': ACTION['CREATE'],
      'type': type,
      'id': id,
      'name': name,
      'icon': icon
    });
    return send_tag(tag);
  }

  dynamic send_change(String id, String change, dynamic type, String data) {
    var tag = Tag({
      'action': ACTION['CHANGE'],
      'change': change,
      'type': type,
      'id': id,
      'data': data
    });
    return send_tag(tag);
  }

  dynamic send_delete(String id, dynamic type) {
    var tag = Tag({'action': ACTION['DELETE'], 'type': type, 'id': id});
    return send_tag(tag);
  }

  dynamic send_chat(recipient,
      {String text = '',
      String data = '',
      dynamic chat = 'TEXT',
      dynamic type = 'CONTACT'}) {
    var tag = Tag({
      'recipient': recipient,
      'data': data,
      'chat': chat,
      'type': type,
      'sender': user!.id,
      'action': ACTION['CHAT'],
      'date_time': DATETIME(),
      'text': text
    });
    return send_chat_tag(tag);
  }

  dynamic send_chat_tag(tag) {
    user!.add_chat(tag);
    var res = send_tag(tag);
    tag['sent'] = res is bool;
    return tag;
  }

  dynamic send_start(id, type) {}

  dynamic send_end(id, type) {}

  dynamic send_status() => send_tag(Tag({'action': ACTION['STATUS']}));

  dynamic send_queued() => send_tag(Tag({'action': ACTION['QUEUED']}));

  send_queued_tags() async {
    if (alive && user!.unsents.isNotEmpty) {
      if (_stop) return;

      var unsents = <Tag>[];

      user!.unsents.forEach((chat) async {
        var tag = send_chat_tag(chat);
        await Future.delayed(Duration(seconds: 1));
        if (!tag['sent']) {
          unsents.add(chat);
        }
      });

      user!.unsents = unsents;

      await Future.delayed(Duration(seconds: 2));
      // # send_queued_tags();
    }
  }

  // # receivers
  dynamic recv_data(Tag tag) {
    // print('recv_data: $tag');

    if (RESPONSE['SUCCESSFUL'] == tag['response']) {
      print('here');
      if (tag['id'] == user!.id) {
        user!.load_data(tag);
      }
    }
  }

  dynamic recv_add(Tag tag) {}

  dynamic recv_remove(Tag tag) {}

  dynamic recv_create(Tag tag) {}

  dynamic recv_change(Tag tag) {}

  dynamic recv_delete(Tag tag) {}

  dynamic recv_chat(Tag tag) {
    user!.add_chat(tag);
    print('client.Client.recv_chat $tag');
  }

  dynamic recv_start(Tag tag) {}

  dynamic recv_end(Tag tag) {}

  dynamic recv_status(Tag tag) {
    if (tag['id'] != null) {
      var obj = user?.users?.get(tag['id']);
      if (obj != null) obj.change_status(tag['status']);
    } else if (tag['statuses'] != null) {
      var statuses = tag['statuses'];
      statuses.forEach((element) {
        String id = element[0];
        dynamic status = element[1];
        var user_ = user?.users?.get(id);
        if (user_ != null) user?.change_status(status);
      });
    }
  }

  dynamic recv_queued_tags() {
    var res = send_tag(Tag({'action': ACTION['QUEUED']}));
    if (res is int) {
      user!.recv_tags = true;
    }
  }
}
