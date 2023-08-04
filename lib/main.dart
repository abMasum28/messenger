import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messenger/screens/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyChat());
}
class MyChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme:const TextTheme(
          bodyText2: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      home:  const WelcomeScreen(),
    );
  }
}
