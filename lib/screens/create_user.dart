// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peachy/backend/client.dart';
import 'package:peachy/dialogs/server_dialog.dart';
import '../networking/connection.dart';
import '../constants.dart';

class CreateUser extends ConnectionWidget {
  CreateUser(bool showPop, Client? client) : super(showPop, client);

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends ConnectionWidgetState<CreateUser>
    with SingleTickerProviderStateMixin {
  late AnimationController mainController;
  late Animation mainAnimation;

  @override
  void initState() {
    mainController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    mainAnimation = ColorTween(
      begin: materialColor('#d85461'),
      end: Color(0xFFFEF9EB),
    ).animate(mainController);
    mainController.forward();
    mainController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  bool get showPop => widget.showPop;

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

    scaffold = Scaffold(
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

    return super.build(context);
  }
}
