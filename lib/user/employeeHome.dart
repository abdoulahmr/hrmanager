import 'package:asi_project/Functions.dart';
import 'package:flutter/material.dart';
import 'profile.dart';
import 'leave.dart';
import 'attendance.dart';

class EmployeeHome extends StatelessWidget {
  const EmployeeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    width: 150,
                    height: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfilePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),                    
                  ),
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    width: 150,
                    height: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LeavRequest()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'Leave',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    )
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    width: 150,
                    height: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AttendancePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'Attendance',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20.0),   
                    width: 150,
                    height: 150,                 
                    child: ElevatedButton(
                      onPressed: () {
                        signOut(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}
