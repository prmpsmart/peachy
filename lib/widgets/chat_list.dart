// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';

import '../backend/client.dart' as _client;
import '../backend/core.dart' as _core;
import '../dialogs/profile_dialog.dart';

class ChatList extends StatefulWidget {
  _client.User ownUser;
  int type;
  ChatList(this.ownUser, this.type);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 500), () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    _client.Manager manager;

    switch (widget.type) {
      case 1:
        manager = widget.ownUser.contacts;
        break;
      case 2:
        manager = widget.ownUser.groups as _client.Manager;
        break;
      case 3:
      default:
        manager = widget.ownUser.channels as _client.Manager;
        break;
    }

    return Container(
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: manager.length,
        itemBuilder: (BuildContext context, int index) {
          var user = manager[index];
          _core.Tag? lastMessage;
          if (user.chats.length > 0) {
            lastMessage = user.chats.last;
          }

          String name = user.name;
          DateTime dateTime = user.last_time as DateTime;
          String date = _core.DATE(dateTime);
          String time = _core.TIME(dateTime);
          String text = lastMessage?['text'] ?? '';
          int sent = 0;
          if (lastMessage != null) {
            if (lastMessage['sender'] != widget.ownUser.id) {
              if (widget.type == 2)
                text = '$name : $text';
              else if (widget.type == 1) text = 'You : $text';
            } else {
              bool _sent = lastMessage['sent'];
              sent = _sent ? 1 : 2;
            }
          }

          int unread = user.unread_chats;

          Container container = Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: user.icon.isNotEmpty
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
                              ProfileDialog(user, widget.ownUser));
                    },
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
                            color: Colors.black.withRed(80),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      unread > 0
                          ? Container(
                              padding: EdgeInsets.all(3),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '$unread',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
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
                        child: Text(
                          text,
                          // maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 11,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            if (sent != 0)
                              Icon(
                                sent == 1
                                    ? Icons.check_circle_outline
                                    : Icons.history,
                                size: 13,
                                color: Colors.grey.shade800,
                              ),
                            // if (sent == 2)
                            //   Icon(
                            //     sent
                            //         ? Icons.check_circle_outline
                            //         : Icons.history,
                            //     size: 13,
                            //     color: Colors.grey.shade800,
                            //   ),
                            if (sent != 0 || unread > 0)
                              SizedBox(
                                width: 2,
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
                      builder: (context) =>
                          ChatScreen(ownUser: widget.ownUser, user: user),
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
}
