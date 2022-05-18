// ignore_for_file: must_be_immutable, non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:peachy/backend/client.dart';
import 'package:peachy/backend/constants.dart';
import 'package:peachy/backend/multi_users.dart';
import 'package:peachy/backend/tag.dart';
import 'package:peachy/backend/user.dart';
import '../ui_utils.dart';
import 'server_dialog.dart';

class MembersList extends StatefulWidget {
  final MultiUsers chat_object;
  const MembersList(this.chat_object) : super();

  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  MultiUsers get chat_object => widget.chat_object;
  User get user => chat_object.user;

  void send_tag(CONSTANT action, {String id = '', data}) {
    if ((id.isEmpty && (data == null) || (id == widget.chat_object.user.id)))
      return;
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    bool isSelfAdmin = chat_object.admins.contains(user.id);

    return Container(
      color: colors.backgroundColor,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: chat_object.users.length,
          itemBuilder: (BuildContext context, int index) {
            String user = chat_object.users[index];
            bool isAdmin = chat_object.admins.contains(user);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: MaterialButton(
                splashColor: colors.primaryColor,
                color: colors.colorScheme.secondary,
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext builder) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              color: colors.colorScheme.secondary,
                              padding: const EdgeInsets.all(8.0),
                              child: getText('Member: $user', size: 20)),
                          Container(
                            margin: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                if (isSelfAdmin && !isAdmin)
                                  MaterialButton(
                                      splashColor: colors.primaryColor,
                                      color: colors.colorScheme.secondary,
                                      onPressed: () {},
                                      child: getText('Add Admin', size: 15)),
                                if (isSelfAdmin && isAdmin)
                                  MaterialButton(
                                      splashColor: colors.primaryColor,
                                      color: colors.colorScheme.secondary,
                                      onPressed: () {},
                                      child: getText('Remove Admin', size: 15)),
                                if (isSelfAdmin)
                                  MaterialButton(
                                      splashColor: colors.primaryColor,
                                      color: colors.colorScheme.secondary,
                                      onPressed: () {},
                                      child:
                                          getText('Remove Member', size: 15)),
                                MaterialButton(
                                    splashColor: colors.primaryColor,
                                    color: colors.colorScheme.secondary,
                                    onPressed: () {},
                                    child:
                                        getText('Request Details', size: 15)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                onLongPress: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getText(user),
                    if (isAdmin)
                      Icon(Icons.admin_panel_settings_rounded, size: 30)
                  ],
                ),
              ),
            );
          }),
    );
    ;
  }
}

class ProfileDialog extends P_StatefulWidget {
  var chat_object;

  Client client;

  ProfileDialog(this.chat_object, this.client);

  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends P_StatefulWidgetState<ProfileDialog>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  get chat_object => widget.chat_object;
  User get user => chat_object.user;

  @override
  void listener() => setState(() {});

  void initState() {
    super.initState();
    widget.client.RECV_LOG.addListener(listener);

    _tabController = TabController(
        vsync: this, initialIndex: 0, length: chat_object.type == 1 ? 3 : 4);
    _tabController!.addListener(() {
      setState(() {});
    });
  }

  @override
  build(BuildContext context) {
    double padding = 10;
    double radius = 45;
    double iconSize = 23;

    String type = ['Contact', 'Group', 'Channel'][chat_object.type - 1];

    var tabs = [
      if (chat_object.type != 1)
        Tab(
            icon: Icon(Icons.person_search),
            child: Text('Members', style: TextStyle(fontSize: 10))),
      Tab(
          icon: Icon(Icons.file_copy_outlined),
          child: Text('Media', style: TextStyle(fontSize: 10))),
      Tab(
          icon: Icon(Icons.computer),
          child: Text('Docs', style: TextStyle(fontSize: 10))),
      Tab(
          icon: Icon(Icons.link_sharp),
          child: Text('Links', style: TextStyle(fontSize: 10)))
    ];
    bool isAdmin =
        chat_object.type != 1 ? chat_object.admins.contains(user.id) : false;

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
                  chat_object.name,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  chat_object.id,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  chat_object.bio,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
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
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          if (chat_object.type != 1)
                            MembersList(
                              chat_object as MultiUsers,
                            ),
                          Container(),
                          Container(),
                          Container(),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(height: 5),
                if (isAdmin) SizedBox(height: 5),
                if (isAdmin) iconNButton('Add Member', Icons.person_add),
                if (isAdmin) SizedBox(height: 5),
                if (!isAdmin && chat_object.type == 2)
                  if (isAdmin)
                    Row(
                      children: [
                        Checkbox(
                          onChanged: (bool? value) {
                            setState(() {
                              widget.client.send_tag(Tag({
                                'action': ACTION['ONLY_ADMIN'],
                                'user_id': value ?? false,
                                "type": TYPE['GROUP'],
                                'group_id': chat_object.id
                              }));
                            });
                          },
                          value: widget.chat_object.only_admin,
                        ),
                        getText('Only Admin', size: 15)
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
          if (chat_object.icon.isEmpty)
            profileImageWidget(context, padding, radius)
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.client.RECV_LOG.removeListener(listener);
    super.dispose();
  }
}

class ClientProfileDialog extends P_StatefulWidget {

  Client client;

  User get user => client.user as User;

  ClientProfileDialog(this.client);

  @override
  _ClientProfileDialogState createState() => _ClientProfileDialogState();
}

class _ClientProfileDialogState
    extends P_StatefulWidgetState<ClientProfileDialog> {
  bool nameBool = false;
  bool keyBool = false;
  bool bioBool = false;

  IconData editIcon = Icons.edit;
  IconData saveIcon = Icons.save;

  late TextEditingController nameTC;
  late TextEditingController keyTC;
  late TextEditingController bioTC;

  User get user => widget.user;

  @override
  void initState() {
    super.initState();
    widget.client.RECV_LOG.addListener(listener);

    nameTC = TextEditingController(text: user.name);
    keyTC = TextEditingController(text: user.key);
    bioTC = TextEditingController(text: user.bio);
  }

  void listener() => setState(() {});

  @override
  Widget build(BuildContext context) {
    double padding = 10;
    double radius = 45;

    EdgeInsets edge_padding = const EdgeInsets.symmetric(vertical: 2);

    Padding getDataView(
      TextEditingController tc,
      String text,
      String attr,
      bool value,
      void Function(bool) setValue,
    ) =>
        Padding(
          padding: edge_padding,
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
                  '$attr : ',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              getTextWidget(context, tc, value, FontWeight.w600, text,
                  obscureText: attr == 'Key', maxLines: attr == 'Bio' ? 3 : 1),
              SizedBox(
                  height: 25,
                  child: switchIconButton(
                      value ? saveIcon : editIcon,
                      () => setState(() {
                            if (value) {
                              if (tc.text != text) {
                                var tag = getChangeTag(
                                  TYPE['USER'],
                                  user.id,
                                  Tag({attr.toLowerCase(): tc.text}),
                                );
                                // tc.text = '';
                                user.set_pending_change_data(tag['data']);
                                widget.client.send_action_tag(tag);
                                print(tag);
                              }
                            }
                            setValue(!value);
                          }),
                      context)),
            ],
          ),
        );

    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.fromLTRB(
                padding, padding + radius, padding, padding),
            margin: EdgeInsets.only(top: radius, right: padding),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(padding),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getDataView(nameTC, user.name, 'Name', nameBool,
                    (bool value) => nameBool = value),
                Divider(height: 2),
                Padding(
                  padding: edge_padding,
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
                          'ID : ',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        user.id,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                Divider(height: 2),
                getDataView(keyTC, user.key, 'Key', keyBool,
                    (bool value) => keyBool = value),
                Divider(height: 2),
                getDataView(bioTC, user.bio, 'Bio', bioBool,
                    (bool value) => bioBool = value),
                Divider(height: 2),
                SizedBox(height: 5),
                Padding(
                  padding: edge_padding,
                  child: iconNButton(
                    'Update Data From Server',
                    Icons.data_saver_on_outlined,
                    func: () => widget.client.send_data(user.id),
                  ),
                ),
                Padding(
                  padding: edge_padding,
                  child: iconNButton(
                    'Change User',
                    Icons.person,
                    func: () => Navigator.pushNamed(context, '/createUser',
                        arguments: widget.client),
                  ),
                ),
                Padding(
                  padding: edge_padding,
                  child: iconNButton('Server Settings', Icons.settings,
                      func: () => showDialog(
                          context: context,
                          builder: (BuildContext builder) => ServerDialog())),
                ),
              ],
            ),
          ),
          profileImageWidget(context, 40, radius)
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.client.RECV_LOG.removeListener(listener);
    super.dispose();
  }
}
