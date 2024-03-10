import 'package:flutter/material.dart';
import 'package:attendance_task/admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BranchOneHome extends StatefulWidget {
  @override
  State<BranchOneHome> createState() => _BranchOneHomeState();
}

class _BranchOneHomeState extends State<BranchOneHome> {
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String registeredEmail;

  @override
  Widget build(BuildContext context) {
    registeredEmail = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Branch One',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Text(
                  'Email: $registeredEmail',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    _registerAttendance('First Time');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Click Here To Register Attendance (9:30) ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      )),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _registerAttendance('Second Time');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Click Here To Register Attendance (5:30)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttendanceDataPage(
                                registeredEmail: registeredEmail)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "Attendance History >",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  height: 200,
                ),
                // FloatingActionButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => MyRegister()),
                //     );
                //   },
                //   child: Icon(Icons.logout),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerAttendance(String time) async {
    try {
      await _firestore.collection('attendance').add({
        'branch': 'Branch 1',
        'time': time,
        'timestamp': DateTime.now(),
        'registered_email': registeredEmail,
      });
      print('Attendance registered for $time');
    } catch (e) {
      print('Error registering attendance: $e');
    }
  }
}
