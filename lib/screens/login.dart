import 'dart:async';

import 'package:flutter/material.dart';
import '../backend/core.dart';
import '../backend/client.dart';
import '../constants.dart';

class PeachyLogin extends StatefulWidget {
  Client? client;
  PeachyLogin(this.client);

  @override
  _PeachyLoginState createState() => _PeachyLoginState();
}

class _PeachyLoginState extends State<PeachyLogin>
    with SingleTickerProviderStateMixin {
  late AnimationController mainController;
  late Animation mainAnimation;

  String username = 'ade1';
  String password = 'ade1';
  TextEditingController? userCont;
  TextEditingController? passCont;

  bool currentStatus = false;
  Timer? statusTimer;

  Client get client => widget.client as Client;

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

    userCont = TextEditingController(text: username);
    passCont = TextEditingController(text: password);

    statusTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (client.alive != currentStatus) {
        currentStatus = client.alive;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentStatus = client.alive;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                peachyLogo(context),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    client.alive ? 'Connected' : 'Not Connected',
                    style: TextStyle(
                        color: client.alive
                            ? Colors.green
                            : Theme.of(context).primaryColor),
                  ),
                ),
                CustomTextInput(
                  hintText: 'Username',
                  leading: Icons.person,
                  obscure: false,
                  // keyboard: TextInputType.emailAddress,
                  controller: userCont,
                ),
                CustomTextInput(
                    hintText: 'Password',
                    leading: Icons.lock,
                    obscure: true,
                    controller: passCont),
                SizedBox(height: 30),
                Hero(
                  tag: 'loginbutton',
                  child: CustomButton(
                    text: 'login',
                    accentColor: Theme.of(context).colorScheme.secondary,
                    mainColor: Theme.of(context).primaryColor,
                    onpress: () async {
                      if (!client.alive) {
                        Navigator.pop(context);
                        return;
                      }

                      if (username.isNotEmpty && password.isNotEmpty) {
                        User user = User(username, key: password);

                        client.login(
                          user: user,
                          receiver: (response) {
                            String toast = 'Login failed!';
                            bool succeed = RESPONSE['SUCCESSFUL'] == response;
                            if (succeed)
                              toast = 'Login Successful!';
                            else if (RESPONSE['EXTINCT'] == response)
                              toast = 'User doesn\'t exist!';
                            else if (RESPONSE['SIMULTANEOUS_LOGIN'] == response)
                              toast = 'User is already logged in!';
                            peachyToast(context, toast, duration: 5000);
                            if (succeed) {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/home',
                                  arguments: [user, client]);
                            }
                          },
                        );
                      } else
                        peachyToast(context, 'All fields are required!',
                            duration: 1500);
                    },
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup',
                          arguments: client);
                    },
                    child: Text(
                      'or create an account',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Theme.of(context).primaryColor),
                    )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                // peachyFooter(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
