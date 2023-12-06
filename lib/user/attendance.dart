import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Functions.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final TextEditingController _resonController = TextEditingController();
  List<Map<String, dynamic>> _employeeData = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay? clockInTime;
  TimeOfDay? clockOutTime;

  Future<void> fetchData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Attendance')
            .where('emporid', isEqualTo: user.uid)
            .get();
        _employeeData = querySnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                })
            .toList();
        setState(() {});
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching Attendance: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isClockIn) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isClockIn) {
          clockInTime = pickedTime;
        } else {
          clockOutTime = pickedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              const Text(
                "Send Attendance Report",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(350.0, 20.0),
                ),
                child: Text('Select Date: ${selectedDate.toLocal()}'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _selectTime(context, true),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(350.0, 20.0),
                ),
                child: Text('Clock In: ${clockInTime?.format(context) ?? 'Select Time'}'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _selectTime(context, false),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(350.0, 20.0),
                ),
                child: Text('Clock Out: ${clockOutTime?.format(context) ?? 'Select Time'}'),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _resonController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Enter your text',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  addAttendanceReport(
                    _employeeData[0]['id'],
                    _employeeData[0]['employeeFirstName'],
                    _employeeData[0]['employeeLastName'],
                    selectedDate.toString(),
                    clockInTime.toString(),
                    clockOutTime.toString(),
                    _resonController.text,
                    context
                    );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(350.0, 20.0),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
