// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';

import 'package:peachy/backend/client.dart';
import 'package:peachy/backend/utils.dart';

import '../dialogs/image_dialogs.dart';
import '../ui_utils.dart';
import '../dialogs/profile_dialog.dart';
import '../dialogs/camera.dart';

class AudioType extends P_StatefulWidget {
  final Tag tag;
  final bool isMe;
  const AudioType(this.tag, this.isMe);

  @override
  _AudioTypeState createState() => _AudioTypeState();
}

class _AudioTypeState extends P_StatefulWidgetState<AudioType> {
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
          setState(() => sliderValue = newValue);
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
              color: widget.isMe
                  ? themeData.colorScheme.secondary
                  : themeData.primaryColor,
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

class ChatHeader extends AppBar {
  ChatHeader(BuildContext context, chat_object, String status, double fontSize,
      Client client, GlobalKey<ScaffoldState> key, bool online)
      : super(
          toolbarHeight: 45,
          elevation: 0,
          leadingWidth: 70,
          leading: Container(
            margin: EdgeInsets.all(3),
            child: RawMaterialButton(
              onPressed: () => Navigator.pop(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
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
                builder: (context) => ProfileDialog(chat_object, client),
              );
            },
            child: Row(children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chat_object.get_name(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    if (chat_object.type == 1)
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.normal,
                          color: online ? Colors.white : Colors.blueGrey[100],
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
              icon: Icon(Icons.more_vert),
              constraints: BoxConstraints(),
              iconSize: 25,
              color: Colors.white,
              onPressed: () {
                if (key.currentState != null) key.currentState!.openEndDrawer();
              },
              tooltip: 'More Actions',
            ),
          ],
        );
}

class MessageType extends P_StatefulWidget {
  Tag tag;
  MessageType(this.tag);

  @override
  _MessageTypeState createState() => _MessageTypeState();
}

class _MessageTypeState extends P_StatefulWidgetState<MessageType> {
  @override
  Widget build(BuildContext context) {
    return Row();
  }
}

class TextType extends Text {
  TextType(Tag tag)
      : super(tag['text'],
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400));
}

class ImageType extends MessageType {
  ImageType(Tag tag) : super(tag);

  @override
  _ImageTypeState createState() => _ImageTypeState();
}

class _ImageTypeState extends _MessageTypeState {
  @override
  Widget build(BuildContext context) {
    String image_string = widget.tag['data'] ?? '';
    String text = widget.tag['text'] ?? '';

    var image;

    if (image_string.isNotEmpty) {
      List<int> image_bytes = B64_DECODE(image_string);
      image = Image.memory(Uint8List.fromList(image_bytes));
    }
    bool isFront = widget.tag['isFront'] ?? false;

    return Column(
      children: [
        if (image != null)
          isFront ? RotatedBox(quarterTurns: 2, child: image) : image,
        SizedBox(height: 5),
        if (text.isNotEmpty) TextType(widget.tag),
      ],
    );
  }
}

class VideoType extends MessageType {
  VideoType(Tag tag) : super(tag);

  @override
  _MessageTypeState createState() => _VideoTypeState();
}

class _VideoTypeState extends _MessageTypeState {
  @override
  Widget build(BuildContext context) {
    return Row();
  }
}

class ChatMessage extends P_StatefulWidget {
  ChatScreen chatScreen;
  late Padding date_time_widget;
  late Widget messageWidget;
  late bool isMe;
  late Tag tag;
  Tag? lastTag;
  bool sameAsLast = false;
  Function screen_setState;

  ChatMessage(this.chatScreen, int index, this.screen_setState, {key})
      : super(key: key) {
    if (index > 0) lastTag = chat_object.chats[index - 1];

    tag = chat_object!.chats[index];
    isMe = tag['sender'] == user.id;

    String date_time = DATE_AND_TIME(tag.get_date_time());
    if (lastTag != null) sameAsLast = lastTag!['sender'] == tag['sender'];

    var chat = tag['chat'];

    if (CHAT['TEXT'] == chat)
      messageWidget = TextType(tag);
    else if (CHAT['IMAGE'] == chat)
      messageWidget = ImageType(tag);
    else if (CHAT['AUDIO'] == chat)
      messageWidget = AudioType(tag, isMe);
    else if (CHAT['VIDEO'] == chat) messageWidget = VideoType(tag);

    date_time_widget = Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Text(
        date_time,
        textAlign: TextAlign.end,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  User get user => chatScreen.user;
  get chat_object => chatScreen.chat_object;

  @override
  ChatMessageState createState() => ChatMessageState();
}

class ChatMessageState extends P_StatefulWidgetState<ChatMessage> {
  dynamic get chat_object => widget.chatScreen.chat_object;

  @override
  Widget build(BuildContext context) {
    if (!(widget.tag['seen'] ?? false)) widget.user.chat_seen(widget.tag);

    double top = 10;
    var themeData = Theme.of(context);

    var offset = MediaQuery.of(context).size.width * .15;

    EdgeInsets margin;
    Color color;
    MainAxisAlignment mainAxisAlignment;
    BorderRadius borderRadius;

    if (chat_object.type == 3) {
      mainAxisAlignment = MainAxisAlignment.center;
      margin = EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
      );
      color = themeData.primaryColor.withOpacity(.2);
      borderRadius = BorderRadius.circular(10);
    } else {
      Radius topLeft;
      Radius topRight;
      if (widget.isMe) {
        mainAxisAlignment = MainAxisAlignment.end;
        margin = EdgeInsets.only(
          top: top,
          right: 15,
          left: offset,
        );
        color = themeData.primaryColor.withOpacity(.6);
        topLeft = Radius.circular(10);
        topRight = Radius.circular(0);
      } else {
        mainAxisAlignment = MainAxisAlignment.start;
        margin = EdgeInsets.only(
          top: top,
          left: chat_object.type == 2 ? 5 : 15,
          right: offset,
        );
        color = themeData.primaryColor.withOpacity(.2);
        topLeft = Radius.circular(0);
        topRight = Radius.circular(10);
      }
      borderRadius = BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topLeft: topLeft,
          bottomRight: Radius.circular(10),
          topRight: topRight);
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.tag['text'] != null)
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: borderRadius,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.tag['text']),
                            widget.date_time_widget
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            child: Text('Copy'),
                          ),
                          if (widget.isMe)
                            MaterialButton(
                              onPressed: () {
                                var tag = Tag(widget.tag.dict);

                                tag['id'] = null;
                                tag['sent'] = false;
                                tag['seen'] = false;
                                tag['date_time'] = DATETIME();

                                Client.activeClient?.send_chat_tag(tag);

                                widget.screen_setState();
                                Navigator.pop(context);
                              },
                              child: Text('Resend'),
                            ),
                          MaterialButton(
                            onPressed: () {},
                            child: Text('Forward'),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.chat_object.remove_chat(widget.tag['id']);
                              widget.screen_setState();
                              Navigator.pop(context);
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        );
      },
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Flexible(
              child: Container(
                  margin: margin,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: borderRadius,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: chat_object.type == 3
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.end,
                    children: [
                      if (!widget.isMe &&
                          (chat_object.type == 2) &&
                          !widget.sameAsLast)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.tag['sender'],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      widget.messageWidget,
                      Container(
                        padding: EdgeInsets.only(top: 2),
                        width: widget.isMe ? 125 : 115,
                        child: Row(children: [
                          widget.date_time_widget,
                          if (widget.isMe)
                            SizedBox(
                              width: 2,
                            ),
                          if (widget.isMe)
                            Icon(
                              widget.tag['sent'] ?? false
                                  ? Icons.check_circle_outline
                                  : Icons.history,
                              size: 10,
                              color: Colors.grey.shade800,
                            )
                        ]),
                      ),
                    ],
                  )),
            )
          ]),
    );
  }
}

class ChatMenu extends P_StatefulWidget {
  final _ChatScreenState chatScreenState;
  const ChatMenu(this.chatScreenState) : super();

  @override
  _ChatMenuState createState() => _ChatMenuState();
}

class _ChatMenuState extends P_StatefulWidgetState<ChatMenu> {
  dynamic get chat_object => widget.chatScreenState.widget.chat_object;

  @override
  Widget build(BuildContext context) {
    String name = '';
    if (chat_object is Contact)
      name = 'Contact';
    else if (chat_object is Group)
      name = 'Group';
    else if (chat_object is Channel) name = 'Channel';

    return Container(
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MaterialButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => ProfileDialog(
                      widget.chatScreenState.chat_object,
                      widget.chatScreenState.widget.client));
            },
            child: Text('Info'),
          ),
          MaterialButton(
            onPressed: () {
              List chats = List.from(chat_object.chats);
              for (Tag chat in chats) chat_object.remove_chat(chat['id']);
              widget.chatScreenState.setState(() {});
            },
            child: Text('Clear Chats'),
          ),
          TextButton(
            onPressed: () {
              Client.activeClient?.send_action_tag(Tag({}));
            },
            child: Text('Delete $name'),
          ),
          TextButton(
            onPressed: () {
              Client.activeClient?.send_action_tag(Tag({}));
            },
            child: Text('Block $name'),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends P_StatefulWidget {
  final Client client;
  final chat_object;

  var textCont = TextEditingController();

  List<Tag> get chats => chat_object.chats as List<Tag>;

  User get user => chat_object.user;
  ChatScreen(this.chat_object, this.client);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends P_StatefulWidgetState<ChatScreen> {
  bool inText = false;
  var scroller = ScrollController();
  TextEditingController get textCont => widget.textCont;
  late ListView chats;
  final lastKey = GlobalKey();
  bool newMessage = false;

  final key = GlobalKey<ScaffoldState>();
  late ChatMenu chatMenu;

  void listener() {
    var tag = Client.RECV_LOG.value;
    if (ACTION['CHAT'] == tag['action']) newMessage = true;
    setState(() {});
  }

  @override
  void initState() {
    chatMenu = ChatMenu(this);
    Client.RECV_LOG.addListener(listener);
    super.initState();
  }

  void scrollDown() {
    // if (lastKey.currentContext != null)
    //   Scrollable.ensureVisible(lastKey.currentContext!,
    //       duration: Duration(milliseconds: 500), alignment: 1);
    scroller.animateTo(scroller.position.maxScrollExtent,
        duration: Duration(microseconds: 200),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  User get user => widget.user;
  get chat_object => widget.chat_object;

  List get hasFooter {
    String text = '';
    bool? hide = false;

    if (chat_object is Group || chat_object is Channel) {
      if (!chat_object.users.contains(user.id)) {
        text = 'YOU WERE REMOVED';
        hide = true;
      } else if (chat_object.admins.contains(user.id))
        hide = false;
      else if (chat_object.only_admin) {
        hide = true;
        text = 'ONLY ADMIN';
        if (chat_object is Channel) hide = null;
      }
    }
    return [hide, text];
  }

  Widget _buildMessageComposer() {
    var cameraButton = IconButton(
      constraints: BoxConstraints(),
      icon: Icon(Icons.camera_alt_outlined),
      iconSize: 25,
      color: Theme.of(context).primaryColor,
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext builder) => CameraDialog(set_imageBytes)),
    );

    var sendButton = IconButton(
      constraints: BoxConstraints(),
      icon: Icon(inText ? Icons.send : Icons.mic),
      iconSize: 30,
      onPressed: () {
        String text = textCont.text;
        String istext = text.replaceAll(' ', '');

        setState(() {
          String chat = imageBytes.length > 0 ? 'IMAGE' : 'TEXT';

          if (istext.isNotEmpty) {
            Tag tag = Tag({
              'text': text,
              'action': CHAT,
              'chat': CHAT[chat],
              'sender': widget.user.id,
              'recipient': chat_object.id,
              'type': GET_TYPE(chat_object),
              if (imageBytes.length > 0) 'data': B64_ENCODE(imageBytes)
            });
            widget.client.send_chat_tag(tag);
          }
          inText = false;
          textCont.text = '';
        });
        scrollDown();
      },
      color: Theme.of(context).primaryColor,
    );

    var composer = Row(
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
                        if (!inText)
                          setState(() {
                            inText = true;
                          });
                      } else {
                        if (inText)
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
    );
    dynamic widget_ = composer;

    if (chat_object is Group || chat_object is Channel) {
      var hasFooter_ = hasFooter;
      bool? hide = hasFooter_[0];
      String text = hasFooter_[1];
      if (hide == null)
        widget_ = SizedBox(
          height: 0,
        );
      else if (hide == true)
        widget_ = Text(text,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w400));
      else if (hide == false) widget_ = composer;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.only(bottom: 7, top: 7),
      color: Colors.transparent,
      child: widget_,
    );
  }

  List<int> imageBytes = [];

  Future<void> set_imageBytes(
      CameraImage image, bool isFront, BuildContext context) async {
    var imageBytes = await Camera.yuv_transform(image);
    this.imageBytes = imageBytes.toList();

    Navigator.pop(context);

    showDialog(
        context: this.context,
        builder: (context) => PreviewSendImage(imageBytes, isFront, this));
  }

  @override
  Widget build(BuildContext context) {
    String status = 'OFFLINE';
    double fontSize = 13;
    bool online = false;

    if (chat_object.type == 1) {
      var contact = chat_object as Contact;
      dynamic _status = contact.current_status;
      if (widget.client.online && STATUS["ONLINE"] == _status) {
        status = 'ONLINE';
        online = true;
      } else if (contact.last_seen != null) {
        if (_status is String) _status = DATETIME();
        status = OFFLINE_FORMAT(_status);
        fontSize = 9;
      }
    }

    chats = ListView.builder(
      padding: EdgeInsets.only(bottom: 10),
      controller: scroller,
      itemCount: widget.chats.length,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (BuildContext context, int index) {
        return ChatMessage(
          widget,
          index,
          () => setState(() {}),
          key: widget.chats.length == index + 1 ? lastKey : null,
        );
      },
    );

    Timer(Duration(milliseconds: 300), scrollDown);

    return Scaffold(
      key: key,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: ChatHeader(
          context, chat_object, status, fontSize, widget.client, key, online),
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
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      chats,
                      if (newMessage)
                        IconButton(
                          splashColor: Theme.of(context).primaryColor,
                          color: Theme.of(context).primaryColor,
                          icon: Icon(Icons.arrow_drop_down_circle_outlined),
                          onPressed: () {
                            newMessage = false;
                            setState(() {});
                            scrollDown();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (hasFooter[0] != null) _buildMessageComposer(),
          ],
        ),
      ),
      endDrawer: chatMenu,
    );
  }

  @override
  void dispose() {
    Client.RECV_LOG.removeListener(listener);
    super.dispose();
  }
}
