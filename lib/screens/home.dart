import 'package:flutter/material.dart';
import 'package:peachy/widgets/chat_list.dart';

class Home extends StatefulWidget {
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
          icon: Icon(Icons.menu),
          iconSize: 25.0,
          color: Colors.white,
          onPressed: () {},
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
            onPressed: () {},
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
        children: <Widget>[ChatList(0), ChatList(0), ChatList(0)],
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              onPressed: () => print('open chats'),
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
