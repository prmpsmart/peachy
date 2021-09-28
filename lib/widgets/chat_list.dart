import 'package:flutter/material.dart';
import 'data.dart';
import 'chat.dart';

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

            return Column(
              children: <Widget>[
                Divider(
                  height: 0.0,
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 27,
                    foregroundColor: Theme.of(context).primaryColor,
                    // backgroundColor: Colors.grey,
                    backgroundImage: null,
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
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
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
                        Text(
                          time,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        )
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
