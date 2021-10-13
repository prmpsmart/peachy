import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';

import '../backend/client.dart' as _client;
import '../backend/core.dart' as _core;
import 'profile_dialog.dart';

class ChatList extends StatelessWidget {
  _client.User ownUser;
  int type;
  ChatList(this.ownUser, this.type);

  @override
  Widget build(BuildContext context) {
    List<_client.User> users = [];

    ownUser?.contacts?.objects?.forEach((user) {
      if (user.type == type) users.add(user);
    });

    return Container(
      color: Colors.white,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            _client.User user = users[index];
            _core.Tag message = user.chats[index + 4];

            String name = user.name;
            String time = message.get_date_time();
            String text = message['text'];

            if (type == 2 && message['sender'] != ownUser) {
              text = '$name : $text';
            }
            bool unread = message['unread'];
            bool sent = message['sent'];

            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(ownUser: ownUser, user: user),
                      ));
                },
                child: Column(children: [
                  // Divider(height: 2.0),
                  Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: Container(
                            color: unread
                                ? Theme.of(context).primaryColor.withOpacity(.2)
                                : Theme.of(context).accentColor,
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.5),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: user.icon.isNotEmpty
                                      ? CircleAvatar(
                                          radius: 27,
                                          foregroundColor:
                                              Theme.of(context).primaryColor,
                                          backgroundImage: null,
                                        )
                                      : IconButton(
                                          icon: Icon(Icons.person),
                                          iconSize: 30,
                                          color: Theme.of(context).accentColor,
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ProfileDialog(
                                                      user, ownUser);
                                                });
                                          },
                                        ),
                                ),
                                Expanded(
                                    child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color:
                                                      Colors.black.withRed(80),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            unread
                                                ? Container(
                                                    padding: EdgeInsets.all(3),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      '5555',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                : Text(''),
                                            Text(
                                              '29/09/2021',
                                              style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 10),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                text,
                                                // maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.grey.shade800,
                                                    fontSize: 11,
                                                    fontFamily:
                                                        'Times New Roman',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Container(
                                                child: Row(children: [
                                              if (sent)
                                                Icon(
                                                  sent
                                                      ? Icons
                                                          .check_circle_outline
                                                      : Icons.history,
                                                  size: 13,
                                                  color: Colors.grey.shade800,
                                                ),
                                              if (!sent)
                                                Icon(
                                                  sent
                                                      ? Icons
                                                          .check_circle_outline
                                                      : Icons.history,
                                                  size: 13,
                                                  color: Colors.grey.shade800,
                                                ),
                                              if (sent || unread)
                                                SizedBox(
                                                  width: 2,
                                                ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0),
                                                child: Text(
                                                  time,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade800,
                                                      fontSize: 10),
                                                ),
                                              )
                                            ]))
                                          ],
                                        ),
                                      ]),
                                ))
                              ],
                            )),
                      )
                    ],
                  )
                ]));
          }),
    );
  }
}
