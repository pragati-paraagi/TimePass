import 'package:flutter/material.dart';
import 'Welcome.dart';
import 'LogIn.dart';
import 'register.dart';
import 'chatScreen.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(

    MaterialApp

    (
      debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      primaryColor: Color(0xFFEB1555),
      scaffoldBackgroundColor: Color(0xFF111328),
    ),
    initialRoute: 'Welcome',
    routes: {
      'Welcome': (context)=> Welcome(),
      'LogIn': (context)=> LogIn(),
      'Register': (context)=> Register(),
      'chatScreen':(context)=> ChatScreen(),
      //'Home': (context)=> Home(),
    },
  ),);
}

