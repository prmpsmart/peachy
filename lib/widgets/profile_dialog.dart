// ignore_for_file: camel_case_types
// ignore_for_file: must_be_immutable


import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/chat_screen.dart';
import '../backend/client.dart' as _client;
import '../backend/core.dart' as _core;

SizedBox iconButton(
    IconData icon, void Function()? function, BuildContext context) {
  return SizedBox(
    height: 35,
    width: 35,
    child: Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(17.5),
      color: Theme.of(context).primaryColor,
      child: ElevatedButton(
        onPressed: function,
        child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
      ),
    ),
  );
}

RawMaterialButton switchIconButton(
    IconData icon, Function function, BuildContext context,
    {double wid = 25, double size = 20}) {
  var btn = RawMaterialButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
    constraints: BoxConstraints(minWidth: wid, minHeight: wid),
    child: Icon(
      icon,
      size: size,
      color: Theme.of(context).colorScheme.secondary,
    ),
    fillColor: Theme.of(context).primaryColor,
    onPressed: () => function(),
  );
  return btn;
}

class ContentTabView extends StatefulWidget {
  _core.p_User_Base user;
  _client.User ownUser;
  bool member;

  ContentTabView(this.user, this.ownUser, {this.member = false});

  @override
  Content_TabViewState createState() => Content_TabViewState();
}

class Content_TabViewState extends State<ContentTabView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.ownUser.users?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            _client.User? user = widget.ownUser.users?[index];
            _core.Tag? message = user!.chats[index + 4];

            String name = user.name;
            String text = message['text'];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(ownUser: widget.ownUser, user: user),
                    ));
              },
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                child: Column(
                  children: [
                    // Divider(height: 2.0),
                    Row(
                      children: [
                        switchIconButton(Icons.person, () {}, context,
                            wid: 35, size: 20),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(name,
                                      style: TextStyle(
                                          color: Colors.black.withRed(80),
                                          fontWeight: FontWeight.bold)),
                                  if (message['sent'] && widget.member)
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      margin: EdgeInsets.only(right: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        'Admin',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  if (!widget.member)
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      margin: EdgeInsets.only(right: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        user.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  if (!widget.member)
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
                                    child: Text(text,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10)),
                                  ),
                                  if (!widget.member)
                                    Text(
                                      message.get_date_time(),
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 10),
                                    )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class ProfileDialog extends StatefulWidget {
  _core.p_User_Base user;
  _client.User ownUser;

  ProfileDialog(this.user, this.ownUser);

  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
        vsync: this, initialIndex: 0, length: widget.user.type == 1 ? 3 : 4);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  build(BuildContext context) {
    double padding = 10;
    double radius = 45;
    double iconSize = 23;

    String type;
    switch (widget.user.type) {
      case 1:
        {
          type = 'Contact';
          break;
        }
      case 2:
        {
          type = 'Group';
          break;
        }
      case 3:
      default:
        {
          type = 'Channel';
          break;
        }
    }

    var tabs = [
      if (widget.user.type != 1)
        Tab(
            icon: Icon(Icons.person_search),
            child: Text('Members',
                style: TextStyle(fontSize: 10, fontFamily: 'Times New Roman'))),
      Tab(
          icon: Icon(Icons.file_copy_outlined),
          child: Text('Media',
              style: TextStyle(fontSize: 10, fontFamily: 'Times New Roman'))),
      Tab(
          icon: Icon(Icons.computer),
          child: Text('Docs',
              style: TextStyle(fontSize: 10, fontFamily: 'Times New Roman'))),
      Tab(
          icon: Icon(Icons.link_sharp),
          child: Text('Links',
              style: TextStyle(fontSize: 10, fontFamily: 'Times New Roman')))
    ];

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: padding,
                top: padding + radius,
                bottom: padding,
                right: padding),
            margin: EdgeInsets.only(top: radius),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(padding),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Apata Miracle Peter',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Id : ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          // backgroundColor: Theme.of(context).primaryColor,
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'prmpsmart',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Theme.of(context).primaryColor,
                        // backgroundColor: Colors.yellow,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(height: 5),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Tooltip(
                        message: 'Chat',
                        child: TextButton(
                          child: Icon(
                            Icons.chat_outlined,
                            size: iconSize,
                          ),
                          onPressed: () => print('Chat'),
                        ),
                      ),
                      Tooltip(
                        message: 'Video Call',
                        child: TextButton(
                          child: Icon(
                            Icons.video_call_outlined,
                            size: iconSize + 10,
                          ),
                          onPressed: () => print('Video call'),
                        ),
                      ),
                      Tooltip(
                        message: 'Voice Call',
                        child: TextButton(
                          child: Icon(
                            Icons.call,
                            size: iconSize - 2,
                          ),
                          onPressed: () => print('Voice call'),
                        ),
                      ),
                      Tooltip(
                        message: 'Info',
                        child: TextButton(
                          child: Icon(
                            Icons.info_outline_rounded,
                            size: iconSize + 3,
                          ),
                          onPressed: () => print('Info'),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 5),
                Column(
                  children: [
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue),
                      child: TabBar(
                        tabs: tabs,
                        indicatorWeight: 5,
                        indicatorColor: Colors.white,
                        controller: _tabController,
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 300,
                      child: TabBarView(controller: _tabController, children: [
                        if (widget.user.type != 1)
                          ContentTabView(
                            widget.user,
                            widget.ownUser,
                            member: true,
                          ),
                        ContentTabView(widget.user, widget.ownUser),
                        ContentTabView(widget.user, widget.ownUser),
                        ContentTabView(widget.user, widget.ownUser)
                      ]),
                    )
                  ],
                ),
                Divider(height: 5),
                SizedBox(height: 5),
                iconNButton('Block', Icons.block),
                SizedBox(height: 5),
                iconNButton('Report $type', Icons.thumb_down_sharp),
              ],
            ),
          ),
          Positioned(
              left: padding,
              right: padding,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                radius: radius,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Image.asset("assets/ic_male_ph.jpg"),
                ),
              ))
        ],
      ),
    );
  }
}

class ClientProfileDialog extends StatefulWidget {
  _client.User user;

  ClientProfileDialog(this.user);

  @override
  _ClientProfileDialogState createState() => _ClientProfileDialogState();
}

class _ClientProfileDialogState extends State<ClientProfileDialog> {
  bool nameBool = false;
  bool idBool = false;
  bool keyBool = false;

  IconData editIcon = Icons.edit;
  IconData saveIcon = Icons.save;

  TextEditingController nameTC = TextEditingController();
  TextEditingController idTC = TextEditingController();
  TextEditingController keyTC = TextEditingController();

  @override
  build(BuildContext context) {
    double padding = 10;
    double radius = 45;

    String name = widget.user.name ;
    String id = widget.user.id ;
    String key = widget.user.key ;

    nameTC.text = name;
    idTC.text = id;
    keyTC.text = key;

    getTextWidget(
            String text, TextEditingController cont, bool b, FontWeight fw) =>
        b
            ? Expanded(
                child: TextField(
                  controller: cont,
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    // color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: fw,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: fw,
                ),
              );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
                padding, padding + radius, padding, padding),
            margin: EdgeInsets.only(top: radius),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(padding),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        // width: 80,
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Username : ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 13,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      getTextWidget(name, nameTC, nameBool, FontWeight.bold),
                      SizedBox(
                          height: 25,
                          child: switchIconButton(
                              nameBool ? saveIcon : editIcon, () {
                            setState(() {
                              if (nameBool) {
                                nameBool = false;
                                widget.user.name = nameTC.text;
                              } else
                                nameBool = true;
                            });
                          }, context))
                    ],
                  ),
                ),
                Divider(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Id : ',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            // backgroundColor: Theme.of(context).primaryColor,
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      getTextWidget(id, idTC, idBool, FontWeight.w600),
                      SizedBox(
                          height: 25,
                          child: switchIconButton(idBool ? saveIcon : editIcon,
                              () {
                            setState(() {
                              if (idBool) {
                                idBool = false;
                                id = idTC.text;
                              } else
                                idBool = true;
                            });
                          }, context))
                    ],
                  ),
                ),
                Divider(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Key : ',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            // backgroundColor: Theme.of(context).primaryColor,
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      getTextWidget(key, keyTC, keyBool, FontWeight.w600),
                      SizedBox(
                          height: 25,
                          child: switchIconButton(keyBool ? saveIcon : editIcon,
                              () {
                            setState(() {
                              if (keyBool) {
                                keyBool = false;
                                key = keyTC.text;
                              } else
                                keyBool = true;
                            });
                          }, context))
                    ],
                  ),
                ),
                Divider(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: iconNButton('Change User', Icons.person,
                      func: () => Navigator.pushReplacementNamed(
                          context, '/createUser')),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: iconNButton('Settings', Icons.settings,
                      func: () => print('Settings')),
                ),
              ],
            ),
          ),
          Positioned(
              left: padding,
              right: padding,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                radius: radius,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Image.asset("assets/ic_male_ph.jpg"),
                ),
              ))
        ],
      ),
    );
  }
}
