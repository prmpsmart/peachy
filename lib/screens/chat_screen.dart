import 'dart:async';
import 'package:flutter/material.dart';
import '../dialogs/profile_dialog.dart';
import '../backend/client.dart' as _client;
import '../backend/core.dart' as _core;

class AudioChat extends StatefulWidget {
  final _core.Tag message;
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
            ? Theme.of(context).colorScheme.secondary
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
                  widget.isMe ? themeData.colorScheme.secondary : themeData.primaryColor,
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
                    : themeData.colorScheme.secondary.withOpacity(.5),
                child: Icon(
                  pause ? Icons.play_arrow : Icons.pause,
                  size: 20,
                  color: widget.isMe
                      ? themeData.primaryColor
                      : themeData.colorScheme.secondary,
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
  final _client.User? ownUser;
  final _client.User? user;

  ChatScreen({this.ownUser, this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool inText = false;
  var textCont = TextEditingController();
  var scroller = ScrollController();

  Widget _buildMessage(_core.Tag lastMessage, _core.Tag message, bool isMe) {
    bool sameAsLast = lastMessage['sender'] == message['sender'];
    double offset = MediaQuery.of(context).size.width * .15;

    double top = 10;
    if (sameAsLast) {
      top = 1;
    }

    ThemeData themeData = Theme.of(context);

    var messageWidget = Flexible(
      child: Container(
        margin: isMe
            ? EdgeInsets.only(
                top: top,
                right: 15,
                left: offset,
              )
            : EdgeInsets.only(
                top: top,
                left: widget.user!.type == 2 ? 5 : 15,
                right: offset,
              ),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isMe
              ? themeData.primaryColor.withOpacity(.5)
              : themeData.primaryColor.withOpacity(.2),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18),
            topLeft: isMe ? Radius.circular(18) : Radius.circular(0),
            bottomRight: Radius.circular(18),
            topRight: isMe ? Radius.circular(0) : Radius.circular(18),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe && (widget.user!.type == 2) && !sameAsLast)
              Text(
                message['sender'],
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            if (!isMe && widget.user!.type == 2)
              SizedBox(
                height: 4,
              ),
            if (message['chat'] == _core.CHAT['image'])
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    topLeft: isMe ? Radius.circular(18) : Radius.circular(0),
                    bottomRight: Radius.circular(18),
                    topRight: isMe ? Radius.circular(0) : Radius.circular(18),
                  ),
                  child: Image.asset('assets/ic_male_ph.jpg',
                      fit: BoxFit.scaleDown),
                ),
              ),
            if (message['chat'] == _core.CHAT['audio'])
              AudioChat(message, isMe),
            if (message['chat'] == _core.CHAT['audio']) SizedBox(height: 2),
            Text(
              message['text'],
              style: TextStyle(
                  fontFamily: 'Times New Roman',
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
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          message.get_date_time(),
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
                          message['sent']
                              ? Icons.check_circle_outline
                              : Icons.history,
                          size: 10,
                          color: Colors.grey.shade800,
                        )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );

    final msg = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMe
            ? messageWidget
            : Flexible(
                child: Row(children: [
                  if (widget.user!.type == 2)
                    Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.only(left: 5, top: 0),
                      decoration: BoxDecoration(
                          color: sameAsLast
                              ? Colors.transparent
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(25)),
                      child: RawMaterialButton(
                          constraints: BoxConstraints(),
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) =>
                                  ProfileDialog(widget.user!, widget.ownUser!)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child:
                              Icon(sameAsLast ? null : Icons.person, size: 40)),
                    ),
                  messageWidget
                ]),
              )
      ],
    );

    return msg;
  }

  Widget _buildChannel(_core.Tag message) {
    ThemeData themeData = Theme.of(context);

    var messageWidget = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 10,
            left: 15,
            right: 15,
          ),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: themeData.primaryColor.withOpacity(.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (message['CHAT'] == _core.CHAT['image'])
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset('assets/ic_male_ph.jpg',
                        fit: BoxFit.scaleDown),
                  ),
                ),
              if (message['CHAT'] == _core.CHAT['audio'])
                AudioChat(message, false),
              if (message['CHAT'] == _core.CHAT['audio']) SizedBox(height: 2),
              Text(
                message['text'],
                style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
              Container(
                padding: EdgeInsets.only(top: 2),
                alignment: Alignment.bottomRight,
                width: 36,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            message.get_date_time(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return messageWidget;
  }

  Widget _buildMessageComposer() {
    var sendButton = IconButton(
      constraints: BoxConstraints(),
      icon: Icon(inText ? Icons.send : Icons.mic),
      iconSize: 30,
      onPressed: () {
        String text = textCont.text;
        String istext = text.replaceAll(' ', '');

        if (istext.isNotEmpty) {
          _core.Tag message = _core.Tag({
            'text': text,
            'sender': widget.ownUser!,
            'time': '5:18 AM',
            'sent': false,
          });
          widget.user!.chats.add(message);
        }
        inText = false;
        textCont.text = '';
        setState(() {});

        Timer(Duration(microseconds: 200), () {
          scroller.animateTo(scroller.position.maxScrollExtent + 100,
              duration: Duration(seconds: 1),
              curve: Curves.fastLinearToSlowEaseIn);
        });
      },
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
        children: [
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
                      controller: textCont,
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
        leadingWidth: 70,
        leading: Container(
          margin: EdgeInsets.all(3),
          child: RawMaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Row(children: [
              Icon(Icons.arrow_back, size: 25, color: Colors.white),
              Icon(Icons.person, size: 35, color: Colors.white)
            ]),
          ),
        ),
        title: MaterialButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  ProfileDialog(widget.user!, widget.ownUser!),
            );
          },
          child: Row(children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.user!.name,
                      overflow: TextOverflow.ellipsis,
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
            ),
          ]),
        ),
        actions: <Widget>[
          IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.call,
              size: 25,
              color: Colors.white,
            ),
            onPressed: () => print('Make Voice Call'),
            tooltip: 'Make Voice Call',
          ),
          IconButton(
            splashRadius: 20,
            constraints: BoxConstraints(),
            icon: Icon(Icons.video_call),
            iconSize: 25,
            color: Colors.white,
            onPressed: () => print('Make Video Call'),
            tooltip: 'Make Video Call',
          ),
          IconButton(
            splashRadius: 20,
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
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: ListView.builder(
                      controller: scroller,
                      padding: EdgeInsets.only(bottom: 10),
                      itemCount: widget.user!.chats.length,
                      itemBuilder: (BuildContext context, int index) {
                        _core.Tag? lastMessage;
                        if (index > 0) {
                          lastMessage = widget.user!.chats[index - 1];
                        }
                        final _core.Tag message = widget.user!.chats[index];
                        final bool isMe =
                            message['sender'].id == widget.ownUser!.id;
                        if (widget.user!.type == 3)
                          return _buildChannel(message);
                        return _buildMessage(lastMessage!, message, isMe);
                      }),
                ),
              ),
            ),
            if (widget.user!.type != 3) _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
