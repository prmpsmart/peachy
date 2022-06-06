// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:peachy/backend/user_db.dart';
import 'package:peachy/backend/client.dart';
import 'package:peachy/backend/constants.dart';

import 'package:flutter/material.dart';
import '../ui_utils.dart';

class PeachyLogin extends P_StatefulWidget {
  Client? client;
  PeachyLogin(this.client);

  @override
  _PeachyLoginState createState() => _PeachyLoginState();
}

class _PeachyLoginState extends P_StatefulWidgetState<PeachyLogin>
    with SingleTickerProviderStateMixin {
  late AnimationController mainController;
  late Animation mainAnimation;

  late TextEditingController userCont;
  late TextEditingController passCont;

  Timer? statusTimer;

  Client get client => widget.client as Client;
  List<String> users = [];

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

    userCont = TextEditingController(text: client.user?.id);
    passCont = TextEditingController(text: client.user?.key ?? 'ade1');

    statusTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (client.alive) setState(() {});
    });

    User_DB.load_last_logged_user().then((value) {
      userCont.text = value.isEmpty ? client.user?.id ?? '' : value;
    });
  }

  @override
  void dispose() {
    statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => setState(() {}),
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
                      String id = userCont.text.trim();

                      if (userCont.text.isNotEmpty &&
                          passCont.text.isNotEmpty) {
                        await client.login(
                          id: id,
                          key: passCont.text.trim(),
                          receiver: (response) {
                            String toast = 'Login failed!';
                            bool succeed = RESPONSE['SUCCESSFUL'] == response;
                            if (succeed)
                              toast = 'Login Successful!';
                            else if (RESPONSE['EXTINCT'] == response)
                              toast = 'User doesn\'t exist!';
                            else if (RESPONSE['SIMULTANEOUS_LOGIN'] == response)
                              toast = 'User is already logged in!';
                            else if (RESPONSE['FALSE_KEY'] == response)
                              toast = 'Wrong password!';
                            peachyToast(context, toast, duration: 2000);
                            if (succeed) {
                              // Navigator.pop(context);
                              User_DB.update_last_logged_user(id);
                              Navigator.pushReplacementNamed(context, '/home',
                                  arguments: client);
                            }
                          },
                        );
                      } else
                        peachyToast(context, 'Username and Password required!',
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
