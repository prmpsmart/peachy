import 'package:flutter/material.dart';
import '../widgets/chat_list.dart';
import '../widgets/profile_dialog.dart' as profile;
import '../backend/client.dart' as _client;

class PeachyHome extends StatefulWidget {
  _client.User user;
  PeachyHome(this.user);

  @override
  _PeachyHomeState createState() => _PeachyHomeState();
}

class _PeachyHomeState extends State<PeachyHome>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool showFab = true;
  bool online = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
    _tabController?.addListener(() {
      showFab = _tabController?.index == 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _client.User _user =
        ModalRoute.of(context)!.settings.arguments as _client.User;

    widget.user = _user;

    return Scaffold(
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
              child: Icon(
                online
                    ? Icons.check_circle_rounded
                    : Icons.highlight_off_outlined,
              ),
            )
          ],
        ),
        elevation: 2,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 25.0,
            color: Colors.white,
            onPressed: () => print('Search'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          tabs: <Widget>[
            Tab(text: "Contacts"),
            Tab(text: "Groups"),
            Tab(text: "Channels"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatList(widget.user, 1),
          ChatList(widget.user, 2),
          ChatList(widget.user, 3)
        ],
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              onPressed: () => print('New Chat'),
              tooltip: 'New Message',
              child: Icon(
                Icons.message,
                size: 35,
              ),
            )
          : null,
    );
  }
}
