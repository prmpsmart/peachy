import 'package:flutter/material.dart';
import 'package:peachy/widgets/chat_list.dart';
import 'package:peachy/constants.dart' as data;
import 'package:peachy/widgets/profile_dialog.dart' as profile;

class Home extends StatefulWidget {
  final data.User user;
  Home(this.user);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool showFab = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
    _tabController.addListener(() {
      showFab = _tabController.index == 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  return profile.PersonalProfileDialog(widget.user);
                });
            print('Account Info');
          },
        ),
        title: Text(
          'Peachy',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
        children: <Widget>[
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
