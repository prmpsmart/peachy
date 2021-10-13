import 'package:flutter/material.dart';
import 'screens/create_user.dart';
import 'screens/login.dart';
import 'screens/peachy_screen.dart';
import 'backend/client.dart' as _client;
import 'constants.dart';
import 'screens/peachy_splash.dart';
import 'screens/signup.dart';

void main() {
  runApp(
    PeachyApp(),
  );
}

class PeachyApp extends StatelessWidget {
  _client.User user;
  _client.Client client;
  PeachyApp() {
    // client = _client.Client('ip', port);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peachy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: materialColor('#d85461'),
        accentColor: Color(0xFFFEF9EB),
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      // home: wid,

      initialRoute: '/splash',
      routes: {
        '/splash': (context) => PeachySplash(user),
        '/home': (context) => PeachyHome(user),
        '/login': (context) => PeachyLogin(),
        '/signup': (context) => PeachySignUp(),
        '/createUser': (context) => CreateUser(),
      },
    );
  }
}
