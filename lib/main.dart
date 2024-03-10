import 'package:attendance_task/branch1/branch1_home.dart';
import 'package:attendance_task/branch2/branch2_home.dart';
import 'package:attendance_task/branch3/branch3_home.dart';
import 'package:attendance_task/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/', 
      routes: {
        '/': (context) => MyRegister(),
        '/branch1': (context) => BranchOneHome(),
        '/branch2': (context) => BranchTwoHome(),
        '/branch3': (context) => BranchThreeHome(),
      },
    );
  }
}
