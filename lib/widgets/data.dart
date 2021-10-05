class User {
  final int id;
  String name;
  String icon;

  User({
    this.id,
    this.name,
    this.icon = '',
  });
}

class Message {
  final User sender;
  final String time;
  final String text;
  final bool sent;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.sent,
    this.unread,
  });
}

final User currentUser = User(id: 0, name: 'PRMPSmart Peach');
final User user1 = User(id: 1, name: 'Tina');
final User user2 = User(id: 2, name: 'Valentino');
final User user3 = User(id: 3, name: 'Valentina');
final User user4 = User(id: 4, name: 'Black');
final User user5 = User(id: 5, name: 'Tina Bae');
final User user6 = User(id: 6, name: 'Valentino');
final User user7 = User(id: 7, name: 'Beau Tina');
final User user8 = User(id: 8, name: 'HB Val');
final User user9 = User(id: 9, name: 'Black Tino');

List<User> favorites = [user1, user2, user3, user7, user8, user9];

List<Message> chats = [
  Message(
      sender: user1,
      time: '5: 30 PM',
      text: 'This is user 1, of my first flutter app.',
      sent: false,
      unread: true),
  Message(
      sender: user2,
      time: '5: 30 PM',
      text: 'Hey I\'m user 2, how are you doing?',
      sent: true,
      unread: false),
  Message(
      sender: user3,
      time: '5: 30 PM',
      text:
          'I\'m new here, but I fell in love wih your picture the first time I saw it.',
      sent: false,
      unread: true),
  Message(
      sender: user4,
      time: '5: 30 PM',
      text: 'This is user 1, of my first flutter app.',
      sent: false,
      unread: true),
  Message(
      sender: user6,
      time: '5: 30 PM',
      text: 'Hey I\'m user 2, how are you doing?',
      sent: true,
      unread: false),
  Message(
      sender: user7,
      time: '5: 30 PM',
      text:
          'I\'m new here, but I fell in love wih your picture the first time I saw it.',
      sent: false,
      unread: true),
  Message(
      sender: user8,
      time: '5: 30 PM',
      text: 'This is user 1, of my first flutter app.',
      sent: false,
      unread: true),
  Message(
      sender: user9,
      time: '5: 30 PM',
      text: 'Hey I\'m user 2, how are you doing?',
      sent: true,
      unread: false),
  Message(
      sender: user3,
      time: '5: 30 PM',
      text:
          'I\'m new here, but I fell in love wih your picture the first time I saw it.',
      sent: false,
      unread: true),
  Message(
      sender: user8,
      time: '5: 30 PM',
      text: 'This is user 1, of my first flutter app.',
      sent: false,
      unread: true),
  Message(
      sender: user9,
      time: '5: 30 PM',
      text: 'Hey I\'m user 2, how are you doing?',
      sent: true,
      unread: false),
  Message(
      sender: user3,
      time: '5: 30 PM',
      text:
          'I\'m new here, but I fell in love wih your picture the first time I saw it.',
      sent: false,
      unread: true),
];

List<Message> messages = [
  Message(
      sender: user3,
      time: '2: 30 PM',
      text: 'This is user 1, of my first flutter app.',
      sent: true,
      unread: true),
  Message(
      sender: currentUser,
      time: '2: 40 PM',
      text: 'Hey I\'m user 2, how are you doing?',
      sent: true,
      unread: false),
  Message(
      sender: user3,
      time: '3: 00 PM',
      text:
          'I\'m new here, but I fell in love wih your picture the first time I saw it.',
      sent: false,
      unread: true),
  Message(
      sender: currentUser,
      time: '3: 10 PM',
      text: 'This is user 1, of my first flutter app.',
      sent: false,
      unread: true),
  Message(
      sender: currentUser,
      time: '3: 30 PM',
      text: 'Hey I\'m user 2, how are you doing?',
      sent: true,
      unread: false),
  Message(
      sender: user3,
      time: '4: 00 PM',
      text:
          'I\'m new here, but I fell in love wih your picture the first time I saw it.',
      sent: true,
      unread: true),
  Message(
      sender: user3,
      time: '4: 30 PM',
      text: 'Hello',
      sent: false,
      unread: true),
  Message(
      sender: currentUser,
      time: '4: 30 PM',
      text: 'Hello',
      sent: false,
      unread: true),
  Message(
      sender: currentUser,
      time: '5: 00 PM',
      text: 'How are you doing?',
      sent: true,
      unread: false),
  Message(
      sender: user3,
      time: '4: 30 PM',
      text: 'This is user 1, of my first flutter app.',
      sent: false,
      unread: true),
  Message(
      sender: currentUser,
      time: '5: 00 PM',
      text: 'Hey I\'m user 2, how are you doing?',
      sent: true,
      unread: false),
  Message(
      sender: user3,
      time: '5: 30 PM',
      text:
          'I\'m new here, but I fell in love wih your picture the first time I saw it.',
      sent: true,
      unread: true),
];
