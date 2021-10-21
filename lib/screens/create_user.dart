import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../backend/connection.dart';
import '../backend/client.dart';
import '../dialogs/server_dialog.dart';
import '../constants.dart';

class CreateUser extends StatefulWidget {
  final bool isProfile;

  CreateUser(this.isProfile);

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser>
    with SingleTickerProviderStateMixin {
  late AnimationController mainController;
  late Animation mainAnimation;
  Client? client;

  bool sentConnect = false;

  bool get alive => client?.alive ?? false;

  statusWatcher(bool value) {
    print('create_user._CreateUserState.statusWatcher: $value');
    if (!value)
      connect();
    else
      setState(() {});
  }

  void connect() async {
    print('here');
    if (ServerSettings.loaded) {
      if (client == null)
        client = Client(ServerSettings.ip as String, ServerSettings.port as int,
            statusWatcher: statusWatcher);

      CONNECT(client as Client, () => setState(() {}), context,
          () => this.sentConnect, (value) => this.sentConnect = value,
          showToast: true);
    }
  }

  @override
  void initState() {
    super.initState();
    mainController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    mainAnimation = ColorTween(
      begin: materialColor('#d85461'),
      end: Color(0xFFFEF9EB),
    ).animate(mainController);
    mainController.forward();
    mainController.addListener(() {
      setState(() {});
    });

    ServerSettings.load();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Timer(Duration(seconds: 2), connect);
    });
  }

  bool get isProfile => widget.isProfile;

  @override
  Widget build(BuildContext context) {
    Flexible spacer(double space) => Flexible(
        child: SizedBox(height: MediaQuery.of(context).size.height * space));

    void changeToNamed(String named) {
      if (alive)
        Navigator.pushNamed(context, named, arguments: client);
      else
        peachyToast(context, 'No connection!');
    }

    String connectionString;
    Color connectionColor;

    if (alive) {
      connectionString = 'Connected';
      connectionColor = Colors.green;
    } else if (sentConnect) {
      connectionString = 'Connecting...';
      connectionColor = Colors.orange;
    } else {
      connectionString = 'Not Connected';
      connectionColor = Colors.red;
    }

    Scaffold scaffold = Scaffold(
      backgroundColor: mainAnimation.value,
      body: SafeArea(
        child: Container(
          color: mainAnimation.value,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                peachyLogo(context),
                spacer(.1),
                TextButton(
                  // onPressed: () {},
                  onPressed: connect,
                  child: Text(
                    connectionString,
                    style: TextStyle(color: connectionColor),
                  ),
                ),
                spacer(.05),
                Hero(
                  tag: 'loginbutton',
                  child: CustomButton(
                    text: 'Login',
                    accentColor: Theme.of(context).primaryColor,
                    onpress: () => changeToNamed('/login'),
                  ),
                ),
                SizedBox(height: 10),
                Hero(
                  tag: 'signupbutton',
                  child: CustomButton(
                    text: 'signup',
                    accentColor: Theme.of(context).colorScheme.secondary,
                    mainColor: Theme.of(context).primaryColor,
                    onpress: () => changeToNamed('/signup'),
                  ),
                ),
                spacer(.05),
                TextButton(
                  onPressed: () {
                    showDialog(
                        context: context, builder: (context) => ServerDialog());
                  },
                  child: Text('Server Settings'),
                ),
                // peachyFooter(context)
              ],
            ),
          ),
        ),
      ),
    );

    return isProfile
        ? scaffold
        : WillPopScope(onWillPop: () => onWillPop(context), child: scaffold);
  }
}
