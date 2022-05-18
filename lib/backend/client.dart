// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'multi_users.dart';
import 'constants.dart';
import 'tag.dart';
import 'user.dart';
import 'utils.dart';

class ServerSettings {
  static String ip = '';
  static int port = 0;
  static bool loaded = false;

  static Future<File?> getPath() async {
    var filesDir = await getExternalStorageDirectory();
    File file;

    if (filesDir != null) {
      file = File(filesDir.path + '/server.txt');
      file.create();
      return file;
    }
  }

  static get details => 'ServerSettings(ip=$ip, port=$port, loaded=$loaded)';

  static load() async {
    if (loaded) return;

    File? file = await getPath();
    if (file != null) {
      file.openRead();
      file.readAsString().then((read) {
        if (read.isNotEmpty && read.contains(';')) {
          List<String> reads = read.split(';');
          ip = reads[0];
          port = int.parse(reads[1]);
        }
      });
      loaded = true;
    }
  }

  static save() async {
    File? file = await getPath();
    if (file != null) {
      file.openWrite();
      file.writeAsString('$ip;$port');
    }
  }
}

typedef TAG_RECEIVER = Function(Tag);

class Sock with Mixin {
  Socket? socket;
  CONSTANT state = SOCKET['CLOSED'];
  TAG_RECEIVER parse;
  Function()? onClose;
  Function? onError;
  Function? onConnect;
  bool connecting = false;

  String data = '';

  Sock(this.parse, {this.onConnect, this.onClose, this.onError});

  bool get alive => SOCKET['ALIVE'] == state;

  // ignore: unused_element
  Future<bool> connect() async {
    ServerSettings.load();
    if (connecting || alive) return alive;
    connecting = true;
    try {
      socket = await Socket.connect(ServerSettings.ip, ServerSettings.port);
      state = SOCKET['ALIVE'];
      onConnect!();
      socket!.listen(listen, onError: _onError, onDone: onDone);
    }
    // on SocketException {}
    catch (e) {
      print(e);
      state = SOCKET['RESET'];
    }
    connecting = false;
    return alive;
  }

  void onDone() {
    state = SOCKET['CLOSED'];
    if (onClose != null) onClose!();
  }

  void _onError(e) {
    state = SOCKET['RESET'];
    if (onError != null) onError!(e);
  }

  void listen(List<int> buffer) {
    data += GETSTRING(buffer);
    List<String> ready_data = [];

    if (data.contains(Tag.STR_DELIMITER)) {
      List<String> datas = data.split(Tag.STR_DELIMITER);
      if (data.endsWith(Tag.STR_DELIMITER)) {
        data = '';
        ready_data = datas;
      } else {
        data = datas.last;
        ready_data = datas.getRange(0, datas.length - 1).toList();
      }

      ready_data.forEach((rdata) {
        if (rdata.isNotEmpty) {
          Tag tag = Tag.decode_string(rdata);
          parse(tag);
        }
      });
    }
  }

  void close() {
    try {
      state = SOCKET['CLOSED'];
      socket!.close();
      socket!.destroy();
      // ignore: empty_catches
    } catch (e) {}
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

class Client {
  bool _stop = false; // stop connection or try to relogin
  User? user;
  late Sock socket;

  static Client? activeClient;

  Function(bool)? statusWatcher;

  ValueNotifier<Tag> RECV_LOG = ValueNotifier(Tag({}));
  ValueNotifier<Tag> CHAT_STATUS = ValueNotifier(Tag({}));

  Map<CONSTANT, TAG_RECEIVER> receivers = {};

  bool relogin;

  String data = '';

  @override
  String toString() {
    return 'Client(ip=${ServerSettings.ip} port=${ServerSettings.port}, user=$user)';
  }

  Client({this.user, this.relogin = true, this.statusWatcher}) {
    activeClient = this;

    receivers = {
      ACTION['ADD']: add_receiver,
      ACTION['ADD_ADMIN']: add_admin_receiver,
      ACTION['ADD_MEMBER']: add_member_receiver,
      ACTION['CHANGE']: change_receiver,
      ACTION['CHAT']: chat_receiver,
      ACTION['CREATE']: create_receiver,
      ACTION['DATA']: data_receiver,
      ACTION['LOGIN']: login_receiver,
      ACTION['ONLY_ADMIN']: only_admin_receiver,
      ACTION['REMOVE_ADMIN']: remove_admin_receiver,
      ACTION['REMOVE_MEMBER']: remove_member_receiver,
      ACTION['SIGNUP']: signup_receiver,
      ACTION['STATUS']: status_receiver,
    };

    create_socket();
  }

  bool send_tag(Tag tag) {
    if (alive) return socket.send_tag(tag);
    return false;
  }

  void send_action_tag(Tag tag) {
    GENERATE_ACTION_ID(tag);
    bool res = send_tag(tag);
    if (!res) user!.add_queued(tag);
  }

  void set_user(user) {
    this.user = user;
  }

  bool get alive => socket.alive;
  bool get online => alive && STATUS['ONLINE'] == user?.current_status;

  void create_socket() {
    socket =
        Sock(parse, onClose: onClose, onError: onError, onConnect: onConnect);
  }

  Future<bool> connect() => socket.connect();

  void statusChange() {
    if (statusWatcher != null) statusWatcher!(alive);
    // if (relogin && user != null) re_login();
  }

  void onConnect() => statusChange();

  void onError(e) {}

  void onClose() => shutting();

  void shutting() {
    statusChange();
    gone_offline();
  }

  Function(CONSTANT)? signup_log;

  Future<CONSTANT> signup(String id, String key,
      {String name = '',
      bool force = false,
      bool login = false,
      Function(CONSTANT)? receiver}) async {
    signup_log = receiver;

    assert(id.isNotEmpty && key.isNotEmpty);

    var tag =
        Tag({'id': id, 'name': name, 'key': key, 'action': ACTION['SIGNUP']});

    if (!await connect()) return RESPONSE['FAILED'];
    print(tag);

    try {
      send_tag(tag);
    } catch (e) {
      return ERRORS;
    }
    return RESPONSE['SUCCESSFUL'];
  }

  void signup_receiver(Tag tag) {
    if (RESPONSE['SUCCESSFUL'] == tag['response']) {
      user ??= User(
        tag['id'],
        tag['key'],
        name: tag['name'],
      );
    }
    if (signup_log != null) signup_log!(tag['response']);
  }

  Function(CONSTANT)? login_log;

  Future<CONSTANT> login(
      {String id = '', String key = '', Function(CONSTANT)? receiver}) async {
    login_log = receiver;

    id = id.isNotEmpty ? id : this.user?.id ?? '';
    key = key.isNotEmpty ? key : this.user?.key ?? '';

    if (id.isEmpty && key.isEmpty) return RESPONSE['EXTINCT'];

    var tag = Tag({'id': id, 'key': key, 'action': ACTION['LOGIN']});

    if (!await connect()) return RESPONSE['FAILED'];

    var response;

    try {
      if (send_tag(tag))
        response = RESPONSE['SUCCESSFUL'];
      else
        response = SOCKET['CLOSED'];
    } catch (e) {
      response = ERRORS;
    }

    return response;
  }

  void login_receiver(Tag tag) {
    if (RESPONSE['SUCCESSFUL'] == tag['response']) {
      _stop = false;
      user = User(tag['id'], tag['key']);
      user!.change_status(STATUS['ONLINE']);

      if (!user!.recv_data) send_data(user!.id);
    }
    if (login_log != null) login_log!(tag['response']);
  }

  Future<dynamic> re_login() async {
    while (STATUS['OFFLINE'] == user?.status) {
      if (_stop) return;

      var res = await login();
      if (RESPONSE['SUCCESSFUL'] == res) return res;

      await Future.delayed(Duration(seconds: 1));
    }
  }

  dynamic logout() {
    relogin = false;
    _stop = true;
    dynamic soc_resp;

    var tag = Tag({'action': ACTION['LOGOUT']});
    soc_resp = send_tag(tag);
    if (soc_resp != null && soc_resp == false) {
      stop();
      soc_resp = RESPONSE['SUCCESSFUL'];
    }
    print('$tag, $soc_resp, ${DATETIME(num: false)}');
    return soc_resp;
  }

  void stop() {
    _stop = false;
    socket.close();
    gone_offline();
  }

  void gone_offline() => user?.change_status(STATUS['OFFLINE']);

  // senders
  dynamic send_data(String id, {dynamic type = 'CONTACT'}) {
    var tag = Tag({'id': id, 'action': ACTION['DATA'], 'type': type});
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

  Tag send_chat_tag(Tag tag, {bool resend = false}) {
    GENERATE_CHAT_ID(tag);
    bool res = send_tag(tag);
    tag['sent'] = res;
    if (!resend) user!.add_chat(tag);
    return tag;
  }

  send_queued_tags() async {
    Map<String, Tag> queued = Map.from(this.user!.queued);

    if (queued.isNotEmpty) {
      queued.forEach((key, chat) {
        Tag tag = send_chat_tag(chat, resend: true);
        sleep(Duration(seconds: 1));

        bool sent = tag['sent'] ?? false;

        if (sent) {
          this.user!.queued.remove(key);
          if (ACTION['CHAT'] == tag['action']) CHAT_STATUS.value = tag;
        }
      });
    }
    // await Future.delayed(Duration(seconds: 2));
  }

  // # receivers
  void parse(Tag tag) {
    var action = tag['action'];

    if (receivers.containsKey(action)) {
      var receiver = receivers[action] as TAG_RECEIVER;
      receiver(tag);
    }

    RECV_LOG.value = tag;
  }

  String get_type_id(Tag tag) {
    var add_type = tag['type'];
    if (TYPE['USER'] == add_type)
      return tag['user_id'];
    else if (TYPE['GROUP'] == add_type)
      return tag['group_id'];
    else if (TYPE['CHANNEL'] == add_type)
      return tag['channel_id'];
    else
      return '';
  }

  MultiUsers? get_multi_user(Tag tag) {
    var type = tag['type'];
    var manager;
    if (TYPE['GROUP'] == type)
      manager = user!.groups;
    else if (TYPE['CHANNEL'] == type) manager = user!.channels;

    if (manager != null) return manager[get_type_id(tag)];
  }

  Function(dynamic)? get_add_method(CONSTANT type) {
    Function(dynamic)? add;
    if (TYPE['CONTACT'] == type)
      add = user!.users!.add;
    else if (TYPE['GROUP'] == type)
      add = user!.groups!.add;
    else if (TYPE['CHANNEL'] == type) add = user!.channels!.add;
    return add;
  }

  void add_receiver(Tag tag) {
    var add_type = tag['type'];
    var data = tag['data'];
    if ((RESPONSE['SUCCESSFUL'] == tag['response']) && (data != null)) {
      var add = get_add_method(add_type);
      if (add != null) tag['obj'] = add(Tag(data));
    }
  }

  void add_admin_receiver(Tag tag) {
    var multi_user = get_multi_user(tag);
    var user_id = tag['user_id'];

    if ((multi_user != null) && (user_id != null))
      multi_user.add_admin(user_id);
  }

  void add_member_receiver(Tag tag) {
    var multi_user = get_multi_user(tag);
    var user_id = tag['user_id'];

    if ((multi_user != null) && (user_id != null))
      multi_user.add_user(user_id);
    else if (user_id == user!.id) {
      var data = tag['data'];
      if (data != null) {
        var add_type = tag['type'];
        var add = get_add_method(add_type);
        if (add != null) tag['obj'] = add(Tag(data));
      }
    }
  }

  void change_receiver(Tag tag) {
    String id = get_type_id(tag);

    if (id == user!.id) if (RESPONSE['SUCCESSFUL'] == tag['response'])
      user!.implement_change();
    else if (id.isNotEmpty) {
      var chat_object = user!.get_chat_object(id);

      if (chat_object != null)
        chat_object.change_data(tag[Tuple(["name", "icon", "bio"])]);
    }
  }

  void chat_receiver(Tag tag) {
    user!.add_chat(tag);
  }

  void create_receiver(Tag tag) {
    var type = tag["type"];
    var response = tag["response"];
    if (RESPONSE['SUCCESSFUL'] == response) {
      var id = tag['id'];
      if (user!.pending_created_objects.containsKey(id)) {
        var pending_object = user!.pending_created_objects[id];
        if (pending_object != null) {
          var add = get_add_method(type);
          if (add != null) tag['obj'] = add(pending_object);
        }
      }
    }
  }

  void data_receiver(Tag tag) {
    if (RESPONSE['SUCCESSFUL'] == tag['response']) if (tag['id'] == user!.id) {
      user!.load_data(tag);
    }
  }

  void only_admin_receiver(Tag tag) {
    bool only_admin = false;
    if (tag['user_id'] == true) only_admin = true;
    var multi_user = get_multi_user(tag);
    if (multi_user != null) multi_user.only_admin = only_admin;
  }

  void remove_admin_receiver(Tag tag) {
    var multi_user = get_multi_user(tag);
    var user_id = tag['user_id'];

    if ((multi_user != null) && (user_id != null)) if (multi_user.admins
        .contains(user_id)) multi_user.admins.remove(user_id);
  }

  void remove_member_receiver(Tag tag) {
    var multi_user = get_multi_user(tag);
    var user_id = tag['user_id'];

    if ((multi_user != null) && (user_id != null)) {
      if (multi_user.admins.contains(user_id))
        multi_user.admins.remove(user_id);
      if (multi_user.users.contains(user_id)) multi_user.users.remove(user_id);
    }
  }

  void status_receiver(Tag tag) {
    var id = tag['id'];
    if (id != null) {
      Contact? user = this.user?.users?.get(id);
      if (user != null) user.change_status(tag['status']);
    } else if (tag['statuses'] != null) {
      Tuple statuses = tag['statuses'];
      statuses.forEach((id_status) {
        Contact? user = this.user?.users?.get(id_status[0]);
        if (user != null) user.change_status(id_status[1]);
      });
    }
  }
}
