import 'package:flutter/material.dart';
import 'package:peachy/constants.dart';
import 'package:peachy/widgets/data.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  ChatScreen({this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Widget _buildMessage(Message lastMessage, Message message, bool isMe) {
    bool sameAsLast = lastMessage?.sender == message.sender;
    double offset = MediaQuery.of(context).size.width * .25;
    // offset = 80;

    double top = 8;
    if (sameAsLast) {
      top = 1;
    }

    final msg = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: isMe
                  ? EdgeInsets.only(
                      top: top,
                      right: 15,
                      left: offset,
                    )
                  : EdgeInsets.only(
                      top: top,
                      left: 15,
                      right: offset,
                    ),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: isMe
                      ? Theme.of(
                          context,
                        ).accentColor.withOpacity(1)
                      : Theme.of(
                          context,
                        ).primaryColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                        // color: isMe ? Colors.white : Colors.blueGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 2),
                    alignment: Alignment.bottomRight,
                    width: isMe ? 48 : 36,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              message.time,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          if (isMe)
                            SizedBox(
                              width: 2,
                            ),
                          if (isMe)
                            Icon(
                              message.sent
                                  ? Icons.check_circle_outline
                                  : Icons.history,
                              size: 10,
                              color: Colors.grey,
                            )
                        ]),
                  ),
                ],
              )),
        )
      ],
    );

    return msg;
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
              child: TextField(
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) {},
            decoration:
                InputDecoration.collapsed(hintText: 'Send a amessage...'),
          )),
          IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              color: Theme.of(context).primaryColor,
              onPressed: () {}),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        toolbarHeight: 45,
        elevation: 0,
        // leading: Row(children: [
        //   IconButton(
        //     icon: Icon(Icons.arrow_back, size: 10, color: Colors.white),
        //     onPressed: null,
        //   ),
        //   Icon(Icons.account_circle_outlined, size: 10)
        // ]),
        title: Material(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).primaryColor,
          child: InkWell(
            onTap: () {},
            splashColor: Theme.of(context).accentColor,
            highlightColor: Theme.of(context).primaryColor.withOpacity(.7),
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.user.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.blueGrey[100],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            constraints: BoxConstraints(),
            icon: Icon(Icons.call),
            iconSize: 25,
            color: Colors.white,
            onPressed: () => print('Make Voice Call'),
            tooltip: 'Make Voice Call',
          ),
          IconButton(
            constraints: BoxConstraints(),
            icon: Icon(Icons.video_call),
            iconSize: 25,
            color: Colors.white,
            onPressed: () => print('Make Video Call'),
            tooltip: 'Make Video Call',
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            constraints: BoxConstraints(),
            iconSize: 25,
            color: Colors.white,
            onPressed: () => print('More Actions'),
            tooltip: 'More Actions',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: ListView.builder(
                      // reverse: true,
                      padding: EdgeInsets.only(top: 0),
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        Message lastMessage;
                        if (index > 0) {
                          lastMessage = messages[index - 1];
                        }
                        final Message message = messages[index];
                        final bool isMe = message.sender.id == currentUser.id;
                        return _buildMessage(lastMessage, message, isMe);
                      }),
                ),
              ),
            ),
            _buildMessageComposer()
          ],
        ),
      ),
    );
  }
}
