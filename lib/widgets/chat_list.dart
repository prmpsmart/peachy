import 'package:flutter/material.dart';
import 'package:peachy/screens/chat_screen.dart';
import 'package:peachy/constants.dart' as constants;
import 'profile_dialog.dart';

class ChatList extends StatelessWidget {
  final constants.User client;
  final int type;
  ChatList(this.client, this.type);

  @override
  Widget build(BuildContext context) {
    List<constants.User> users = [];

    client.users.forEach((user) {
      if (user.type == type) users.add(user);
    });

    return Container(
      color: Colors.white,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            constants.User user = users[index];
            constants.Message message = user.messages[index + 4];

            String name = user.name;
            String time = message.time;
            String text = message.text;

            if (type == 2 && message.sender != client) {
              text = '$name : $text';
            }

            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(client: client, user: user),
                      ));
                },
                child: Column(children: [
                  // Divider(height: 2.0),
                  Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: Container(
                            color: message.unread
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
                                                      user, client);
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
                                            message.unread
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
                                              if (message.sent)
                                                Icon(
                                                  message.sent
                                                      ? Icons
                                                          .check_circle_outline
                                                      : Icons.history,
                                                  size: 13,
                                                  color: Colors.grey.shade800,
                                                ),
                                              if (!message.sent)
                                                Icon(
                                                  message.sent
                                                      ? Icons
                                                          .check_circle_outline
                                                      : Icons.history,
                                                  size: 13,
                                                  color: Colors.grey.shade800,
                                                ),
                                              if (message.sent ||
                                                  message.unread)
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
