import 'package:flutter/material.dart';
import 'package:peachy/screens/chat_screen.dart';
import 'package:peachy/widgets/profile_dialog.dart';
import 'data.dart';

class ChatList extends StatelessWidget {
  final manager;
  ChatList(this.manager);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index) {
            Message chat = chats[index];
            String name = chat.sender.name;
            String time = chat.time;
            String message = chat.text;
            User user = chat.sender;

            return Column(
              children: <Widget>[
                Divider(
                  height: 0.0,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(user: chat.sender),
                        ));
                  },
                  leading: user.icon.isNotEmpty
                      ? CircleAvatar(
                          radius: 27,
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundImage: null,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.account_circle_outlined),
                            iconSize: 40,
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ProfileDialog(user);
                                  });
                            },
                          ),
                        ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      chat.unread
                          ? Container(
                              width: 23,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '500',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Text(''),
                      Text(
                        '29/09/2021',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      )
                    ],
                  ),
                  subtitle: Container(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Container(
                            child: Row(children: [
                          if (chat.sent)
                            Icon(
                              chat.sent
                                  ? Icons.check_circle_outline
                                  : Icons.history,
                              size: 13,
                              color: Colors.grey,
                            ),
                          if (!chat.sent)
                            Icon(
                              chat.sent
                                  ? Icons.check_circle_outline
                                  : Icons.history,
                              size: 13,
                              color: Colors.grey,
                            ),
                          if (chat.sent || chat.unread)
                            SizedBox(
                              width: 2,
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              time,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          )
                        ]))
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
