import 'package:flutter/material.dart';
import 'package:peachy/backend/client.dart';
import 'package:peachy/backend/constants.dart';
import 'package:peachy/backend/tag.dart';
import 'package:peachy/backend/user.dart';

import '../ui_utils.dart';

class NewChatObject extends P_StatefulWidget {
  final int type;
  final Client client;

  User get user => client.user as User;

  const NewChatObject(this.client, this.type) : super();

  @override
  NewChatObjectState createState() => NewChatObjectState();
}

class NewChatObjectState extends P_StatefulWidgetState<NewChatObject> {
  bool isNew = false;

  late TextEditingController nameTC;
  late TextEditingController idTC;
  late TextEditingController bioTC;

  @override
  void initState() {
    nameTC = TextEditingController();
    idTC = TextEditingController();
    bioTC = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IconData icon, icon2;
    String text;

    switch (widget.type) {
      case 1:
        icon = Icons.person;
        icon2 = Icons.person_add;
        text = 'Contact';
        break;
      case 2:
        icon = Icons.group;
        icon2 = Icons.group_add;
        text = 'Group';
        break;
      default:
        icon = Icons.notifications;
        icon2 = Icons.notification_add;
        text = 'Channel';
        break;
    }

    Padding getInput(TextEditingController tc, String text_, IconData icon) =>
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
          child: CustomTextInput(
            controller: tc,
            hintText: 'Enter $text $text_',
            leading: icon,
            radius: 10,
            maxLines: text_ == 'Bio' ? 3 : 1,
          ),
        );

    return Container(
      width: 250,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isNew) getInput(nameTC, 'Name', Icons.person_pin),
          getInput(idTC, 'ID', icon),
          if (isNew) getInput(bioTC, 'Bio', Icons.textsms_outlined),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: widget.type != 1
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                if (widget.type != 1)
                  iconNButton('New', Icons.new_label_outlined, func: () {
                    isNew = !isNew;
                    setState(() {});
                  }),
                iconNButton('Add', icon2, func: () {
                  String id = idTC.text;
                  String name = nameTC.text;

                  if (isNew && name.isEmpty && id.isEmpty) {
                    peachyToast(context, 'Name and ID Reqiured!',
                        duration: 1000);
                    return;
                  }

                  if (id.isEmpty) {
                    peachyToast(context, 'ID Required!', duration: 1000);
                    return;
                  }

                  CONSTANT type = [
                    TYPE['CONTACT'],
                    TYPE['GROUP'],
                    TYPE['CHANNEL']
                  ][widget.type - 1];

                  if ((id == widget.user.id) ||
                      (widget.user.users!.get(id) != null) ||
                      (widget.user.groups!.get(id) != null) ||
                      (widget.user.channels!.get(id) != null)) {
                    peachyToast(context, '$type $id already exists!',
                        duration: 1000);
                    return;
                  }

                  String idType =
                      ['user_id', 'group_id', 'channel_id'][widget.type - 1];
                  Map map = {
                    'action': ACTION[isNew ? 'CREATE' : 'ADD'],
                    'type': type,
                    idType: id
                  };

                  if (isNew) {
                    map['name'] = name;
                    map['bio'] = bioTC.text;
                  }
                  var tag = Tag(map);
                  widget.client.send_action_tag(tag);
                  if (isNew)
                    widget.user.pending_created_objects[tag['id']] = tag;
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
