// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:peachy/backend/constants.dart';
import 'package:peachy/backend/client.dart';
import 'package:peachy/backend/user.dart';
import 'package:peachy/backend/user_db.dart';
import '../connection.dart';
import '../ui_utils.dart';
import '../dialogs/new_dialog.dart';
import '../widgets/chat_list.dart';
import '../dialogs/profile_dialog.dart';

class PeachyHome extends ConnectionWidget {
  PeachyHome(Client? client) : super(client);

  @override
  _PeachyHomeState createState() => _PeachyHomeState();
}

class _PeachyHomeState extends ConnectionWidgetState<PeachyHome>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController tabController;

  final key = GlobalKey<ScaffoldState>();
  late ClientProfileDialog clientDialog;

  User get user => widget.user as User;

  void listener() => null;

  @override
  void initState() {
    clientDialog = ClientProfileDialog(client);
    WidgetsBinding.instance?.addObserver(this);

    tabController = TabController(vsync: this, initialIndex: 0, length: 3);
    tabController.addListener(() => setState(() {}));

    widget.client.RECV_LOG.addListener(listener);

    User.FINISHED_LOADING.addListener(
      () {
        setState(
          () {
            print('finished loading');
          },
        );
      },
    );
    User_DB.load_user_data(user);

    super.initState();
  }

  @override
  statusWatcher(bool alive) {
    super.statusWatcher(alive);
    if (alive && !online)
      client.login(receiver: (response) {
        String toast = 'Login FAILED!';
        bool succeed = RESPONSE['SUCCESSFUL'] == response;
        if (succeed)
          toast = 'Login SUCCESSFUL!';
        else if (RESPONSE['SIMULTANEOUS_LOGIN'] == response)
          toast = 'SIMULTANEOUS_LOGIN!';
        else if (RESPONSE['FALSE_KEY'] == response) toast = 'Wrong Pasword!';
        peachyToast(context, toast, duration: 2000);
        setState(() {});
      });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String text;

    switch (tabController.index) {
      case 0:
        icon = Icons.person_add;
        text = 'Contact';
        break;
      case 1:
        icon = Icons.group_add;
        text = 'Group';
        break;
      default:
        icon = Icons.notification_add;
        text = 'Channel';
        break;
    }

    var iconData = Icons.highlight_off_outlined;
    String tip = 'OFFLINE';
    if (online) {
      iconData = Icons.check_circle_rounded;
      tip = 'ONLINE';
    } else if (alive) {
      iconData = Icons.access_time;
      tip = 'CONNECTED';
    }

    Tab generateTab(String tabName, IconData tabIcon) => Tab(
          child: Tooltip(
            message: tabName,
            child: Icon(tabIcon, size: 30),
          ),
        );

    scaffold = Scaffold(
      key: key,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.account_circle),
            iconSize: 25.0,
            color: Colors.white,
            onPressed: () {
              if (key.currentState != null) key.currentState!.openDrawer();
            }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              user.name.isNotEmpty ? user.name : user.id,
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            Tooltip(
              message: tip,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(25)),
                child: IconButton(
                  icon: Icon(iconData, color: Colors.white, size: 25),
                  iconSize: 25.0,
                  onPressed: () => statusWatcher(alive),
                ),
              ),
            )
          ],
        ),
        elevation: 2,
        actions: [
          IconButton(
              icon: Icon(Icons.person_search_rounded),
              iconSize: 25.0,
              color: Colors.white,
              onPressed: () {
                print('');
                User_DB.load_user_data(user);
              }),
        ],
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          tabs: [
            generateTab('Contacts', Icons.person),
            generateTab('Groups', Icons.group),
            generateTab('Channels', Icons.notifications),
          ],
        ),
      ),
      drawer: clientDialog,
      endDrawer: NewChatObject(client, tabController.index + 1),
      body: TabBarView(
        controller: tabController,
        children: [
          ChatList(widget, 1),
          ChatList(widget, 2),
          ChatList(widget, 3)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: () {
          if (key.currentState != null) key.currentState!.openEndDrawer();
        },
        tooltip: 'New $text',
        child: Icon(
          icon,
          size: 35,
        ),
      ),
    );

    return super.build(context);
  }

  @override
  void dispose() {
    widget.client.RECV_LOG.removeListener(listener);
    WidgetsBinding.instance?.removeObserver(this);
    client.logout();
    client.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;
    final isResumed = state == AppLifecycleState.resumed;

    if (isBackground) {
    } else if (isResumed) {}
  }
}
