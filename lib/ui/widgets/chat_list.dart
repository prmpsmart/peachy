// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:peachy/backend/user.dart';
import 'package:peachy/backend/utils.dart';
import 'package:peachy/backend/tag.dart';
import 'package:peachy/backend/client.dart';
import 'package:peachy/backend/multi_users.dart';

import '../screens/peachy_home.dart';
import '../screens/chat_screen.dart';
import '../dialogs/profile_dialog.dart';

import '../ui_utils.dart';

class ChatList extends P_StatefulWidget {
  PeachyHome home;
  int type;
  ChatList(this.home, this.type);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends P_StatefulWidgetState<ChatList> {
  PeachyHome get home => widget.home;
  Client get client => home.client;
  User get user => home.user as User;

  void listener() => setState(() {});
  @override
  void initState() {
    client.RECV_LOG.addListener(listener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Manager manager =
        [user.contacts, user.groups, user.channels][widget.type - 1] as Manager;

    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: manager.length,
        itemBuilder: (BuildContext context, int index) {
          var chat_object = manager[index];
          Tag? lastTag;
          if (chat_object.chats.length > 0) {
            lastTag = chat_object.chats.last;
          }

          String name = chat_object.get_name();
          DateTime dateTime = (chat_object.chats.isNotEmpty)
              ? chat_object.chats.last.get_date_time()
              : chat_object.last_time as DateTime;
          String date = DATE(dateTime);
          String time = TIME(dateTime);

          String text = lastTag?['text'] ?? '';
          text = text.replaceAll('\n', ' ');

          int sent = 0;

          Color statusColor = Colors.transparent;
          if (client.online && (chat_object is Contact)) {
            statusColor = chat_object.online ? Colors.green : Colors.grey;
          }

          if (lastTag != null) {
            bool isMe = lastTag['sender'] == user.id;
            if (isMe) {
              text = 'You : $text';
              bool _sent = lastTag['sent'] ?? false;
              sent = _sent ? 1 : 2;
            } else if (widget.type == 2) text = '$name : $text';
          }

          if (text.length > 38) text = '${text.substring(0, 38)} ...';

          int unread = chat_object.unseens;

          Container container = Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                chat_object.icon.isNotEmpty
                    ? CircleAvatar(
                        radius: 27,
                        foregroundColor: Theme.of(context).primaryColor,
                        backgroundImage: null,
                      )
                    : IconButton(
                        icon: Icon(Icons.person),
                        iconSize: 30,
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  ProfileDialog(chat_object, client));
                        },
                      ),
                Positioned(
                    width: 10,
                    height: 10,
                    bottom: 5,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ))
              ],
            ),
          );

          Expanded expanded = Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black.withRed(100),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      unread > 0
                          ? Container(
                              padding: EdgeInsets.all(3),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.4),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '$unread',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.chat_outlined,
                                      size: 18, color: Colors.black)
                                ],
                              ),
                            )
                          : Text(''),
                      Text(
                        date,
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 10),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              text,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            if (sent != 0)
                              Icon(
                                sent == 1
                                    ? Icons.check_circle_outline
                                    : Icons.history,
                                size: 13,
                                color: Colors.grey.shade800,
                              )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          time,
                          style: TextStyle(
                              color: Colors.grey.shade800, fontSize: 10),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );

          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chat_object, client),
                    ));
              },
              child: Column(children: [
                Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: Container(
                          color: unread > 0
                              ? Theme.of(context).primaryColor.withOpacity(.2)
                              : Theme.of(context).colorScheme.secondary,
                          child: Row(
                            children: [container, expanded],
                          )),
                    )
                  ],
                )
              ]));
        },
      ),
    );
  }

  @override
  void dispose() {
    client.RECV_LOG.removeListener(listener);
    super.dispose();
  }
}
