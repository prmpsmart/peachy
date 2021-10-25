// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:peachy/backend/connection.dart';
import 'package:peachy/widgets/toast.dart';
import '../constants.dart';
import '../widgets/chat_list.dart';
import '../dialogs/profile_dialog.dart' as profile;
import '../backend/client.dart' as _client;

class PeachyHome extends StatefulWidget {
  _client.User user;
  _client.Client client;

  PeachyHome(this.user, this.client);

  @override
  _PeachyHomeState createState() => _PeachyHomeState();
}

class _PeachyHomeState extends State<PeachyHome>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  //
  // MethodChannel peachyToast = MethodChannel('peachyToast');

  late TabController tabController;

  late FToast fToast;
  bool sentConnect = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    tabController = TabController(vsync: this, initialIndex: 0, length: 3);
    tabController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
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

  bool get online => widget.client.alive;

  @override
  Widget build(BuildContext context) {
    widget.client.statusWatcher = (bool value) {
      setState(() {});
      if (!value)
        CONNECT(widget.client, () => setState(() {}), context,
            () => this.sentConnect, (value) => this.sentConnect = value,
            showToast: true);
      widget.client.re_login();
    };

    var list = ModalRoute.of(context)!.settings.arguments as List?;

    if (list != null) {
      widget.user = list[0];
      widget.client = list[1];
    }

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

    Tab generateTab(String tabName, IconData tabIcon) => Tab(
          child: Tooltip(
            message: tabName,
            child: Icon(tabIcon, size: 30),
          ),
        );

    return WillPopScope(
      onWillPop: () {
        widget.client.logout();
        return onWillPop(context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.account_circle),
            iconSize: 25.0,
            color: Colors.white,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext builder) {
                    return profile.ClientProfileDialog(widget.user);
                  });
              print('Account Info');
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Peachy',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              Tooltip(
                message: online ? 'Online' : 'Offline',
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                      online
                          ? Icons.check_circle_rounded
                          : Icons.highlight_off_outlined,
                      color: online ? Colors.green : Colors.red,
                      size: 20),
                ),
              )
            ],
          ),
          elevation: 2,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              iconSize: 25.0,
              color: Colors.white,
              onPressed: () => print('Search'),
            ),
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
        body: TabBarView(
          controller: tabController,
          children: [
            ChatList(widget.user, 1),
            ChatList(widget.user, 2),
            ChatList(widget.user, 3)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          onPressed: () {},
          tooltip: 'New $text',
          child: Icon(
            icon,
            size: 35,
          ),
        ),
      ),
    );
  }
}
