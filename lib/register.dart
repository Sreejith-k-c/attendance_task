import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRegister extends StatefulWidget {
  MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedBranch;

  Map<String, String> branchRoutes = {
    'Branch 1': '/branch1',
    'Branch 2': '/branch2',
    'Branch 3': '/branch3',
  };

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool('registered') == true) {
      _autoLogin();
    }
  }

  _autoLogin() async {
    String? email = _prefs.getString('email');
    String? password = _prefs.getString('password');
    if (email != null && password != null) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        String registeredEmail = userCredential.user!.email!;
        String? selectedBranch = _prefs.getString('branch');
        String? route = branchRoutes[selectedBranch!];

        if (route != null) {
          Navigator.pushReplacementNamed(context, route, arguments: registeredEmail);
        } else {
          print('Route for selected branch not found.');
        }
      } on FirebaseAuthException catch (e) {
        print('Auto-login failed: ${e.message}');
      } catch (e) {
        print('Auto-login failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign-Up",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              DropdownButton<String>(
                value: selectedBranch,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedBranch = newValue;
                    });
                  }
                },
                items: <String>[
                  'Branch 1',
                  'Branch 2',
                  'Branch 3',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedBranch != null) {
                    try {
                      UserCredential userCredential =
                          await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      await _prefs.setString('email', emailController.text);
                      await _prefs.setString('password', passwordController.text);
                      await _prefs.setString('branch', selectedBranch!);
                      await _prefs.setBool('registered', true);

                      String registeredEmail = userCredential.user!.email!;

                      String? route = branchRoutes[selectedBranch!];

                      if (route != null) {
                        Navigator.pushReplacementNamed(context, route, arguments: registeredEmail);
                      } else {
                        print('Route for selected branch not found.');
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    print('Please select a branch.');
                  }
                },
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
