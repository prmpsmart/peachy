// ignore_for_file: unused_import, non_constant_identifier_names, unused_local_variable

import './user_db.dart';
import './utils.dart';
import './tag.dart';
import './user.dart';

void main(List<String> arguments) {
  var user = User('mary', 'mary', name: 'Mary Anu');
  var tag = Tag({'data': 'lovely'});

  print('');

  GENERATE_CHAT_ID(tag);
  // print(tag);

  // User_DB.create_tables();
  // User_DB.add_user(user);
  // User_DB.add_chat(user, tag);

  // User_DB.remove_user(user);
  // User_DB.remove_chat(tag['id'] as String);

  // User_DB.load_settings();
  // User_DB.load_chats(user);
  // User_DB.load_queued(user);
  // User_DB.load_contacts(user);
  // User_DB.load_groups(user);
  // User_DB.load_channels(user);

  // User_DB.load_user(user.id);
  // User_DB.chat_sent(user, tag);
  // User_DB.save_server_settings('localhost', 7767);
}

// class Base {}

// class Child extends Base {}
