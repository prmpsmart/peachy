import 'package:flutter/material.dart';
import 'package:peachy/constants.dart' as constants;

import 'package:peachy/widgets/profile_dialog.dart';

class AudioChat extends StatefulWidget {
  final constants.Message message;
  final bool isMe;
  const AudioChat(this.message, this.isMe);

  @override
  _AudioChatState createState() => _AudioChatState();
}

class _AudioChatState extends State<AudioChat> {
  bool pause = true;
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Slider slider = Slider(
        activeColor: widget.isMe
            ? Theme.of(context).accentColor
            : Theme.of(context).primaryColor,
        divisions: 4,
        value: sliderValue,
        max: 100,
        label: '$sliderValue %',
        onChanged: (newValue) {
          setState(() {
            sliderValue = newValue;
            // print(newValue);
          });
        });

    return SizedBox(
      height: 35,
      width: 228,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: Material(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(17.5),
              color:
                  widget.isMe ? themeData.accentColor : themeData.primaryColor,
              child: InkResponse(
                onTap: () {
                  setState(() {
                    if (pause)
                      pause = false;
                    else
                      pause = true;
                  });
                },
                splashColor: widget.isMe
                    ? themeData.primaryColor.withOpacity(.5)
                    : themeData.accentColor.withOpacity(.5),
                child: Icon(
                  pause ? Icons.play_arrow : Icons.pause,
                  size: 20,
                  color: widget.isMe
                      ? themeData.primaryColor
                      : themeData.accentColor,
                ),
              ),
            ),
          ),
          slider
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final constants.User client;
  final constants.User user;

  ChatScreen({this.client, this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool inText = false;

  Widget _buildMessage(
      constants.Message lastMessage, constants.Message message, bool isMe) {
    bool sameAsLast = lastMessage?.sender == message.sender;
    double offset = MediaQuery.of(context).size.width * .20;

    double top = 8;
    if (sameAsLast) {
      top = 1;
    }

    ThemeData themeData = Theme.of(context);

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
                      ? themeData.primaryColor.withOpacity(.5)
                      : themeData.primaryColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isMe && widget.user.type == 2)
                    Text(
                      message.sender.name,
                      style: TextStyle(
                          // color: isMe ? Colors.white : Colors.blueGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  if (!isMe && widget.user.type == 2)
                    SizedBox(
                      height: 4,
                    ),
                  if (message.type == 'image')
                    Image.asset('assets/ic_male_ph.jpg', fit: BoxFit.scaleDown),
                  if (message.type == 'audio') AudioChat(message, isMe),
                  Text(
                    message.text,
                    style: TextStyle(
                        // color: isMe ? Colors.white : Colors.blueGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 2),
                    alignment: Alignment.bottomRight,
                    width: isMe ? 48 : 36,
                    child: Align(
                      alignment: Alignment.centerRight,
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
                                  color: Colors.grey.shade800,
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
                                color: Colors.grey.shade800,
                              )
                          ]),
                    ),
                  ),
                ],
              )),
        )
      ],
    );

    return msg;
  }

  Widget _buildMessageComposer() {
    var sendButton = IconButton(
      constraints: BoxConstraints(),
      icon: Icon(inText ? Icons.send : Icons.mic),
      iconSize: 30,
      onPressed: () {},
      color: Theme.of(context).primaryColor,
    );
    var cameraButton = IconButton(
      constraints: BoxConstraints(),
      icon: Icon(Icons.camera_alt_outlined),
      iconSize: 25,
      color: Theme.of(context).primaryColor,
      onPressed: () {},
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.only(bottom: 7, top: 7),
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 2.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  IconButton(
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.emoji_emotions_outlined),
                    iconSize: 25,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            inText = true;
                          });
                        } else {
                          setState(() {
                            inText = false;
                          });
                        }
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type your message...',
                        hoverColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  IconButton(
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.add_link),
                    iconSize: 25,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {},
                  ),
                  if (!inText) cameraButton,
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: sendButton,
          ),
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
        title: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ProfileDialog(widget.user),
            );
          },
          child: Row(children: [
            Column(
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
                )
              ],
            ),
          ]),
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
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: ListView.builder(
                      // reverse: true,
                      padding: EdgeInsets.only(bottom: 10),
                      itemCount: widget.user.msgs.length,
                      itemBuilder: (BuildContext context, int index) {
                        constants.Message lastMessage;
                        if (index > 0) {
                          lastMessage = widget.user.msgs[index - 1];
                        }
                        final constants.Message message =
                            widget.user.msgs[index];
                        final bool isMe = message.sender.id == widget.client.id;

                        return _buildMessage(lastMessage, message, isMe);
                      }),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
